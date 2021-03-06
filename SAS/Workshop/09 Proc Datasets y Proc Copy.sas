/*########### PROC DATASETS #############*/

/*BORAR LAS BASES DE DATOS DE UNA LIBRERIA*/

PROC DATASETS LIB=WORK KILL; QUIT;


/*ELIMINAR UN DATASET ESPECIFICO*/

PROC DATASETS LIB=WORK;
DELETE DATASET1 DATASET2;
QUIT;


/*ELIMINAR LOS CONJUNTOS DE DATOS DE UNA LIBRERIA CONSERVANDO UN DATASET 
ESPECIFICO*/

PROC DATASETS LIB=WORK;
SAVE DATASET1 DATASET2;
QUIT;


/*RENOMBRAR VARIABLES DE UN DATASET*/

PROC DATASETS LIB=WORK;
MODIFY DATOS;
RENAME VARIABLE_VIEJA=VARIABLE_NUEVA;
RUN; QUIT;
* MUY ÚTIL CUANDO EL CONJUNTO DE DATOS CONTIENE MILLONES DE REGISTROS;


/*CAMBIAR EL NOMBRE DE UN DATASET*/

PROC DATASETS LIB=WORK;
CHANGE DATASET_VIEJO=DATASET_NUEVO;
QUIT;
* MUY ÚTIL CUANDO EL CONJUNTO DE DATOS CONTIENE MILLONES DE REGISTROS;





/*########### PROC COPY #############*/

/*------------------------------------------*/
/*COPIAR CONJUNTOS DE DATOS ENTRE LIBRERIAS*/

	* EJEMPLO 1);
	PROC COPY IN=LIB_INICIAL OUT=LIB_DESTINO;
	SELECT DATASET1;
	RUN;
	* COPIA UNICAMENTE EL CONJUNTO DE DATOS INDICADO,
	SI SE OMITE LA INSTRUCCIÓN 'SELECT' SE COPIAN 
	TODOS LOS ELEMENTOS EN DICHA LIBRERIA;
	
	* EJEMPLO 2);
	PROC COPY IN=LIB_INICIAL OUT=LIB_DESTINO MOVE;
	SELECT DATASET1;
	RUN;
	* LA OPCIÓN 'MOVE' ELIMINA EL DATASET1 DE LA
	LIBRERÍA INICIAL, DEJANDOLO UNICAMENTE EN LA
	LIBRERÍA DESTINO;
	
	* EJEMPLO 3);
	PROC COPY IN=LIB_INICIAL OUT=LIB_DESTINO MOVE;
	SELECT DATOS:;
	RUN;
	*COPIARA TODOS LOS CONJUNTOS DE DATOS QUE INICIEN
	CON EL TEXTO 'DATOS';
	
	
	
	
/*ACUMULAR VARIOS CONJUNTOS DE DATOS EN UNA NUEVA BASE*/
PROC APPEND BASE=LIBRERIA.MASTER DATA=LIBRERIA.DATOS FORCE; RUN; QUIT;