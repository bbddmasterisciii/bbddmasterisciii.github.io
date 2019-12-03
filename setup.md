---
layout: page
title: Setup
---
# Software
Para este curso, principalmente necesitarás una shell de Unix, [SQLite3](http://www.sqlite.org/) y [Python 3.6](https://www.python.org/downloads/) o superior.

Si estas trabajando en una máquina Linux, como Ubuntu, lo más seguro es que ya tengas este programa instalado.
Para comprobarlo, desde la consola usa el comando `which sqlite3` para ver la ruta al programa. Si al ejecutar este comando no
aparece ningún resultado, podría ser necesario su instalación. 

Para instalar SQLite en sistemas como Debian/Ubuntu, debes ejecutar el siguiente comando `sudo apt-get install sqlite3`.
En sistemas como Red Hat/CentOs, debes usar `sudo yum install sqlite.x86_64`

Si has instalado SQLite3 usando Anaconda, por favor usa la [documentación](https://anaconda.org/anaconda/sqlite) que ellos proporcionan.

Una vez instalado, cierra el terminal y vuelve a abrirlo, de esta forma se carga el path y las configuraciones necesarias
para que todo funcione correctamente.
