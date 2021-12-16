---
title: "Acceso mediante programa a la base de datos."
teaching: 15
exercises: 60
questions:
- "¿Cómo podemos insertar miles de tuplas de forma automática?"
objectives:
- "Conocer el fundamento de la programación relacionada con SQL desde Python."
- "Leer ficheros de nuestro ordenador e insertar la información relevante en una base de datos relacional."
- "Consultar desde Python una base de datos y extraer determinados campos."
keypoints:
- "Casi cualquier gestor de base de datos tiene un interfaz de consulta para ser usado desde cualquier lenguaje de programación."
- "Para SQLite se usa el paquete [sqlite3](https://docs.python.org/3/library/sqlite3.html)."
- "Podemos poner restricciones a la hora de hacer consultas usando la sección `WHERE`. Esto además puede conjuntarse con otros operadores como `LIKE`."
- "Con las consultas de agregación podemos hacer cálculos para contar el número de registros, entre otros."

---
Ayer creamos dos tablas llamadas **SWISSENTRY** y **ACCNUMBERS** en nuetra base de datos e insertamos un par de registros. A lo largo de la tarde de hoy, veremos como automatizar esto.

>## 1. Inserción en una base de datos desde Python
>Para ello vamos a descargar o el [programa (uniprotInsert-alt.py)]({{ page.root }}/files/uniprotInsert-alt.py) [(versión HTML)]({{ page.root }}/files/uniprotInsert-alt_py.html){:target="_blank"} o el [programa (uniprotInsert.py)]({{ page.root }}/files/uniprotInsert.py) [(versión HTML)]({{ page.root }}/files/uniprotInsert_py.html){:target="_blank"} y los iremos comentando juntos.
>Para visualizar el código con colores, tal y como aparece en el fichero HTML, podéis activar el destacado de sintaxis en vuestro programa de edición.
>
> Una vez repasado el programa, descargaremos un [fichero de muestra]({{ page.root }}/files/UniProt-Sample.txt){:target="_blank"}
a nuestro ordenador y lo usaremos junto con el programa recién estudiado para insertar 4 registros.
> Si todo ha funcionado correctamente, haremos lo mismo con el proteoma de dos organismos: [Mycoplasma mycoides]({{ page.root }}/files/MYCMS.dat){:target="_blank"} y [Staphylococcus aureus]({{ page.root }}/files/STAAN.dat){:target="_blank"}
{: .callout}

>## 2. Consultas de agregación
>Mediante consulta vamos a: 
>* Recuperar una entrada por su accession number principal. 
>* Recuperar las entradas que tengan un peso molecular entre 30000 y 90000. 
>* Recuperar las entradas cuya descripción contenga la palabra "kinase". 
>
>Mediante consultas de agregación, vamos a obtener los siguientes valores: 
>* Número de entradas de UniProt insertadas. 
>* Número de entradas de UniProt con una secuencia de más de 300 aminoácidos. 
>* Longitud media de las secuencias insertadas. 
>* Longitud de mayor tamaño de las secuencias insertadas.
>* Identificador de la proteína con mayor tamaño.
>* Calcular el número de accession number que hay por entrada. 
>
{: .callout}


>## 3. Creación de un fichero desde Python, usando información de la base de datos
>En este caso vamos a hacer el caso contrario, es decir, vamos a crear un programa en Python que automáticamente hará consultas a la base de datos de unos campos determinados. Los resultados de esa consulta se procesarán con Python para crear un fichero. De forma más concreta vamos a seleccionar los identificadores y descripción de cada proteína almacenada en nuestra base de datos y su secuencia
> y con ello vamos a crear un fichero en formato [FASTA](https://es.wikipedia.org/wiki/Formato_FASTA){:target="_blank"}.
> El programa lo podéis descargar desde este [link (fasta_write.py)]({{ page.root }}/files/fasta_write.py) y
para poder revisarlo juntos, podéis pinchar en la [versión HTML]({{ page.root }}/files/fasta_write_py.html){:target="_blank"} donde aparece el programa con la sintaxis destacada en colores.
>
{: .callout}

> ## ¿Cómo recuperarias el ID y el tamaño de secuencia de la proteína con accnumber Q7A6N0?
>
> Para resolver esta pregunta tenemos que introducir dos valores en el select, el id y el tamaño de secuencia (length(seq))
>
> > ## Solution
> >
> > ~~~sql
> > SELECT id, length(seq) FROM SWISSENTRY WHERE accnumber = 'Q7A6N0';
> > ~~~
> > {: .sql}
> >
> > |id                 |length(seq)    |
> > |-------------------|---------------|
> > |Q7A6N0_STAAN       |16             |
> {: .solution}
{: .challenge}

> ## ¿Cuantas proteínas hay de membrana?
>
> Tenemos que usar la función para contar (COUNT) y además el LIKE.
>
>
> > ## Solution
> >
> > ~~~sql
> > select count(*) from SWISSENTRY where description LIKE '%membrane%';
> > ~~~
> > {: .sql}
> >
> > |count(*)      |
> > |--------------|
> > |11            |
> {: .solution}
{: .challenge}
