---
title: "Acceso mediante programa a la base de datos."
teaching: 15
exercises: 60
questions:
- "¿Como podemos insertar miles de tuplas de forma automática?"
objectives:
- "Conocer el fundamento de la programación relacionada con SQL desde Python."
- "Leer ficheros de nuestro ordenador e insertar la información relevante en una base de datos relacional."
- "Consultar desde Python una base de datos y extraer determinados campos."
keypoints:
- "Casi cualquier gestor de base de datos tiene un interfaz de consulta para ser usado desde cualquier lenguaje de programación."
- "Para SQLite se usa el paquete sqlite3."
- "Podemos poner restricciones a la hora de hacer consultas usando WHERE. Esto además puede conjuntarse con otras sentencias como LIKE."
- "Con las consultas de agregación podemos hacer cálculos para contar el número de registros, entre otros."

---
Ayer creamos dos tablas llamadas **SWISSENTRY** y **ACCNUMBERS** en nuetra base de datos e insertamos un par de registros. A lo largo de la tarde de hoy, veremos como automatizar esto.

>## 1. Inserción en una base de datos desde Python
>Para ello vamos a descargar el siguiente [programa]({{ page.root }}/files/uniprotInsert.py) y lo iremos comentando juntos [uniprotInsert.py]({{ page.root }}/files/uniprotInsert_py.html).
>Para marcar el código con colores, tal y como aparece en el fichero HTML, podéis activar el destacado de sintaxis en vuestro programa.
>
> Una vez repasado el programa, descargaremos un [fichero de muestra]({{ page.root }}/files/UniProt-Sample.txt) a nuestro ordenador y lo usaremos junto con el programa recien estudiado para insertar 4 registros.
> Si todo ha funcionado correctamente, haremos lo mismo con el proteoma de dos organismos: [Mycoplasma mycoides]({{ page.root }}/files/MYCMS.dat) y [Staphylococcus aureus]({{ page.root }}/files/STAAN.dat)
{: .callout}


>## 2. Creación de un fichero desde Python, usando información de la base de datos
>En este caso vamos a hacer el caso contrario, es decir, vamos a crear un programa en Python que automáticamente hará consultas a la base de datos de unos campos determinados. Los resultados de esa consulta se procesarán con Python para crear un fichero. De forma más concreta vamos a seleccionar los identificadores y descripción de cada proteína almacenada en nuestra base de datos y su secuencia
> y con ello vamos a crear un fichero en formato [FASTA](https://es.wikipedia.org/wiki/Formato_FASTA).
> El programa lo podéis descargar desde este [link]({{ page.root }}/files/fasta_write.py) y para poder revisarlo juntos, podéis pinchar en el siguiente [link]({{ page.root }}/files/fasta_write_py.html) donde aparece el programa con la sintaxis destacada en colores.
>
{: .callout}


>## 3. Consultas de agregación
>Mediante consulta vamos a: 
>* Recuperar una entrada por su accession number principal. 
>* Recuperar las entradas que tengan un peso molecular entre 30000 y 90000. 
>* Recuperar las entradas cuya descripción contenga un código enzimático. 
>
>Mediante consultas de agregación, vamos a obtener los siguientes valores: 
>* Número de entradas de UniProt insertadas. 
>* Número de entradas de UniProt con una secuencia de más de 300 aminoácidos. 
>* Longitud media de las secuencias intertadas. 
>* Longitud de mayor tamaño de las secuencias intertadas.
>* Identificador de la proteína con mayor tamaño.
>* Calcular el número de accession number que hay por entrada. 
>
{: .callout}


> ## ¿Cómo recuperarias el ID y el tamaño de secuencia de la proteína con accnumber Q7A6N0?
>
> Para resolver esta pregunta tenemos que introducir dos valores en el select, el id y el tamaño de secuencia (length(seq))
>
> > ## Solution
> >
> > ~~~
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
> > ~~~
> > select count(*) from SWISSENTRY where description LIKE '%membrane%';
> > ~~~
> > {: .sql}
> >
> > |count(*)      |
> > |--------------|
> > |11            |
> {: .solution}
{: .challenge}
