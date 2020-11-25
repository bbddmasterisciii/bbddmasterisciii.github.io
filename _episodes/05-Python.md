---
title: "Carga masiva de datos en nuevas tablas"
teaching: 15
exercises: 60
questions:
- "Cómo podemos insertar miles de tuplas de forma automática"
objectives:
- "Conocer el fundamento de la programación relacionada con SQL desde Python"
- "Leer ficheros de nuestro ordenador e insertar la información relevante en una base de datos relacional"
- "Consultar desde Python una base de datos y extraer determinados campos"
keypoints:
- "Casi cualquier gestor de base de datos tiene un interfaz de consulta para ser usado desde cualquier lenguaje de programación"
- "Para SQLite se usa en Python el paquete `sqlite3`"
---


> ## 1. Creación de un script de python para insertar datos de ClinVar
> Dentro del código Python, lo primero que se hará es ejecutar todas estas sentencias SQL, existan o no las tablas. Por ello se ha usado la variante `IF NOT EXISTS`:
>
> ~~~python
> db = sqlite3.connect(db_file)
> 
> cur = db.cursor()
> try:
> 	# Let's enable the foreign keys integrity checks
> 	cur.execute("PRAGMA FOREIGN_KEYS=ON")
> 	
> 	# And create the tables, in case they were not previously
> 	# created in a previous use
> 	for tableDecl in CLINVAR_TABLE_DEFS:
> 		cur.execute(tableDecl)
> except sqlite3.Error:
> 	print("An error occurred: {}".format(e.args[0]), file=sys.stderr)
> finally:
> 	cur.close()
> ~~~
> {: .python}
>
> Para leer el fichero tabular comprimido es abrirlo con la librería [gzip](https://docs.python.org/3/library/gzip.html){:target="_blank"}:
>
> ~~~python
> with gzip.open(clinvar_file,"rt",encoding="utf-8") as cf:
> 	headerMapping = None
> ~~~
> {: .python}
>
> Lo primero que se hará es averiguar el nombre de las columnas, y sus posiciones, preservando esa información para su uso a posteriori:
>
> ~~~python
> for line in cf:
> 	# First, let's remove the newline
> 	wline = line.rstrip("\n")
> 	
> 	# Now, detecting the header
> 	if (headerMapping is None) and (wline[0] == '#'):
> 		wline = wline.lstrip("#")
> 		columnNames = re.split(r"\t",wline)
> 		
> 		headerMapping = {}
> 		# And we are saving the correspondence of column name and id
> 		for columnId, columnName in enumerate(columnNames):
> 			headerMapping[columnName] = columnId
> ~~~
> {: .python}
>
> Dentro del código Python la inserción de datos es relativamente simple, requiriendo ajustes en los valores recuperados para traducir `-` a `None`.
> Como otras tablas de datos correlacionados necesitarán el valor asignado a `ventry_id` mediante el autoincremental, después de la inserción
> el cursor nos proporcionará dicho dato mediante `cur.lastrowid`:
>
> ~~~python
>	else:
>		# We are reading the file contents	
>		columnValues = re.split(r"\t",wline)
>		
>		# As these values can contain "nulls", which are
>		# designed as '-', substitute them for None
>		for iCol, vCol in enumerate(columnValues):
>			if len(vCol) == 0 or vCol == "-":
>				columnValues[iCol] = None
>		
>		# And extracting what we really need
>		# Table variation
>		allele_id = int(columnValues[headerMapping["AlleleID"]])
>		name = columnValues[headerMapping["Name"]]
>		allele_type = columnValues[headerMapping["Type"]]
>		dbSNP_id = columnValues[headerMapping["RS# (dbSNP)"]]
>		phenotype_list = columnValues[headerMapping["PhenotypeList"]]
>		assembly = columnValues[headerMapping["Assembly"]]
>		chro = columnValues[headerMapping["Chromosome"]]
>		chro_start = columnValues[headerMapping["Start"]]
>		chro_stop = columnValues[headerMapping["Stop"]]
>		ref_allele = columnValues[headerMapping["ReferenceAllele"]]
>		alt_allele = columnValues[headerMapping["AlternateAllele"]]
>		cytogenetic = columnValues[headerMapping["Cytogenetic"]]
>		variation_id = int(columnValues[headerMapping["VariationID"]])
>		
>		gene_id = columnValues[headerMapping["GeneID"]]
>		gene_symbol = columnValues[headerMapping["GeneSymbol"]]
>		HGNC_ID = columnValues[headerMapping["HGNC_ID"]]
>		
>		cur.execute("""
>			INSERT INTO variant(
>				allele_id,
>				name,
>				type,
>				dbsnp_id,
>				phenotype_list,
>				gene_id,
>				gene_symbol,
>				hgnc_id,
>				assembly,
>				chro,
>				chro_start,
>				chro_stop,
>				ref_allele,
>				alt_allele,
>				cytogenetic,
>				variation_id)
>			VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
>		""", (allele_id,name,allele_type,dbSNP_id,phenotype_list,gene_id,gene_symbol,HGNC_ID,assembly,chro,chro_start,chro_stop,ref_allele,alt_allele,cytogenetic,variation_id))
>		
>		# The autoincremented value is got here
>		ventry_id = cur.lastrowid
>		
>		# Clinical significance
>		significance = columnValues[headerMapping["ClinicalSignificance"]]
>		if significance is not None:
>			prep_sig = [ (ventry_id, sig)  for sig in re.split(r"/",significance) ]
>			cur.executemany("""
>				INSERT INTO clinical_sig(
>					ventry_id,
>					significance)
>				VALUES(?,?)
>			""", prep_sig)
>		
>		# Review status
>		status_str = columnValues[headerMapping["ReviewStatus"]]
>		if status_str is not None:
>			prep_status = [ (ventry_id, status)  for status in re.split(r", ",status_str) ]
>			cur.executemany("""
>				INSERT INTO review_status(
>					ventry_id,
>					status)
>				VALUES(?,?)
>			""", prep_status)
>		
>		# Variant Phenotypes
>		variant_pheno_str = columnValues[headerMapping["PhenotypeIDS"]]
>		if variant_pheno_str is not None:
>			variant_pheno_list = re.split(r";",variant_pheno_str)
>			prep_pheno = []
>			for phen_group_id, variant_pheno in enumerate(variant_pheno_list):
>				variant_annots = re.split(r",",variant_pheno)
>				for variant_annot in variant_annots:
>					phen = variant_annot.split(":")
>					if len(phen) > 1:
>						phen_ns , phen_id = phen[0:2]
>						prep_pheno.append((ventry_id,phen_group_id,phen_ns,phen_id))
>					elif variant_annot != "na":
>						print("DEBUG: {}\n\t{}\n\t{}".format(variant_annot,variant_pheno_str,line),file=sys.stderr)
>			
>			cur.executemany("""
>				INSERT INTO variant_phenotypes(
>					ventry_id,
>					phen_group_id,
>					phen_ns,
>					phen_id)
>				VALUES(?,?,?,?)
>			""", prep_pheno)
> ~~~
> {: .python}
>
> El programa se ejecutaría de la siguiente manera, dando como resultado un fichero de base de datos SQLite con todo el contenido extraído de ClinVar, listo para ser consultado programáticamente o mediante *shell* de SQLite:
>
> ~~~bash
> python3 clinvar_parser.py clinvar.db variant_summary.txt.gz
> sqlite3 clinvar.db 'SELECT COUNT(*) FROM variant'
> ~~~
> {: .bash}
>
 {: .callout}
