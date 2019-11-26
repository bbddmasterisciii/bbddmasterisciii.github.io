---
title: "Creación de nuevas tablas. Creación de un script"
teaching: 15
exercises: 60
questions:
- "Como podemos insertar miles de tuplas de forma automática"
objectives:
- "Conocer el fundamento de la programación relacionada con SQL desde Python"
- "Leer ficheros de nuestro ordenador e insertar la información relevante en una base de datos relacional"
- "Consultar desde Python una base de datos y extraer determinados campos"
keypoints:
- "Casi cualquier gestor de base de datos tiene un interfaz de consulta para ser usado desde cualquier lenguaje de programación"
- "Para SQLite se usa el paquete sqlite3"
---
ClinVar es un archivo público de acceso gratuito de informes de las relaciones entre las variaciones y fenotipos humanos, con evidencia de apoyo. De este modo, ClinVar facilita el acceso y la comunicación sobre las relaciones afirmadas entre la variación humana y el estado de salud observado, y la historia de esa interpretación. ClinVar procesa las presentaciones que informan variantes encontradas en muestras de pacientes, afirmaciones hechas con respecto a su importancia clínica, información sobre el remitente y otros datos de respaldo. Los alelos descritos en las presentaciones se asignan a secuencias de referencia y se informan de acuerdo con el estándar HGVS. Luego, ClinVar presenta los datos para usuarios interactivos y para aquellos que desean usar ClinVar en los flujos de trabajo diarios y otras aplicaciones locales. ClinVar trabaja en colaboración con organizaciones interesadas para satisfacer las necesidades de la comunidad de genética médica de la manera más eficiente y efectiva posible. Lea más sobre el uso de ClinVar.

ClinVar admite presentaciones de diferentes niveles de complejidad. La presentación puede ser tan simple como una representación de un alelo y su interpretación (a veces denominada presentación de nivel variante), o tan detallada como proporcionar múltiples tipos de evidencia estructurada de observación (nivel de caso) o experimental sobre el efecto de la variación en fenotipo Un objetivo principal es apoyar la (re) evaluación computacional, tanto de genotipos como de afirmaciones, y permitir la evolución y el desarrollo continuos del conocimiento con respecto a las variaciones y los fenotipos asociados. ClinVar es un socio activo del proyecto ClinGen, que proporciona datos para la evaluación y archiva los resultados de la interpretación por parte de reconocidos paneles de expertos y proveedores de guías de práctica. Archivos de ClinVar y envíos de versiones, lo que significa que cuando los remitentes actualizan sus registros, la versión anterior se retiene para su revisión. Lea más sobre cómo enviar datos a ClinVar.

El nivel de confianza en la precisión de las llamadas de variación y las afirmaciones de importancia clínica depende en gran medida de la evidencia de apoyo, por lo que esta información, cuando esté disponible, se recopila y es visible para los usuarios. Debido a que la disponibilidad de evidencia de respaldo puede variar, particularmente con respecto a los datos retrospectivos agregados de la literatura publicada, el archivo acepta envíos de múltiples grupos y agrega información relacionada, para reflejar de manera transparente tanto el consenso como las afirmaciones conflictivas de importancia clínica. También se asigna un estado de revisión a cualquier aserción, para respaldar la comunicación sobre la confiabilidad de cualquier aserción. Se alienta a los expertos en dominios a solicitar el reconocimiento como panel de expertos.

~~~
.nullvalue -null-
~~~
{: .sql}

To start,
let's have a look at the `Visited` table.
There are eight records,
but #752 doesn't have a date --- or rather,
its date is null:

~~~
SELECT * FROM Visited;
~~~
{: .sql}

|id   |site |dated     |
|-----|-----|----------|
|619  |DR-1 |1927-02-08|
|622  |DR-1 |1927-02-10|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|752  |DR-3 |-null-    |
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

Null doesn't behave like other values.
If we select the records that come before 1930:

~~~
SELECT * FROM Visited WHERE dated < '1930-01-01';
~~~
{: .sql}

|id   |site|dated     |
|-----|----|----------|
|619  |DR-1|1927-02-08|
|622  |DR-1|1927-02-10|

we get two results,
and if we select the ones that come during or after 1930:

~~~
SELECT * FROM Visited WHERE dated >= '1930-01-01';
~~~
{: .sql}

|id   |site |dated     |
|-----|-----|----------|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

we get five,
but record #752 isn't in either set of results.
The reason is that
`null<'1930-01-01'`
is neither true nor false:
null means, "We don't know,"
and if we don't know the value on the left side of a comparison,
we don't know whether the comparison is true or false.
Since databases represent "don't know" as null,
the value of `null<'1930-01-01'`
is actually `null`.
`null>='1930-01-01'` is also null
because we can't answer to that question either.
And since the only records kept by a `WHERE`
are those for which the test is true,
record #752 isn't included in either set of results.

Comparisons aren't the only operations that behave this way with nulls.
`1+null` is `null`,
`5*null` is `null`,
`log(null)` is `null`,
and so on.
In particular,
comparing things to null with = and != produces null:

~~~
SELECT * FROM Visited WHERE dated = NULL;
~~~
{: .sql}

produces no output, and neither does:

~~~
SELECT * FROM Visited WHERE dated != NULL;
~~~
{: .sql}

To check whether a value is `null` or not,
we must use a special test `IS NULL`:

~~~
SELECT * FROM Visited WHERE dated IS NULL;
~~~
{: .sql}

|id   |site|dated     |
|-----|----|----------|
|752  |DR-3|-null-    |

or its inverse `IS NOT NULL`:

~~~
SELECT * FROM Visited WHERE dated IS NOT NULL;
~~~
{: .sql}

|id   |site |dated     |
|-----|-----|----------|
|619  |DR-1 |1927-02-08|
|622  |DR-1 |1927-02-10|
|734  |DR-3 |1930-01-07|
|735  |DR-3 |1930-01-12|
|751  |DR-3 |1930-02-26|
|837  |MSK-4|1932-01-14|
|844  |DR-1 |1932-03-22|

Null values can cause headaches wherever they appear.
For example,
suppose we want to find all the salinity measurements
that weren't taken by Lake.
It's natural to write the query like this:

~~~
SELECT * FROM Survey WHERE quant = 'sal' AND person != 'lake';
~~~
{: .sql}

|taken|person|quant|reading|
|-----|------|-----|-------|
|619  |dyer  |sal  |0.13   |
|622  |dyer  |sal  |0.09   |
|752  |roe   |sal  |41.6   |
|837  |roe   |sal  |22.5   |

but this query filters omits the records
where we don't know who took the measurement.
Once again,
the reason is that when `person` is `null`,
the `!=` comparison produces `null`,
so the record isn't kept in our results.
If we want to keep these records
we need to add an explicit check:

~~~
SELECT * FROM Survey WHERE quant = 'sal' AND (person != 'lake' OR person IS NULL);
~~~
{: .sql}

|taken|person|quant|reading|
|-----|------|-----|-------|
|619  |dyer  |sal  |0.13   |
|622  |dyer  |sal  |0.09   |
|735  |-null-|sal  |0.06   |
|752  |roe   |sal  |41.6   |
|837  |roe   |sal  |22.5   |

We still have to decide whether this is the right thing to do or not.
If we want to be absolutely sure that
we aren't including any measurements by Lake in our results,
we need to exclude all the records for which we don't know who did the work.

In contrast to arithmetic or Boolean operators, aggregation functions
that combine multiple values, such as `min`, `max` or `avg`, *ignore*
`null` values. In the majority of cases, this is a desirable output:
for example, unknown values are thus not affecting our data when we
are averaging it. Aggregation functions will be addressed in more
detail in [the next section]({{ site.github.url }}/06-agg/).

> ## Sorting by Known Date
>
> Write a query that sorts the records in `Visited` by date,
> omitting entries for which the date is not known
> (i.e., is null).
>
> > ## Solution
> >
> > ~~~
> > SELECT * FROM Visited WHERE dated IS NOT NULL ORDER BY dated ASC;
> > ~~~
> > {: .sql}
> >
> > |id        |site      |dated     |
> > |----------|----------|----------|
> > |619       |DR-1      |1927-02-08|
> > |622       |DR-1      |1927-02-10|
> > |734       |DR-3      |1930-01-07|
> > |735       |DR-3      |1930-01-12|
> > |751       |DR-3      |1930-02-26|
> > |837       |MSK-4     |1932-01-14|
> > |844       |DR-1      |1932-03-22|
> {: .solution}
{: .challenge}

> ## NULL in a Set
>
> What do you expect the query:
>
> ~~~
> SELECT * FROM Visited WHERE dated IN ('1927-02-08', NULL);
> ~~~
> {: .sql}
>
> to produce?
> What does it actually produce?
{: .challenge}

> ## Pros and Cons of Sentinels
>
> Some database designers prefer to use
> a [sentinel value]({% link reference.md %}#sentinel-value)
> to mark missing data rather than `null`.
> For example,
> they will use the date "0000-00-00" to mark a missing date,
> or -1.0 to mark a missing salinity or radiation reading
> (since actual readings cannot be negative).
> What does this simplify?
> What burdens or risks does it introduce?
{: .challenge}
