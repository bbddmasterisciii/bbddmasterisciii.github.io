#!/usr/bin/env python3.8
# -*- coding: utf-8 -*-

'''
	Práticas de Python DB-API 2.0 (PEP-249) y bases de datos biológicas
	Script de generación de un fichero con todas las secuencias en formato FASTA
'''

import sys
import re
import sqlite3 as dbi

'''
Estas variables globales contienen los parÃ¡metros de conexiÃ³n a la base de datos
'''
dbname='uniprot.db'	# El nombre de la base de datos, que tendrÃ©is que cambiarlo

# ComprobaciÃ³n del nÃºmero de parÃ¡metros de entrada
if __name__ == '__main__':
    if len(sys.argv)==2:
		# Se intenta crear el fichero de salida de los datos
		# Estamos abriendo el fichero con el encoding 'latin-1'
        # Para ficheros que contendrÃ¡n acentos, eÃ±es, etc... lo recomendable es el encoding 'utf-8'
        with open(sys.argv[1],'w',encoding="latin-1") as outfile:
			# Apertura de la conexiÃ³n con la base de datos
            try:
                conn = dbi.connect(dbname)
				# Esto sirve para que cada sentencia se ejecute inmediatamente
				# pero si se activa, el fichero generado podrÃ­a no ser coherente
				#conn.autocommit = True
            except dbi.Error as e:
                print("Ha habido un problema al conectar a la base de datos: ",e.diag.message_primary,file=sys.stderr)
                raise
			
			# Procesamiento de cada fichero
            with conn:
                try:
					# ObtenciÃ³n de un cursor para enviar operaciones a la base de datos
					# Tiene que tener nombre para evitar que explote en memoria con la siguiente sentencia
                    cur = conn.cursor()
                    with open(sys.argv[1], "w") as write_file:
						# Vamos a ejecutar la sentencia
                        cur.execute('SELECT accnumber,description,seq FROM SWISSENTRY')
						# Lectura de datos de la base de datos
                        for row in cur:
							# Y escritura de los mismos en formato FASTA
                            print(">{0[0]};{0[1]}".format(row),file=write_file)
                            sequence = row[2]
                            while len(sequence)>60:
                                print(sequence[0:60],file=write_file)
                                sequence = sequence[60:]
							# El Ãºltimo trozo de la secuencia
                            print(sequence,file=write_file)
						
                except dbi.Error as e:
                    print("Error al insertar en la base de datos: ",e.diag.message_primary,file=sys.stderr)
                    raise
                except IOError as e:
                    print("Error de escritura de fichero {0}: {1}".format(e.errno, e.strerror),file=sys.stderr)
                    raise
                except:
                    print("Error inesperado: ", sys.exc_info()[0],file=sys.stderr)
                    raise
		
    else:
        raise AssertionError("Debes introducir el nombre del fichero de salida.")