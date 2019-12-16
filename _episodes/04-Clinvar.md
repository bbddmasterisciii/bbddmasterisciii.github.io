---
title: "Creación de nuevas tablas"
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
[ClinVar](https://www.ncbi.nlm.nih.gov/clinvar/){:target="_blank"} es una base de datos pública y de acceso gratuito que contiene la relación entre variantes génicas y fenotipos humanos con evidencia de apoyo. 
De este modo, ClinVar facilita el acceso a la información entre la variaciones humanas y el estado de salud observado, y la historia de esa interpretación. 
ClinVar procesa las solicitudes que informan de las variantes encontradas en muestras de pacientes, afirmaciones hechas con respecto 
a su importancia clínica, información sobre el remitente y otros datos de respaldo. Los alelos descritos en los datos se asignan a 
secuencias de referencia y se informan de acuerdo con el estándar [HGVS](https://onlinelibrary.wiley.com/doi/full/10.1002/humu.22981){:target="_blank"}. 
Para más informacióm, podeis consultar la web de [ClinVar](https://www.ncbi.nlm.nih.gov/clinvar/docs/help){:target="_blank"}.

Un volcado de los contenidos de ClinVar está disponible en <ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/>{:target="_blank"}. Dicho contenido en formato tabular se puede descargar de la carpeta `tab_delimited`,
eligiendo el archivo comprimido [variant_summary.txt.gz](ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz){:target="_blank"}. 


> ## 1. Creación de una o más tablas para guardar datos de ClinVar
>
> Para saber qué contiene realmente el archivo comprimido sin extraerlo por completo (podrían ser cientos de MBs), lo mejor es extraer sólo las primeras líneas, para tener una muestra y saber los nombres de sus columnas: 
>
> ~~~bash
> file variant_summary.txt.gz
> gunzip -c variant_summary.txt.gz | wc -l
> gunzip -c variant_summary.txt.gz | head -n 3 > variant_summary_header.txt
> head -n 1 variant_summary_header.txt | tr "\t" "\n" | nl -v 0 > variant_summary_columns.txt
> ~~~
> {: .bash}
>
> Gracias a los dos primeros comandos confirmamos que es un fichero comprimido, y que tiene más de un millón de líneas de datos.
>
> Con el comando `less -S` podemos comprobar que la primera línea del fichero generado `variant_summary_header.txt` es la cabecera,
> y que contiene los nombres de las columnas de datos.
> Dicho fichero también puede ser visualizado con cualquier hoja de cálculo que acepte ficheros tabulares,
> asegurando que usa como separador de columnas el tabulador. 
>
> El fichero generado `variant_summary_header.txt` muestra el número de columna (empezando en o, como en Python) junto con el nombre de la misma.
>
> Para sacarle partido a tanto contenido, podemos escribir un programa similar a [clinvar_parser.py]({{ page.root }}{% link files/clinvar_parser.py %}){:target="_blank"}.
> Estos programas de carga de ficheros tabulares suelen estar divididos en dos secciones: declaraciones de base de datos para la inicialización, y carga de datos en una o más tablas.
>
> En el caso de este programa, hemos puesto todas las declaraciones de creación de tablas en un array, y usamos las dobles comillas triples para poder tener declaraciones de tablas de varias líneas.
>
> La tabla más importante de todo este programa es **`variant`**, ya que contendrá una entrada por cada línea leída. Para algunas columnas, como `name`, `ref_allele` o `gene_id` no hay siempre valores, con lo que no se pueden imponer restricciones demasiado fuertes.
>
> ~~~sql
> CREATE TABLE IF NOT EXISTS variant (
> 	ventry_id INTEGER PRIMARY KEY AUTOINCREMENT,
> 	allele_id INTEGER NOT NULL,
> 	name VARCHAR(256),
> 	type VARCHAR(256) NOT NULL,
> 	dbSNP_id INTEGER NOT NULL,
> 	phenotype_list VARCHAR(4096),
> 	gene_id INTEGER,
> 	gene_symbol VARCHAR(64),
> 	HGNC_ID VARCHAR(64),
> 	assembly VARCHAR(16),
> 	chro VARCHAR(16) NOT NULL,
> 	chro_start INTEGER NOT NULL,
> 	chro_stop INTEGER NOT NULL,
> 	ref_allele VARCHAR(4096),
> 	alt_allele VARCHAR(4096),
> 	cytogenetic VARCHAR(64),
> 	variation_id INTEGER NOT NULL
> )
> ~~~
> {: .sql}
>
> Tras observar concienzudamente los datos, nos vamos a dar cuenta de que, aunque sería posible definir una clave primaria bastante compleja, es más efectivo utilizar una autoincremental.
>
> De todas las columnas disponibles se puede extraer información secundaria, como la *clinical signature*, *review status* o *variant phenotypes*, que irá a tablas accesorias:
>
> ~~~sql
> CREATE TABLE IF NOT EXISTS clinical_sig (
> 	ventry_id INTEGER NOT NULL,
> 	significance VARCHAR(64) NOT NULL,
> 	FOREIGN KEY (ventry_id) REFERENCES variant(ventry_id)
> 		ON DELETE CASCADE ON UPDATE CASCADE
> )
> ~~~
> {: .sql}
>
> ~~~sql
> CREATE TABLE IF NOT EXISTS review_status (
> 	ventry_id INTEGER NOT NULL,
> 	status VARCHAR(64) NOT NULL,
> 	FOREIGN KEY (ventry_id) REFERENCES variant(ventry_id)
> 		ON DELETE CASCADE ON UPDATE CASCADE
> )
> ~~~
> {: .sql}
>
> ~~~sql
CREATE TABLE IF NOT EXISTS variant_phenotypes (
	ventry_id INTEGER NOT NULL,
	phen_group_id INTEGER NOT NULL,
	phen_ns VARCHAR(64) NOT NULL,
	phen_id VARCHAR(64) NOT NULL,
	FOREIGN KEY (ventry_id) REFERENCES variant(ventry_id)
		ON DELETE CASCADE ON UPDATE CASCADE
)
> ~~~
> {: .sql}
>
 {: .callout}
