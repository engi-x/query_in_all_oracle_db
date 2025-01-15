#!/bin/bash
echo "################################################################
#Autor: Alengi Benzant                                         #
#Fecha: 28/11/2024                                             #
#Comentario: Script para ejecutar query en varias              #
#Bases de datos                                                #
################################################################
"
ORACLE_BASE=/u01/app/oracle
ORACLE_HOME=/u01/app/oracle/product/19c/db
export ORACLE_BASE ORACLE_HOME 

echo "****************************************************************
*                                                              *
*                    *****PRECAUCION!*****                     *
*                                                              *
* Este script recibe una sentencia SQL y la ejecuta en         *
* todas las bases de datos o de manera individual.             *
*                                                              *
* Este script tambien puede gestionar las bases de datos,      *
* subiendolas o bajandolas, de manera individual o en conjunto *
*                                                              *    
* Ej query: SELECT * FROM ABENZANT.LISTA;                      *        
* Ej query: CREATE TABLE ABENZANT.LISTA(lista VARCHAR(50));    *
* Ej query: startup;                                           *
* Ej query: shutdown immediate;                                *
*                                                              * 
****************************************************************"

echo ""

query_validation() {

	echo "        Introduce query: \c"
	read -r query

	if [ -z "$query" ];
	then
		echo "        La consulta no puede estar vacia."
		exit 1
	fi

}

execute_query_in_all_db() {

	query_validation

	#si la variable $query es igual a "startup" inicia las instancias.
	if [ "$(echo "$query" | tr '[:upper:]' '[:lower:]')" = "startup" ];
	then		
		#toma los nombres de las instancias de los archivos $ORACLE_HOME/dbs/hc_XXX.dat para subir las instancias. 
		INSTANCES=$(ls $ORACLE_HOME/dbs/hc_* | grep -v hc_ARCHIVELOG.dat | awk -F'hc_|.dat' '{print $2}')
		for instance in $INSTANCES
		do
			export ORACLE_SID=$instance
			sqlplus / as sysdba<<EOF
			$query
			exit;
EOF
		done															
	else	
		#valida los nombres de las instancias desde los procesos SMON
		INSTANCES=$(ps -ef | grep smon | awk '{print $8 $9}' | cut -d'_' -f3 | grep -v +ASM | grep -v grepsmon | grep -v grep-v | grep -v osysmond.bin | grep -v MGMTDB | sort -u)
		for instance in $INSTANCES
		do
			export ORACLE_SID=$instance
			sqlplus / as sysdba<<EOF
			$query
			exit;
EOF
		done
	fi

}

execute_query_per_db() {

	echo "        Introduce instancias separadas por espacios (ej: qa1 qa3 qa7): \c"
	read -r lines

	INSTANCES=$(echo "$lines")

	if [ -z "$INSTANCES" ];
	then
	echo "        Debes elegir por lo menos 1 instancia."
	exit 1
	fi

	query_validation

	if [ "$(echo "$query" | tr '[:upper:]' '[:lower:]')" = "startup" ];
	then		 				
		for instance in $INSTANCES
		do
			export ORACLE_SID=$instance
			sqlplus / as sysdba<<EOF
			$query
			exit;
EOF
		done
	else
		for instance in $INSTANCES
		do
		export ORACLE_SID=$instance
		sqlplus / as sysdba<<EOF
		$query
		exit;
EOF
done	
fi

}

menu() {
	echo "
	Que desea hacer?

	1) Ejecutar un query en todas las instancias.
	2) Elegir instancias especificas para ejecutar un query.
	0) Salir

	Intoduce seleccion: \c"
	read -r chosen
case $chosen in
		1) execute_query_in_all_db ;
		menu ;;
		2) execute_query_per_db ;
		menu ;;
		0) exit 0 ;;
		*) echo "Opcion incorrecta.";
		WrongCommand;;
		esac
	}

menu
