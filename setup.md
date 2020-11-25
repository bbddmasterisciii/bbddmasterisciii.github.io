---
layout: page
title: Setup
---
# Software
Para este curso, principalmente necesitarás una terminal con shell de Unix,
[SQLite3](http://www.sqlite.org/){:target="_blank"} y [Python 3.6](https://www.python.org/downloads/){:target="_blank"} o superior.

Si estás trabajando en una máquina Linux, como Ubuntu, lo más seguro es que ya tengas SQLite instalado.
Para comprobarlo, desde una terminal usa el comando `which sqlite3` o el comando `type -a sqlite3` para ver
la ruta al programa. Si al ejecutar alguno de estos comandos no aparece ningún resultado, podría ser necesario instalación.

Para instalar SQLite en sistemas como Debian/Ubuntu, debes ejecutar el comando

```
sudo apt-get install sqlite3
```
![image info](./assets/img/sqlite3.png =100x20)


En sistemas como Red Hat/CentOS, debes usar

```
sudo yum install sqlite.x86_64
```

Si quieres instalar SQLite3 usando Anaconda, por favor usa la [documentación](https://anaconda.org/anaconda/sqlite){:target="_blank"} que ellos proporcionan.

Una vez instalado, cierra todos los terminales abiertos y vuelve a abrirlos. De esta forma se actualizarán variables de entorno como `PATH`
y las configuraciones necesarias para que todo funcione correctamente.
