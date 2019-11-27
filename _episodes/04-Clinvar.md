---
title: "Creación de nuevas tablas"
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
ClinVar es una base de datos pública y de acceso gratuito que contiene la relación entre variantes génicas y fenotipos humanos con evidencia de apoyo. 
De este modo, ClinVar facilita el acceso a la información entre la variaciones humanas y el estado de salud observado, y la historia de esa interpretación. 
ClinVar procesa las solicitudes que informan de las variantes encontradas en muestras de pacientes, afirmaciones hechas con respecto 
a su importancia clínica, información sobre el remitente y otros datos de respaldo. Los alelos descritos en los datos se asignan a 
secuencias de referencia y se informan de acuerdo con el estándar [HGVS](https://onlinelibrary.wiley.com/doi/full/10.1002/humu.22981). 
Para más informacióm, podeis consultar la web de [ClinVar](https://www.ncbi.nlm.nih.gov/clinvar/docs/help).


> ## 1. Creación de una o más tablas para guardar datos de Clinvar
>
> Este apartado lo haremos en conjunto. Para ello revisaremos los datos que proporciona esta base de datos. De entre todos ellos, identificaremos 
> juntos aquellos de mayor importancia y crearemos una o más tablas para almacenar estos datos.
>
 {: .callout}
