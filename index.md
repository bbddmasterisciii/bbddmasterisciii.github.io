---
layout: lesson
root: .
---

Casi todos los desarrollos que se hacen a día de hoy en bioinformática de una u otra manera hacen uso de datos almacenados en bases de datos “biológicas” o “bioinformáticas”.
Una base de datos biológica es un almacén de datos para información derivada de los datos obtenidos experimentos biológicos, ni más ni menos. 
Y una base de datos bioinformática es un almacén de datos para información derivada de datos biológicos y de programas bioinformáticos. 
A nivel más técnico, las bases de datos biológicas y bioinformáticas están disponibles generalmente como un conjunto de ficheros planos, cuyo tamaño suele ser enorme.

Además de los archivos de texto, existen otras formas de almacenamiento muy comunes en nuestro campo, 
hojas de cálculo (generalmente muy mala idea, como explica
[el siguiente artículo](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-1044-7){:target="_blank"} y da ejemplo
[la siguiente noticia](https://www.bbc.com/news/technology-54423988){:target="_blank"})
y las bases de datos relacionales. 
Los archivos de texto son más fáciles de crear y funcionan bien con el control de versiones, 
pero entonces tendríamos que construir herramientas de búsqueda y análisis nosotros mismos. 
Las hojas de cálculo son buenas para hacer análisis simples, pero no manejan bien conjuntos de datos 
grandes o complejos. Sin embargo, las bases de datos incluyen herramientas poderosas para búsqueda y análisis, 
y pueden manejar conjuntos de datos grandes y complejos. 

A lo largo de las siguientes lecciones, se explicará qué es un gestor de base de datos, cómo se insertan datos, cómo se consultan esos datos y cómo se puede hacer todo esto de
forma automática gracias a la programación en un lenguaje como Python.


>
> ## Prerequisitos
>
> * Estas practicas requieren de una shell de Unix, de [SQLite3](http://www.sqlite.org/) y de [Python 3.6](https://www.python.org/downloads/) o superior.
>
{: .prereq}

{% include sc/schedule.html %}