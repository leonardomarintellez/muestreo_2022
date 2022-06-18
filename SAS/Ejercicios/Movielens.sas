


/*===================================================================================================================*/
* Macro generada por SAS;


/* Código generado (IMPORT) */
/* Archivo de origen: data.csv */
/* Ruta de origen: /home/u60151886/datos/movielens */
/* Código generado el: 5/5/22 17:50 */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u60151886/datos/movielens/data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);



/*La primera clase vimos comoimportar datos*/

/**############## IMPORTAR DATOS ##############**/


*definir librería;
libname movies "/home/u60151886/datos/movielens";

/*CSV*/

PROC IMPORT DATAFILE='/home/u60151886/datos/movielens/data.csv'
	DBMS=CSV	REPLACE		/*DATA BASE MANAGEMENT SYSTEM*/
	OUT=movies.data;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IRIS; RUN;


/*===================================================================================================================*/


* A partir del código previo,crear una macro ;


*definir librería;
libname movies "/home/u60151886/datos/movielens";


%macro importar_cvs(lib,tabla);

PROC IMPORT DATAFILE = "/home/u60151886/datos/movielens/&tabla..csv"
	DBMS=CSV	REPLACE		/*DATA BASE MANAGEMENT SYSTEM*/
	OUT=&lib..&tabla;
	GETNAMES=YES;
RUN;

%mend importar_cvs;


*ejecutar;

%importar_cvs(movies,data);
%importar_cvs(movies,item);





/*===================================================================================================================*/


* ejercicios;

/*

Calcular:

- Número de usuarios y número de películas.
- Las 3 películas con mejor promedio y las 3 películas con peor promedio.
- La película con el mayor número de calificaciones y cuantás son.
- El usuario que ha calificado un mayor número de películas y cuántas ha calificado.
- El número promedio de evaluaciones por película.
- Calcular el número de películas por año.

*/

* Solución;

* Definir librería;
libname movies "/home/u60151886/datos/movielens";

* Pegar la información;

* para usar un merge, es necesario ordenar primero las tablas;
PROC SORT DATA = MOVIES.DATA OUT = WORK.DATA; BY ITEM_ID; RUN;
PROC SORT DATA = MOVIES.ITEM OUT = WORK.ITEM; BY ITEM_ID; RUN;

DATA MOVIE_RATINGS;
MERGE DATA (IN = INA) ITEM (KEEP = ITEM_ID TITLE IN = INB);
BY ITEM_ID;
IF INA;
RUN;


DATA MISSINGS;
SET MOVIE_RATINGS;
IF MISSING(TITLE) = 1;
RUN;

*- Número de usuarios y número de películas.;

PROC SQL;
	
	SELECT COUNT(DISTINCT USER_ID) AS NUMERO_USUARIOS, COUNT(DISTINCT ITEM_ID) AS NUMERO_PELICULAS
		FROM MOVIE_RATINGS;

QUIT;


*- Las 3 películas con mejor promedio y las 3 películas con peor promedio.;

PROC SORT DATA = MOVIE_RATINGS; BY ITEM_ID TITLE; RUN;

PROC MEANS DATA = MOVIE_RATINGS NOPRINT;
BY ITEM_ID TITLE;
OUTPUT OUT = TABLA1  N(ITEM_ID) = NUMERO_CALIFICACIONES  MEAN(RATING) = CALIFICACION_PROMEDIO;
RUN;

PROC SORT DATA = TABLA1 OUT = TOP; BY DESCENDING CALIFICACION_PROMEDIO DESCENDING NUMERO_CALIFICACIONES ITEM_ID; RUN;
PROC SORT DATA = TABLA1 (WHERE = (NUMERO_CALIFICACIONES > 100)) OUT = BOTTOM; BY CALIFICACION_PROMEDIO; RUN;



*- La película con el mayor número de calificaciones y cuantás son.;

PROC SORT DATA = TABLA1; BY DESCENDING NUMERO_CALIFICACIONES; RUN;


*- El usuario que ha calificado un mayor número de películas y cuántas ha calificado.;

PROC SORT DATA = MOVIE_RATINGS; BY USER_ID; RUN;

PROC MEANS DATA = MOVIE_RATINGS NOPRINT;
BY USER_ID;
OUTPUT OUT = TABLA2  N(USER_ID) = NUM_PELICULAS_CALIFICADAS  MEAN(RATING) = CALIFICACION_PROMEDIO;
RUN;

PROC SORT DATA = TABLA2; BY DESCENDING NUM_PELICULAS_CALIFICADAS; RUN;


*- El número promedio de evaluaciones por película.;

PROC MEANS DATA = TABLA1 NOPRINT;
OUTPUT OUT = TABLA3 MEAN(NUMERO_CALIFICACIONES) = PROMEDIO;
RUN;


*- Calcular el número de películas por año.;


DATA PRUEBA;
SET ITEM  (KEEP = ITEM_ID RELEASE_DATE);

FORMAT FECHA DATE8.; /*DEFINIR EL FORMATO DE UNA VARIABLE QUE CREAREMOS MÁS ADELANTE*/

FECHA=DATEPART(RELEASE_DATE); /*EXTRAER LA FECHA SOLAMENTE*/
ANIO = YEAR(FECHA);

RUN;


DATA TABLA_AUXILIAR1;
SET MOVIE_RATINGS;

* LO HAREMOS POR PASOS; 
* NOTAR QUE SE PUEDEN ANIDAR TODAS LAS FUNCIONES PARA QUEDAR EN 1 SOLO PASO;
TITLE_REV = COMPRESS(REVERSE(TITLE));
AUX = SUBSTR(TITLE_REV,2,4);
ANIO = REVERSE(AUX);

RUN;


PROC SORT DATA = TABLA_AUXILIAR1 OUT = TABLA_AUXILIAR2 NODUPKEY; BY TITLE; RUN;
PROC SORT DATA = TABLA_AUXILIAR2; BY ANIO; RUN;

/*ES NECESARIO UN PASO CON PARA HACER FIX A LOS REGISTROS ERRONEOS*/

PROC MEANS DATA = TABLA_AUXILIAR2 NOPRINT;
BY ANIO;
OUTPUT OUT = TABLA5  N(ITEM_ID) = CONTEO ;
RUN;









