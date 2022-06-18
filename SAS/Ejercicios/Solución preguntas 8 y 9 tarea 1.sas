
/*=================================================================================*/
/*Pregunta 8*/

* Asignamos la librería;
LIBNAME CENSO '~/my_shared_file_links/u60151886/Censo_2010';

* Para consumir menos recursos, sólo leer las variables de interés;

DATA TABLA_PERSONAS;
SET CENSO.PERSONAS_01_A (KEEP = ID_VIV NUMPER EDAD IDMADRE );
RUN;

* Crear tablas auxiliares para pegarla info;


DATA TABLA_EDAD_PERSONA (KEEP = LLAVE ID_VIV NUMPER EDAD_PERSONA);
SET TABLA_PERSONAS;

LLAVE = ID_VIV || "_" || IDMADRE;
EDAD_PERSONA = EDAD;

RUN;


DATA TABLA_EDAD_MADRE (KEEP = LLAVE ID_VIV NUMPER EDAD_MADRE);
SET TABLA_PERSONAS;

LENGTH ID_PERSONA $2;
ID_PERSONA = SUBSTR(NUMPER,4,2);
LLAVE = ID_VIV || "_" || ID_PERSONA;
EDAD_MADRE = EDAD;

RUN;


* Unir las tablas por llave;
* recordar que las tabls deben estar ordenadas;

PROC SORT DATA=TABLA_EDAD_PERSONA; BY LLAVE; RUN;
PROC SORT DATA=TABLA_EDAD_MADRE; BY LLAVE; RUN;


/*UNIR*/
DATA TABLA_UNION;
MERGE TABLA_EDAD_PERSONA (IN=INA) TABLA_EDAD_MADRE (IN=INB);
BY LLAVE;
IF INA AND INB;
RUN;

 * Revisar 1 ID de Vivienda;
 
 DATA CHECK;
 SET TABLA_PERSONAS;
 WHERE ID_VIV = "00019178";
 RUN;


/*=================================================================================*/
/*Pregunta 9*/ 


*Utilizaremos la tabla de la Ciudad de México del Censo de 2020.;


* Asignamos la librería;
LIBNAME CENSO '~/my_shared_file_links/u60151886/Censo_2020';


* Creamos la variable de grupos quinquenales;
* Es buena práctica definir la longitud de las variables tipo carácter que creemos;

* Para consumir menos recursos, sólo leer las variables de interes;

DATA PERSONAS;
SET CENSO.PERSONAS_09_A (OBS = 1000 KEEP = EDAD SEXO );
LENGTH GRUPOS_EDAD $ 25;

UNOS = 1;

IF 0 <= EDAD <= 4 THEN GRUPOS_EDAD = 'G01. 00-04 AÑOS';
ELSE IF 5 <= EDAD <= 9 THEN GRUPOS_EDAD = 'G02. 05-09 AÑOS';
ELSE IF 10 <= EDAD <= 14 THEN GRUPOS_EDAD = 'G03. 10-14 AÑOS';
ELSE IF 15 <= EDAD <= 19 THEN GRUPOS_EDAD = 'G04. 15-19 AÑOS';
ELSE GRUPOS_EDAD = 'G99. MISSING';

RUN;


* Agrupar por edad y sexo;

* Recordar que el dataset debe estar ordenado;
PROC SORT DATA = PERSONAS; BY GRUPOS_EDAD SEXO; RUN;

PROC MEANS DATA = PERSONAS NOPRINT;
OUTPUT OUT = AGRUPACION_POR_SEXO (DROP = _TYPE_ _FREQ_) SUM(UNOS) = NUM_PERSONAS;
BY GRUPOS_EDAD SEXO;
VAR UNOS;
RUN;


* Transponer la info para darle el formato deseado;
PROC TRANSPOSE DATA = AGRUPACION_POR_SEXO OUT  = TABLA_TRANSPUESTA (DROP = _NAME_) PREFIX = SEXO_ ;
BY GRUPOS_EDAD;
ID SEXO;
VAR NUM_PERSONAS;
RUN;


* Notar que la siguiente parte no funcionará correctamente del todo;
* ¿qué pasa cuando usamos una variable qué no existe?;
DATA TABULADO;
SET TABLA_TRANSPUESTA;
POB_TOTAL = SEXO_1 + SEXO_2;
POBLACION_TOTAL = SUM(SEXO_1,SEXO_2);
RUN;

* renombrar variables de forma eficiente;
* usar un proc datasets para renombrra variables es mucho más rápido que cargar la tabla;

PROC DATASETS LIB=WORK;
MODIFY TABULADO;
RENAME SEXO_1 = HOMBRES SEXO_3 = MUJERES;
RUN; QUIT;






