
/*MACROS IN SAS*/

* Ventajas: 
	Simplificar programas
	Crear funciones;
	
	
/*Macro variables*/


*::::::::::::::::::::::::::::::::::::::::::::::::;
* Método 1. Asignación;

* asignar;
%let nombre = Muestreo;

* invocar;
%put &nombre;


* ejemplo;

%let numbers = one two sas three four;
%put &numbers;

%let texto = %scan(&numbers,3, " ");
%put &texto;

%put texto;


*::::::::::::::::::::::::::::::::::::::::::::::::;
* Método 2. call symput;
* por medio de un paso data;

* Ejemplos;

DATA _NULL_;
SET SASHELP.CARS;
WHERE UPPER(COMPRESS(ORIGIN)) = "ASIA"; /*notar que se quitan los espacios en blanco y se valida en mayusculas*/
CALL SYMPUT("NUM_CILINDROS",CYLINDERS);
RUN;

%PUT &NUM_CILINDROS;



* ;

DATA _NULL_;
SET SASHELP.CARS;
CALL SYMPUT("n",_N_);
RUN;

%PUT &N;





/*==========================================================================================*/
/*MACRO FUNCTIONS*/	



/*CREAR TABLA CON DATOS FICTICIOS*/
DATA CLIENTES;
DO CLIENTE=1,2;
DO BUCKET=1 TO 5;
OUTPUT;
END;
END;
RUN;

* FILTRAR SIN MACRO;
DATA EJEMPLO;
SET WORK.CLIENTES;
IF BUCKET = 1;
RUN;

/*MACRO PARA SEPARAR EN VARIAS TABLAS*/
/*PARÁMETRO: */
	*LIB: LIBRERIA DONE SE UBICA LA TABLA;
	*TABLA_ORIGEN: LA TABLA A LA CUAL SE LE QUIERE HACER UN SPLIT;


/*PUEDE HABER PARAMETROS POSICIONALES Y PARAMETROS OPCIONALES*/
%MACRO TABLAS(LIB,TABLA_ORIGEN);
	%DO I=1 %TO 5;

	DATA TABLA&I;
	SET &LIB..&TABLA_ORIGEN; /*NOTAR SE HAY 2 PUNTOS, EL PRIMERO ES PARA CORTAR LA PRIMERA MACRO VARIABLE*/
	IF BUCKET = &I;
	RUN;
	
	%END;
%MEND TABLAS;

* EJECUTAR;
%TABLAS(WORK,CLIENTES);



/*PARA CONCATENAR TABLAS (APPEND)  SE UTILIZA UN PROC APPEND*/

DATA TABLA_BASE;
SET TABLA1;
RUN;

PROC APPEND BASE=TABLA_BASE DATA=TABLA2 FORCE; RUN; QUIT;
PROC APPEND BASE=TABLA_BASE DATA=TABLA3 FORCE; RUN; QUIT;



/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

/*MACRO PARA RENOMBRAR LOS CAMPOS DE UNA TABLA*/


DATA IRIS;
SET SASHELP.IRIS;
RUN;


/*GUARDAR NOS NOMBRES DE LAS VARIABLES EN UNA TABLA*/
PROC CONTENTS DATA=IRIS  OUT=MNEMONICOS (KEEP=NAME VARNUM) NOPRINT;
RUN; QUIT;

PROC SORT DATA=MNEMONICOS; BY VARNUM; RUN;


/*CREAR UNA MACRO VARIABLE CON LOS NOMBRES*/
PROC SQL NOPRINT;
SELECT NAME INTO: MNEMONICO SEPARATED BY ' ' FROM MNEMONICOS;
QUIT;

%PUT &MNEMONICO;

/*OBTENER EL NUMERO DE VARIABLES*/
DATA _NULL_ ;
SET  MNEMONICOS;
CALL SYMPUT("NN",VARNUM);
RUN;

%PUT &NN;



%MACRO RENOMBRAR(LIB,DS);
DM LOG 'CLEAR'  CONTINUE;

%DO J=1 %TO %EVAL(&NN);

%LET VAR&J=%SCAN(&MNEMONICO,&J);
%LET NEW_VAR&J=New_%SCAN(&MNEMONICO,&J);


/*RENOMBRAR LAS VARIABLES*/
/*CAMBIAR LIBRERIA*/

PROC DATASETS LIB=&LIB. NOLIST;   
 MODIFY &DS.;
 RENAME &&VAR&J=&&NEW_VAR&J;
 		/*OLD_VAR=NEW_VAR*/
 QUIT; RUN;

%END;

%MEND RENOMBRAR;

%RENOMBRAR(WORK,IRIS);









 

