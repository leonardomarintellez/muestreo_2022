/*Mini Análisis Exploratorio datos CARS*/
* EDA por sus siglas en inglés (exploratory data analysis);


* 01 Crear una tabla de frecuencias de la variable type;
	* a) ¿qué tipo de auto es el más común?;

PROC FREQ DATA=SASHELP.CARS;
	TABLE TYPE MAKE;
RUN;
	
* 02 Crear un crosstab de type y origin;
	* a) ¿En que continente no se elaboran camionetas?;

PROC FREQ DATA=SASHELP.CARS;
	TABLE TYPE*ORIGIN;
RUN;
		
* 03 En promedio, ¿qué tipo de auto tiene el menor peso?;

PROC MEANS DATA= SASHELP.CARS MEAN;
	CLASS TYPE;
	VAR WEIGHT;
	RUN;

* 04 ¿Cuáles son las únicas marcas que elaboran carros híbridos?;

* OPCIÓN 1;
PROC FREQ DATA=SASHELP.CARS;
	TABLE MAKE*TYPE;
RUN;

PROC FREQ DATA=SASHELP.CARS;
	WHERE TYPE = "Hybrid";
	TABLE MAKE;
RUN;


* 05 Crear una tabla que contenga únicamente registros donde el modelo sea 'MDX';

* NO OK;
DATA MDX;
SET SASHELP.CARS;
IF MODEL = 'MDX';
RUN;


OK;
DATA MDX;
SET SASHELP.CARS;
IF COMPRESS(MODEL) = 'MDX';
RUN;

* 06 ¿Cuáles son los 3 modelos de auto con mayor cantidad de caballos de fuerza? (top 3);

PROC SORT DATA = SASHELP.CARS OUT = TOP3 ; BY DESCENDING HORSEPOWER; RUN;

* 07 Para cada marca, encontar en valor del mayor rendimiento de gasolina en autopista.;

PROC SORT DATA = SASHELP.CARS OUT = CARS ; BY MAKE; RUN;

PROC MEANS DATA= CARS NOPRINT;
	OUTPUT OUT = TABLA_MAXIMOS  MAX(MPG_HIGHWAY) = MPG_MAX;
	BY MAKE;
	VAR WEIGHT;
RUN;


* 08 Crear una tabla que conserve los registros missing de la variable cilindros.;

DATA MISSINGS;
SET SASHELP.CARS;
WHERE MISSING(CYLINDERS) = 1;
RUN; 

DATA MISSINGS;
SET SASHELP.CARS;
IF MISSING(CYLINDERS) = 1;
RUN; 

* (Difícil) 09 Crear una tabla que tenga el registro con el menor gasto de gasolina en ciudad por tipo de vehículo. ;

/*Nota. Antes de iniciar, ¿qué dificultades encuentran?*/