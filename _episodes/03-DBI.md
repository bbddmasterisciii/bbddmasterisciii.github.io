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
---
Ayer creamos dos tablas llamadas **SWISSENTRY** y **ACCNUMBERS** en nuetra base de datos e insertamos un par de registros. A lo largo de la tarde de hoy, veremos como automatizar esto.

>## 1. Inserción en una base de datos desde Python
>Para ello vamos a [descargar]({{ page.root }}/files/uniprotInsert.py) el siguiente programa y lo iremos comentando juntos [uniprotInse
>rt.py]({{ page.root }}/files/uniprotInsert_py.html).
>Para marcar el código con colores, tal y como aparece en el fichero HTML, podéis activar el destacado de sintaxis en vuestro programa.
>
> Una vez repasado el programa, descargaremos un [fichero de muestra]({{ page.root }}/files/UniProt-Sample.txt) a nuestro ordenador y lo usaremos junto con el programa recien estudiado para insertar 4 registros.
> Si todo ha funcionado correctamente, haremos lo mismo con el proteoma de dos organismos: [Mycoplasma mycoides]({{ page.root }}/files/MYCMS.dat) y [Staphylococcus aureus]({{ page.root }}/files/STAAN.dat)
{: .callout}


>## 2. Consultas de agregación
>Mediante consulta vamos a: 
>* Recuperar una entrada por su accession number principal. 
>* Recuperar las entradas que tengan un peso molecular entre 30000 y 90000. 
>* Recuperar las entradas cuya descripción contenga un código enzimático. 
>
>Mediante consultas de agregación, vamos a obtener los siguientes valores: 
>* Número de entradas de UniProt insertadas. 
>* Número de entradas de UniProt con una secuencia de más de 300 aminoácidos. 
>* Longitud media de las secuencias intertadas. 
>* La desviación estándar del peso molecular. 
>* Calcular el número de accession number que hay por entrada. 
>
{: .callout}


> ## Finding Outliers
>
> Normalized salinity readings are supposed to be between 0.0 and 1.0.
> Write a query that selects all records from `Survey`
> with salinity values outside this range.
>
> > ## Solution
> >
> > ~~~
> > SELECT * FROM Survey WHERE quant = 'sal' AND ((reading > 1.0) OR (reading < 0.0));
> > ~~~
> > {: .sql}
> >
> > |taken     |person    |quant     |reading   |
> > |----------|----------|----------|----------|
> > |752       |roe       |sal       |41.6      |
> > |837       |roe       |sal       |22.5      |
> {: .solution}
{: .challenge}

> ## Matching Patterns
>
> Which of these expressions are true?
>
> 1. `'a' LIKE 'a'`
> 2. `'a' LIKE '%a'`
> 3. `'beta' LIKE '%a'`
> 4. `'alpha' LIKE 'a%%'`
> 5. `'alpha' LIKE 'a%p%'`
>
> > ## Solution
> >
> > 1. True because these are the same character.
> > 2. True because the wildcard can match _zero_ or more characters.
> > 3. True because the `%` matches `bet` and the `a` matches the `a`.
> > 4. True because the first wildcard matches `lpha` and the second wildcard matches zero characters (or vice versa).
> > 5. True because the first wildcard matches `l` and the second wildcard matches `ha`.
> {: .solution}
{: .challenge}
