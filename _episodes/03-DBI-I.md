---
title: "Acceso mediante programa a la base de datos."
teaching: 25
exercises: 0
questions:
- "¿Como podemos insertar miles de tuplas de forma automática?"
objectives:
- "Conocer el fundamento de la programación relacionada con SQL desde Python."
keypoints:
- "Casi cualquier gestor de base de datos tiene un interfaz de consulta para ser usado desde cualquier lenguaje de programación."
- "Para SQLite se usa el paquete sqlite3."


---
Ayer creamos dos tablas llamadas **SWISSENTRY** y **ACCNUMBERS** en nuetra base de datos e insertamos un par de registros. A lo largo de la tarde de hoy, veremos como automatizar esto.

>## 1. Inserción en una base de datos desde Python
>Para ello vamos a descargar el siguiente [programa]({{ page.root }}/files/uniprotInsert.py) y lo iremos comentando juntos [uniprotInsert.py]({{ page.root }}/files/uniprotInsert_py.html).
>Para marcar el código con colores, tal y como aparece en el fichero HTML, podéis activar el destacado de sintaxis en vuestro programa.
>
> Una vez repasado el programa, descargaremos un [fichero de muestra]({{ page.root }}/files/UniProt-Sample.txt) a nuestro ordenador y lo usaremos junto con el programa recien estudiado para insertar 4 registros.
> Si todo ha funcionado correctamente, haremos lo mismo con el proteoma de dos organismos: [Mycoplasma mycoides]({{ page.root }}/files/MYCMS.dat) y [Staphylococcus aureus]({{ page.root }}/files/STAAN.dat)
{: .callout}

