---
title: "Familiarización con la shell SQLite"
teaching: 60
exercises: 30

questions:
- "Como entrar al gestor de bases de datos?"
objectives:
- "Familiarizarse con la shell de SQLite."
- "Crear tablas, insertar datos, recuperar registros."
- "Guardar los resultados en un fichero."
keypoints:
- "Una base de datos relacional almacena información en tablas, cada una de las cuales tiene un conjunto fijo de columnas y un número variable de registros"
- "Un gestor de base de datos es un programa que manipula la información almacenada en una base de datos"
- "Escribimos consultas en un lenguaje especializado llamado SQL para extraer información de las bases de datos"
- "Usa `SELECT ... FROM ...` para obtener valores de una tabla de base de datos"
- "SQL no distingue entre mayúsculas y minúsculas (pero los datos distinguen entre mayúsculas y minúsculas)"
---

Una [base de datos relacional]({% link reference.md %}#relational-database)
es una forma de almacenar y manipular información.
Las bases de datos están organizadas en [tablas]({% link reference.md %}#table).
Cada tabla tiene columnas (también conocidas como [campos]({% link reference.md %}#fields)) que describen los datos,
y filas (también conocidas como [registros]({% link reference.md %}#record)) que contienen los datos.

Cuando estamos usando una hoja de cálculo,
ponemos fórmulas en las celdas para calcular nuevos valores basados ​​en los antiguos.
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

Para que tengáis una mejor idea, os adjuntamos la [parte teórica en PDF]({{ page.root }}{% link files/BBDD-Master2019_2020-0.pdf %}){:target="_blank"} para que podáis verla cuando queráis.
> ## 0. Gestores de bases de datos
>
> Existen muchos gestores de bases de datos (Oracle, IBM DB2, PostgreSQL, MySQL, Microsoft Access y SQLite) y todos entienden el lenguaje SQL, 
> pero cada uno almacena los datos de una manera diferente, por lo que una base de datos creada con uno no puede ser utilizada
> directamente por otro. Sin embargo, casi cada gestor de base de datos puede importar y exportar datos en alguno de los
> formatos comunes como .csv o SQL, por lo que es posible mover información de uno a otro sin necesidad de escribir un programa especial.
{: .callout}

> ## 1. Entrar y salir de la shell SQLite
>
> SQLite es un gestor de bases de datos embebido, que no necesita de un servidor separado para manejar sus instancias de bases de datos.
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
>El comando para acceder al gesto SQLite es `sqlite3`. Al no incluir nada más en el comando,
> creará en memoria una base de datos temporal y vacía.
>
> Para salir de la shell de SQLite, escribe `.exit` o` .quit`. Para algunos
> terminales, la combinación de teclas `Ctrl-D` también puede funcionar. Para ver el conjunto de comandos que pueden usarse,
> escribe `.help`.
>Ya sabemos entrar, salir y ver la ayuda. Así que ahora vamos a hacer algo más interesante.
>Vamos a usar una base de datos de prueba para que podáis ver como se estructura la información.
>En primer lugar, teneis que descargar el fichero [survey.db]({{ page.root }}{% link files/survey.db %}){:target="_blank"}.
 {: .callout}


> ## 1.1 Primeros comandos en SQL
>
> Antes de empezar, tenemos que copiar/mover el fichero recién descargado a nuestro directorio.
> Una vez lo tengais (por ejemplo `$HOME/SQL/`), comprobadlo desde la terminal
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
> De esta forma estamos indicando al gestor de SQLite, que cargue la base de datos contenida en el fichero `survey.db`.
>
> Como dijimos anteriormente, podeis obtener el conjunto de comandos existentes escribiendo `.help` en la shell de SQLite.
>
> Todos los comandos específicos de SQLite empiezan por `.` esto es muy útil porque sirve para distinguirlos de los comandos SQL.
> 
> Escribe `.tables` para ver las tablas contenidas en la base de datos.
>
> ~~~
> sqlite> .tables
> ~~~
> {: .sql}
> ~~~
> Person   Site     Survey   Visited
> ~~~
> {: .output}
>
> Para obtener mas información sobre estas tablas, puedes escribir `.schema` y de esta forma, podrás ver los comandos SQL usados para crear estas
> tablas en la base de datos. Por ejemplo, estos comandos SQL mostrarán el conjunto de columnas y el tipo de datos que cada columna almacena.
> ~~~
> sqlite> .schema
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
>
>Por ahora, escribamos una consulta SQL que muestre los nombres de los científicos.
>Hacemos esto usando el comando SQL `SELECT`,
>dándole los nombres de las columnas que queremos y la tabla de la que las queremos.
>Nuestra consulta y su salida se ven así:
>
>~~~
>sqlite> SELECT family, personal FROM Person;
>~~~
>{: .sql}
>
>```
>Dyer|William
>Pabodie|Frank
>Lake|Anderson
>Roerich|Valentina
>Danforth|Frank
>```
>
>Podeis cambiar algunas configuraciones de SQLite para que la salida de los resultados sea más fácil de leer.
>Primero, configura el modo de salida para mostrar columnas alineadas a la izquierda.
>Luego activa los encabezados de columna.
>
>~~~
>sqlite> .mode column
>sqlite> .header on
>sqlite> SELECT family, personal FROM Person;
> ~~~
> {: .sql}
>
>|family  |personal |
>|--------|---------|
>|Dyer    |William  |
>|Pabodie |Frank    |
>|Lake    |Anderson |
>|Roerich |Valentina|
>|Danforth|Frank    |
>
>
>Como veis, hemos escrito nuestros comandos en mayúsculas y los nombres de la tabla y las columnas.
>en minúsculas, pero no tenemos porqué como muestra el siguiente ejemplo,
>SQL es [insensible a mayúsculas y minúsculas]({% link reference.md %}#case-insensitive).
>
>~~~
>SeLeCt FaMiLy, PeRsOnAl FrOm PeRsOn;
>~~~
>{: .sql}
>
>|family  |personal |
>|--------|---------|
>|Dyer    |William  |
>|Pabodie |Frank    |
>|Lake    |Anderson |
>|Roerich |Valentina|
>|Danforth|Frank    |
>
>Es útil separar el uso de la mayúsculas y minúsculas en SQL. Por ejemplo,
>algunas personas optan por escribir palabras clave SQL (como `SELECT` y` FROM`)
>en mayúsculas y los nombres de los **campos** y **tablas** en minúscula. 
>Las consultas de SQL puedes ser muy complejas, de varias líneas de longitud y los suficientemente difíciles
>para leer sin la carga cognitiva adicional de la capitalización aleatoria. 
>Una convención es usar MAYÚSCULAS para las declaraciones de SQL y distinguirlas de tablas y nombres de columnas. 
>Esto es la convención que usaremos para esta lección.
>
>El punto y coma al final de la consulta le dice al gestor de la base de datos que la consulta está completa y lista para ejecutarse.
>Mientras estamos en el tema de la sintaxis de SQL, un aspecto de la sintaxis de SQL
>que puede frustrar tanto a los principiantes como a los expertos es olvidar terminar un
>comando con `;` (punto y coma). Cuando presionas enter para un comando
>sin agregar el `;` al final, puede verse más o menos así:
>
>~~~
>SELECT id FROM Person
>...>
>...>
>~~~
>{: .sql}
>
>Esta es la consola de SQLite esperando comandos adicionales o un `;` para que SQL sepa que debe finalizar. 
>¡Esto es fácil de arreglar! Escribe `;` y presiona enter!
>
>Ahora, volviendo a nuestra consulta SQL anterior, es importante entender que
>las filas y columnas en una tabla de base de datos no se almacenan en ningún orden en particular.
>Siempre se **mostrarán** en algún orden, pero podemos controlar eso de varias maneras.
>Por ejemplo, podríamos intercambiar las columnas en la salida escribiendo nuestra consulta como:
>
>~~~
>SELECT personal, family FROM Person;
>~~~
>{: .sql}
>
>|personal |family  |
>|---------|--------|
>|William  |Dyer    |
>|Frank    |Pabodie |
>|Anderson |Lake    |
>|Valentina|Roerich |
>|Frank    |Danforth|
>
>o incluso repetir columnas:
>
>~~~
>SELECT id, id, id FROM Person;
>~~~
>{: .sql}
>
>|id      |id      |id      |
>|--------|--------|--------|
>|dyer    |dyer    |dyer    |
>|pb      |pb      |pb      |
>|lake    |lake    |lake    |
>|roe     |roe     |roe     |
>|danforth|danforth|danforth|
>
>A modo de atajo, podemos seleccionar todas las columnas de una tabla usando `*`:
>
>~~~
>SELECT * FROM Person;
>~~~
>{: .sql}
>
>|id      |personal |family  |
>|--------|---------|--------|
>|dyer    |William  |Dyer    |
>|pb      |Frank    |Pabodie |
>|lake    |Anderson |Lake    |
>|roe     |Valentina|Roerich |
>|danforth|Frank    |Danforth|
>
>
> De nuevo, para salir de SQLite y volver a la línea de comando del shell,
> podeis usar `.quit` o` .exit`.
{: .callout}


> ## Comprendiendo las declaraciones CREATE
> 
> Use el comando `.schema` para identificar la columna que contiene números enteros .
>
> > ## Solución
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
> > Del resultado obtenido, vemos que la columna **taken** en la tabla **Survey** (tercera línea) está compuesta de enteros. 
> {: .solution}
{: .challenge}

> ## Seleccionar nombres de sitios
>
> Escriba una consulta que seleccione solo la columna `name` de la tabla `Site`.
>
> > ## Solución
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

> ## Estilo de consultas
>
> Muchas personas escriben las consultas SQL dándole el siguente formato: 
>
> ~~~
> SELECT personal, family FROM person;
> ~~~
> {: .sql}
>
> o así:
>
> ~~~
> select Personal, Family from PERSON;
> ~~~
> {: .sql}
>
> ¿Qué estilo te resulta más fácil de leer y por qué?
{: .challenge}
