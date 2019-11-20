---
title: "Manipulación de datos. Transacciones"
teaching: 30
exercises: 60
questions:
- "¿Qué pasa si inserto un registro duplicado?"
- "¿Si cambia la información de un registro, tengo que cambiarlo en todas las tablas que lo usan?"
objectives:
- "Insertar datos biológicos"
- "Claves primarias y únicas"
- "Referencias entre tablas"

keypoints:
- "BEGIN inicia una transacción."
- "ROLLBACK cierra la transcacción sin guardar los cambios"
- "COMMIT cierra la transcacción guardando los cambios"
---

A lo largo del dia de hoy, trabajaremos con datos biológicos, de la base de datos de proteinas [Uniprot](http://www.uniprot.org/). De esta base de datos recopilaremos un par de entradas y las insertaremos en la base de datos.
Con estos datos de prueba, introduciremos la importancia de la creación de las tablas con claves primarias, únicas y con referencias.
Si una base de datos tiene unas tablas bien definidas, su mantenimieto y actualización se hace de forma muy sencilla. Si esto no es así, cada actualización, puede ser una pesadilla.

> ## 1. Tabla con referencias externas.
> Descargad el fichero [initial.sql]({{ page.root }}/files/initial.sql), copiadlo
> a vuestra carpeta de trabajo y abrirlo con un editor de texto. Vamos a repasar cada una de las sentencias que ahí aparecen, haciendo énfasis en las **claves primarias**, los **registros únicos** y las **referencias externas**:
>
>
>
> ~~~
> CREATE TABLE SWISSENTRY (
>         accnumber VARCHAR(10) NOT NULL,
>         id VARCHAR(25) NOT NULL,
>         lastupd DATE NOT NULL DEFAULT CURRENT_DATE,
>         description VARCHAR(1000),
>         seq TEXT NOT NULL,
>         molweight NUMERIC(9,0) NOT NULL,
>         PRIMARY KEY (accnumber),
>         UNIQUE (id)
> );
> 
> CREATE TABLE ACCNUMBERS (
>         main_accnumber VARCHAR(10) NOT NULL,
>         accnumber VARCHAR(10) NOT NULL,
>         PRIMARY KEY (main_accnumber,accnumber),
>         FOREIGN KEY (main_accnumber) REFERENCES SWISSENTRY (accnumber)
>                 ON DELETE CASCADE ON UPDATE CASCADE
> );
> ~~~
> {: .sql}
>
> 
> Tras haber leído y entendido el esquema que lo forma, incluiremos debajo de las sentencias `CREATE`, dos sentencias adicionales de `INSERT` de dos proteinas cualquiera, que se obtendrán del abrir dos veces el siguiente link de  [Uniprot](http://www.uniprot.org/uniprot/?query=*&random=yes) (una vez en la página, pinchad en Format->Text).
>
> Cuando ya tengais lo tengais, vamos a decirle a SQLite que lea este fichero y que ejecute los comandos SQL que hay en ese fichero. Recordad que eso lo vimos ayer.
>
>
> Si no ha habido ningún error, tendréis dos resultados de la querie anterior. Cómo habeis visto, de esta forma podemos insertar varios registros de una vez. Pero aún así esto no es
> muy útil porque al fin y al cabo, tenemos que escribir toda la información en un fichero. ¿Qué pasaría si tenemos que insertar las proteínas de un organismos entero?.
> Pues esto lo veremos más adelante.
>
> ## 2. Clave única | primaria
>Clave única
>La clave única o UNIQUE hace que en la columna que la posee no pueda tener dos datos iguales. Es decir en cada registro, el campo marcado con UNIQUE debe tener un dato diferente. Esto lo convierte en un identificador del registro, ya que no puede haber dos registros que contengan el mismo dato en esa columna.
>Puede haber varias claves únicas en una tabla. La clave única la podemos marcar al crear la tabla, por ejemplo:
>>CREATE TABLE miagenda (
>      nombre VARCHAR(255) NOT NULL,
>      telefono1 INT NOT NULL UNIQUE,
>      telefono2 INT,
>      email VARCHAR(255) NOT NULL UNIQUE
>      );
>
>Vemos en este ejemplo cómo al crear la tabla "miagenda" los campos "telefono1" y "email" les hemos asignado una clave única mediante la palabra reservada "UNIQUE". Les hemos asignado también la restricción "NOT NULL", aunque no es obligatorio, es conveniente hacerlo así, de otra manera en el campo sólo se permitiría un registro con valor nulo (ya que otro registro nulo se consideraría repetido).
>>En una tabla ya creada, podemos añadir un registro único a un campo ya existente, o que creamos más tarde, indicandolo en la instrucción "ALTER TABLE" de la siguiente manera:
>ALTER TABLE miagenda
>    ADD direccion VARCHAR(255),
>    ADD UNIQUE (direccion),
>    ADD UNIQUE (telefono2); 
>
>Creamos primero un nuevo campo en la tabla llamado "direccion", y después mediante "ADD UNIQUE (direccion)", lo convertimos en un campo con clave única. También añadimos una clave única al campo ya existente "telefono2", de la misma manera que para la anterior es decir mediante "ADD UNIQUE (telefono2)".
>Cada una de estas instrucciones incluidas en "ALTER TABLE" irán separadas entre sí por comas.
>Para eliminar una clave unica utilizaremos la instrucción:
ALTER TABLE nombre_tabla DROP INDEX nombre_columna;
>Es decir es otra instruccion dentro de "ALTER TABLE". Lo de DROP INDEX es porque en realidad una clave única se considera un índice para buscar elementos en la tabla.
>Aunque aquí hemos puesto "nombre_columna", en realidad deberíamos haber puesto "nombre_clave". La clave recibe un nombre que, si la hemos creado mediante php en la web coincide con el nombre de la columna. Sin embargo si creamos la clave única por otros medios (por ejemplo mediante phpmyadmin) podemos ponerle otro nombre distinto del de la columna. En este caso en lugar del nombre de la columna pondremos el nombre que le hayamos dado a la clave.
>
> La clave primaria, o **PRIMARY KEY** es el verdadero identificador de cada registro. Sólo puede haber una columna con clave primaria por tabla, y los registros deben ser también únicos, es decir no pueden estar repetidos ni ser nulos.
>La clave primaria es fundamental para crear relaciones entre varias tablas, ya que es esta clave la que identifica el registro que debe ser complementado con datos de otra tabla.
>
>Normalmente se crea una columna especial para incluir la clave primaria, que en la mayoría de las tablas llaman "id" o "id_nombretabla". Los valores de los registros suelen ser números enteros que identifican a cada uno de los registros que se crean en la tabla.
>Como habeis visto arriba, lo normal es crear las columnas de la tabla, y posteriormente indicamos mediante la instrucción PRIMARY KEY la columna que debe ser la clave primaria. 
> ~~~
>PRIMARY KEY (accnumber),
> ~~~
> {: .sql}
>Al crear esta columna debemos ponerle la instrucción **NOT NULL** para que pueda ser una clave primaria. No tendría lógica crear un campo de tanta importancia y permitir que sea **NULL**.
>Si tenemos una tabla ya creada, podemos indicar qué columna será la clave primaria mediante la instrucción:
> ~~~
>ALTER TABLE prueba1
>ADD PRIMARY KEY (id_prueba1)
> ~~~
> {: .sql}
>
>Para eliminar la clave primaria de una tabla utilizaremos la instrucción:
> ~~~
>ALTER TABLE nombre_tabla DROP PRIMARY KEY
> ~~~
> {: .sql}
>
>Cómo la clave primaria es única no necesitamos poner el nombre de la columna en la que está para eliminarla.
>
{: .callout}

> ## 3. Referencias externas
>
>ejemplo del UPDATE
>
{: .callout}



