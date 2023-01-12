#!/usr/bin/env python3.8
# -*- coding: utf-8 -*-

'''
	Prácticas de Python DB-API 2.0 (PEP-249) y bases de datos biológicas
	Script de inserción de entradas en formato SWISSPROT en la base de datos
'''

import sys
import re
import sqlite3 as dbi

'''
Estas variables globales contienen los parámetros de conexión a la base de datos
'''
dbname='uniprot.db'	# El nombre de la base de datos, que tendréis que cambiarlo

def siguienteEntrada(uniF):
	'''
	Este método toma como entrada un manejador de ficheros abierto
	de manera que quien llame repetidamente a este método se deberá
	encargar tanto de abrir ficheros como de cerrarlos una vez se
	termine el trabajo de obtención de entradas.
	'''
	
	# Inicialización de variables
	acc = []
	id = ''
	lastdate = ''
	description = ''
	sequence = ''
	molw = ''
	readingseq = False
	try:
		for line in uniF:
			# Lo primero, quitar el salto de línea
			line = line.rstrip('\n')
			
			# Detección del final del registro
			if re.search('^//',line) is not None:
				# Cuando se ha terminado de leer un
				# registro hay que proceder a guardar
				# los datos en la base de datos
				
				# Si no hemos conseguido capturar la descripción
				# no quiere decir que no tenga, sino que el
				# programa no ha sido capaz de hacerlo
				if description == '':
					description = None
				
				# Impresión de comprobación
				print(f"ACC: {acc[0]} ; ID: {id} ; Last: {lastdate}")
				
				# Como ya tenemos una entrada entera
				# paremos de leer por ahora, para poder
				# devolver lo recopilado
				break
			
			# ¿Estoy leyendo una secuencia?
			if readingseq:
				# Quito todos los espacios intermedios 
				line = re.compile(r"\s+").sub('',line)
				
				# Y concateno
				sequence += line
				
			# Como no la estoy leyendo, busco los patrones apropiados
			else:
				matched = False
				
				seqmatch = re.search(r"^SQ.+[^0-9](\d+) MW",line)
				if seqmatch is not None:
					matched = True
					# Extracción del peso molecular
					# y comienzo de secuencia
					molw = seqmatch.group(1)
					readingseq = True
				
				if not matched:
					idmatch = re.search(r"^ID   ([a-zA-Z0-9_]+)",line)
					if idmatch is not None:
						matched = True
						# Identificador
						id = idmatch.group(1)
				
				if not matched:
					dtmatch = re.search(r"^DT   (\d{2}-[A-Z]{3}-\d{4}),",line)
					if dtmatch is not None:
						matched = True
						# Fecha de la última actualización
						lastdate = dtmatch.group(1)
				
				if not matched:
					acmatch = re.search(r"^AC   (.+)",line)
					if acmatch is not None:
						matched = True
						# Los accnumber, que pueden estar en varias líneas
						ac = acmatch.group(1)
						# Elimino los espacios y quito el posible último punto y coma
						ac = re.compile(r"\s+").sub('',ac).rstrip(';')
						
						# Rompo por los puntos y coma, y
						# añado a la lista de accnumber
						acc.extend(ac.split(';'))
				
				if not matched:
					dematch = re.search(r"^DE   RecName: Full=(.+);",line)
					if dematch is not None:
						matched = True
						# La descripción, que puede estar en varias líneas
						if description != '':
							description += ', EC '
						description += dematch.group(1)
				
	except EOFError:
		# Se ha acabado el fichero sin terminar de recopilar los
		# datos, así que lo indicamos poniendo por ejemplo
		# acc a None
		acc = None
	else:
		# Si no ha habido fallos, pero no hemos recuperado nada,
		# poner acc a None
		if len(acc) == 0:
			acc = None

	# Devolvemos los datos de la entrada, o el indicador de que no hay datos
	return acc,id,lastdate,description,sequence,molw


# Comprobación del número de parámetros de entrada
if __name__ == '__main__':
	# sys.argv contiene tanto el nombre del script como los parámetros
	# que se le introdujeron por línea de comandos al llamar al programa
	if len(sys.argv)>1:
		infiles = sys.argv[1:]
		
		# Apertura de la conexión con la base de datos
		try:
			conn = dbi.connect(dbname)
			# Obtención de un cursor para enviar operaciones a la base de datos
			cur = conn.cursor()
			# Esto sirve para que cada sentencia se ejecute inmediatamente
			#conn.autocommit = True
		except dbi.Error as e:
			print("Ha habido un problema al conectar a la base de datos: ",str(e),file=sys.stderr)
			raise
		
		# Trabajo a nivel de transacción
		with conn:
			# Procesamiento de cada fichero
			for infile in infiles:
				try:
					# Estamos abriendo el fichero con el encoding 'latin-1'
					# Para text mining lo recomendable es el encoding 'utf-8'
					with open(infile, mode='r', encoding='latin-1') as uniF:
						print("Procesando fichero ", infile)
						
						# Este bucle tiene su condición de salida en su interior
						# y por ello es un bucle potencialmente infinito
						while True:
							# Recuperar entradas una a una
							acc,id,lastdate,description,sequence,molw = siguienteEntrada(uniF)
							
							# Como no hay entradas, me salgo
							if acc is None:
								break
							
							# Preparación de las operaciones de inserción a realizar repetidamente
							# (Debería hacer un chequeo aquí, para comprobar que funcionan)
							cur.execute('INSERT INTO SWISSENTRY VALUES (?,?,?,?,?,?)',(acc[0],id,lastdate,description,sequence,molw))
							for accnumber in acc:
									cur.execute('INSERT INTO ACCNUMBERS(main_accnumber,accnumber) VALUES (?,?)',(acc[0],accnumber))
				except dbi.Error as e:
					print("Error al insertar en la base de datos: ",str(e),file=sys.stderr)
					raise
				except IOError as e:
					print("Error de lectura de fichero {0}: {1}".format(e.errno, e.strerror),file=sys.stderr)
					#raise
				except:
					print("Error inesperado: ", sys.exc_info()[0],file=sys.stderr)
					raise
		
	else:
		raise AssertionError("Debes introducir al menos un fichero con formato SW.")
