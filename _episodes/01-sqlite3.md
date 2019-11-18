---
title: "Familiarización con la shell SQLite"
teaching: 60
exercises: 120

questions:
- "Como entrar al gestor de bases de datos?"
objectives:
- "Familiarizarse con la sehll de SQLite."
- "Crear tablas, insertar datos, recuperar registros."
- "Guardar los resultados en un fichero."
keypoints:
- "Una base de datos relacional almacena información en tablas, cada una de las cuales tiene un conjunto fijo de columnas y un número variable de registros"
- "Un gestor de base de datos es un programa que manipula la información almacenada en una base de datos"
- "Escribimos consultas en un lenguaje especializado llamado SQL para extraer información de las bases de datos"
- "Usa SELECT ... FROM ... para obtener valores de una tabla de base de datos"
- "SQL no distingue entre mayúsculas y minúsculas (pero los datos distinguen entre mayúsculas y minúsculas)"
---

Una [base de datos relacional]({% link reference.md %}#relational-database)
es una forma de almacenar y manipular información.
Las bases de datos están organizadas en [tablas]({% link reference.md %}#table).
Cada tabla tiene columnas (también conocidas como [campos]({% link reference.md %}#fields)) que describen los datos,
y filas (también conocidas como [registros]({% link reference.md %}#record)) que contienen los datos.

Cuando estamos usando una hoja de cálculo,
Ponemos fórmulas en las celdas para calcular nuevos valores basados ​​en los antiguos.
Cuando estamos usando una base de datos,
enviamos comandos
(generalmente llamado [consultas]({% link reference.md %}#query))
a un [administrador de base de datos]({% link reference.md %}#database-manager):
Un programa que manipula la base de datos para nosotros.
El administrador de la base de datos realiza cualquier búsqueda y cálculo que especifique la consulta,
devolver los resultados en forma de tabla
que luego podemos usar como punto de partida para futuras consultas.

Las consultas se escriben en un lenguaje llamado [SQL]({% link reference.md %}#sql),
que significa "lenguaje de consulta estructurado".
SQL proporciona cientos de formas diferentes de analizar y recombinar datos.
Solo veremos un puñado de consultas, pero ese puñado explica la mayor parte de lo que hacen los científicos.


> ## Gestores de bases de datos
>
> Existen muchos gestores de bases de datos (Oracle, IBM DB2, PostgreSQL, MySQL, Microsoft Access y SQLite) y todos entienden el lenguaje SQL, 
> pero cada uno almacena los datos de una manera diferente, por lo que una base de datos creada con uno no puede ser utilizada
> directamente por otro. Sin embargo, cada gestor de base de datos puede importar y exportar datos en una variedad de
> formatos como .csv, SQL, por lo que es posible mover información de uno a otro.
{: .callout}

> ## Entrar y salir de SQLite
>
> Para usar los comandos SQLite de forma *interactiva*, necesitamos
> entrar en la consola SQLite. Para ello, lo más recomendable es que os creeis una carpeta para almacenar los datos.
> Asi que abre una terminal y ejecuta. 
>
> ~~~
> $ mkdir $HOME/SQL/
> $ cd $HOME/SQL/
> $ sqlite3
> ~~~
> {: .bash}
>
>El comando para acceder al gesto SQLite es `sqlite3`, al no incluir nada más en el comando,
> abrirá una base de datos temporal y vacía.
>
> Para salir de SQLite, escribe `.exit` o` .quit`. Para algunos
> terminales, `Ctrl-D` también puede funcionar. Para ver el conjunto de comandos que pueden usarse,
> escribe `.help`.
>Ya sabemos entrar, salir y ver la ayuda. Así que ahora vamos a hacer algo más interesante.
>Vamos a usar una base de datos de prueba para que podáis ver como se estructura la información.
>En primer lugar, teneis que descargar el fichero [survey.db]({{ page.root }}/files/survey.db).
 {: .callout}


> ## Primeros comandos en SQL
>
> Antes de empezar, tenemos que copiar/mover el fichero recién descargado a nuestro directorio.
> Una vez lo tengais (por ejemplo $HOME/SQL/), comprobadlo desde la terminal
>
> ~~~
> $ cd $HOME/SQL/
> $ ls | grep survey.db
> ~~~
> {: .bash}
> ~~~
> survey.db
> ~~~
> {: .output}
>
> Si has obtenido ese mismo resultado, entonces ejecuta:
>
> ~~~
> $ sqlite3 survey.db
> ~~~
> {: .bash}
> ~~~
> SQLite version 3.8.8 2015-01-16 12:08:06
> Enter ".help" for usage hints.
> sqlite>
> ~~~
> {: .output}
>
> De esta forma estamos indicando al gestor de SQLite, que carge la base de datos contenida en el fichero `survey.db`.
>
> Como dijimos anteriormente, podeis obtener el conjunto de comandos existentes escribiendo `.help` en la shell de SQLite.
>
> Todos los comandos específicos de SQLite empiezan por `.` esto es muy útil porque sirve para distinguirlos de los comandos SQL.
> 
> Escribe `.tables` para ver las tablas contenidas en la base de datos.
>
> ~~~
> >sqlite>.tables
> ~~~
> {: .sql}
> ~~~
> Person   Site     Survey   Visited
> ~~~
> {: .output}
>
> Para obtener mas infromación sobre estas tablas, puedes escribir `.schema` y de esta forma, podrás ver los comandos SQL usados para crear estas
> tablas en la base de datos. Por ejemplo, estos comandos SQL mostrarán el conjunto de columnas y el tipo de datos que cada columna almacena.
> ~~~
> >sqlite> .schema
> ~~~
> {: .sql}
> ~~~
> CREATE TABLE Person (id text, personal text, family text);
> CREATE TABLE Site (name text, lat real, long real);
> CREATE TABLE Survey (taken integer, person text, quant text, reading real);
> CREATE TABLE Visited (id integer, site text, dated text);
> ~~~
> {: .output}
>
> El resultado aparece formateado como <**nombredecolumna** *dataType*>.  Así podemos observar que la primera línea que la tabla **Person** tiene tres columnas:
> * **id** con tipo _text_
> * **personal** con tipo _text_
> * **family** con tipo _text_
> 
> Nota: Los tipos de datos disponibles varían según el gestor de la base de datos; Para SQLite puedes consultarlos [aquí](https://www.sqlite.org/datatype3.html).
>
{: .callout}

For now,
let's write an SQL query that displays scientists' names.
We do this using the SQL command `SELECT`,
giving it the names of the columns we want and the table we want them from.
Our query and its output look like this:

~~~
> sqlite> SELECT family, personal FROM Person;
~~~
{: .sql}

```
Dyer|William
Pabodie|Frank
Lake|Anderson
Roerich|Valentina
Danforth|Frank
```

You can change some SQLite settings to make the output easier to read.
First,
set the output mode to display left-aligned columns.
Then turn on the display of column headers.

~~~
sqlite> .mode column
sqlite> .header on
sqlite> SELECT family, personal FROM Person;
 ~~~
 {: .sql}

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |


The semicolon at the end of the query
tells the database manager that the query is complete and ready to run.
We have written our commands in upper case and the names for the table and columns
in lower case,
but we don't have to:
as the example below shows,
SQL is [case insensitive]({% link reference.md %}#case-insensitive).

~~~
SeLeCt FaMiLy, PeRsOnAl FrOm PeRsOn;
~~~
{: .sql}

|family  |personal |
|--------|---------|
|Dyer    |William  |
|Pabodie |Frank    |
|Lake    |Anderson |
|Roerich |Valentina|
|Danforth|Frank    |

You can use SQL's case insensitivity to your advantage. For instance,
some people choose to write SQL keywords (such as `SELECT` and `FROM`)
in capital letters and **field** and **table** names in lower
case. This can make it easier to locate parts of an SQL statement. For
instance, you can scan the statement, quickly locate the prominent
`FROM` keyword and know the table name follows.  Whatever casing
convention you choose, please be consistent: complex queries are hard
enough to read without the extra cognitive load of random
capitalization.  One convention is to use UPPER CASE for SQL
statements, to distinguish them from tables and column names. This is
the convention that we will use for this lesson.

While we are on the topic of SQL's syntax, one aspect of SQL's syntax
that can frustrate novices and experts alike is forgetting to finish a
command with `;` (semicolon).  When you press enter for a command
without adding the `;` to the end, it can look something like this:

~~~
SELECT id FROM Person
...>
...>
~~~
{: .sql}

This is SQL's prompt, where it is waiting for additional commands or
for a `;` to let SQL know to finish.  This is easy to fix!  Just type
`;` and press enter!

Now, going back to our query,
it's important to understand that
the rows and columns in a database table aren't actually stored in any particular order.
They will always be *displayed* in some order,
but we can control that in various ways.
For example,
we could swap the columns in the output by writing our query as:

~~~
SELECT personal, family FROM Person;
~~~
{: .sql}

|personal |family  |
|---------|--------|
|William  |Dyer    |
|Frank    |Pabodie |
|Anderson |Lake    |
|Valentina|Roerich |
|Frank    |Danforth|

or even repeat columns:

~~~
SELECT id, id, id FROM Person;
~~~
{: .sql}

|id      |id      |id      |
|--------|--------|--------|
|dyer    |dyer    |dyer    |
|pb      |pb      |pb      |
|lake    |lake    |lake    |
|roe     |roe     |roe     |
|danforth|danforth|danforth|

As a shortcut,
we can select all of the columns in a table using `*`:

~~~
SELECT * FROM Person;
~~~
{: .sql}

|id      |personal |family  |
|--------|---------|--------|
|dyer    |William  |Dyer    |
|pb      |Frank    |Pabodie |
|lake    |Anderson |Lake    |
|roe     |Valentina|Roerich |
|danforth|Frank    |Danforth|





> To exit SQLite and return to the shell command line,
> you can use either `.quit` or `.exit`.



> ## Understanding CREATE statements
> 
> Use the `.schema` to identify column that contains integers.
>
> > ## Solution
> >
> > ~~~
> > .schema
> > ~~~
> > {: .sql}
> > ~~~
> > CREATE TABLE Person (id text, personal text, family text);
> > CREATE TABLE Site (name text, lat real, long real);
> > CREATE TABLE Survey (taken integer, person text, quant text, reading real);
> > CREATE TABLE Visited (id integer, site text, dated text);
> > ~~~
> > {: .output}
> > From the output, we see that the **taken** column in the **Survey** table (3rd line) is composed of integers. 
> {: .solution}
{: .challenge}

> ## Selecting Site Names
>
> Write a query that selects only the `name` column from the `Site` table.
>
> > ## Solution
> > 
> > ~~~
> > SELECT name FROM Site;
> > ~~~
> > {: .sql}
> >
> > |name      |
> > |----------|
> > |DR-1      |
> > |DR-3      |
> > |MSK-4     |
> {: .solution}
{: .challenge}

> ## Query Style
>
> Many people format queries as:
>
> ~~~
> SELECT personal, family FROM person;
> ~~~
> {: .sql}
>
> or as:
>
> ~~~
> select Personal, Family from PERSON;
> ~~~
> {: .sql}
>
> What style do you find easiest to read, and why?
{: .challenge}
