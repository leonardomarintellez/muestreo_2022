
/*Crear una librería*/

/*Es la dirección de la carpeta (folder) donde se encuentran los archivos */
* El nombre no puede exceder de 8 carácteres;


libname ruta "/home/u60151886/datos";

/*copiar un conjunto de datos*/
data ruta.copy_cars;
set sashelp.cars;
run;


/*crear un subconjunto de datos*/
data work.cars2;
set datos.copy_cars;
if mpg_city > 20;
run;

/*estructura de la tabla*/
proc contents data=datos.copy_cars; run;


/*limpiar (deshabilitar) librerías*/
libname datos clear; 



/*Crear un conjunto de datos*/
DATA EJEMPLO;
LENGTH NOMBRE $ 10 SEXO $ 1 ;
INPUT NOMBRE SEXO;
DATALINES;
NOMBRE1 H
NOMBRE2 M
NOMBRE3 M
NOMBRE4 H
;
RUN;


/*IMPRIMIR EN PANTALLA*/
PROC PRINT DATA=EJEMPLO;
RUN;



* NOTAR QUE LAS DOS CARACTERÍSTICAS ESENCIALES EN UN SCRIPT SON:
> PASO DATA (DATA STEP)
> PASO PROC (PROC STEP);


* PREGUNTA. ¿Cómo se consideran los missing en SAS?, Nota, un valor missing es el valor más negativo de la tabla;


* Buena práctica. Es bueno siempre borrar todo al inicio para no tener archivos o variables ya almacenados;
/*BORAR LAS BASES DE DATOS DE UNA LIBRERIA*/
PROC DATASETS LIB=WORK KILL; QUIT;
