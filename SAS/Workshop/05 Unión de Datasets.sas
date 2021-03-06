
/*UN DATSET CON 150 OBSERVACIONES*/
DATA IRIS;
SET SASHELP.IRIS; /*ARCHIVO Q SE ENCUENTRA EN LA LIBRERIA SASHELP*/
RUN;


* TENEMOS OTRO CONJUTO DE DATOS CON LOS COLORES;
DATA COLORES1;
LENGTH SPECIES $10;
LENGTH COLOR1 $5;
INPUT SPECIES $ COLOR1 $;
DATALINES;
Virginica ROJO
Versicolor VERDE
Setosa AZUL
;
RUN;


/*SE REQUIERE PEGAR LA INFORMACIÓN CONTENIDA EN EL DATASET COLORES AL CONJUNTO 
DE DATOS IRIS*/
/*ES DECIR NOS INTERESA TENER EL COLOR DE LA ESPECIE EN EL CONJUNTO IRIS*/
/*ORDENAR PREVIAMENTE LOS CONJUNTOS USANDO LA VARIABLE A LA CUAL SE LE QUIERE 
HACER EL "MATCH"*/

PROC SORT DATA=IRIS; BY SPECIES; RUN;
PROC SORT DATA=COLORES1; BY SPECIES; RUN;


/*UNIR*/
DATA UNION1;
MERGE IRIS COLORES1;
BY SPECIES;
RUN;


/******************************************************************************************/


* TENEMOS OTRO CONJUTO DE DATOS CON LOS COLORES;
DATA COLORES2;
LENGTH SPECIES $10;
LENGTH COLOR2 $5;
INPUT SPECIES $ COLOR2 $;
DATALINES;
Virginica ROJO
Versicolor VERDE
Otra MORADO
;
RUN;


PROC SORT DATA=IRIS; BY SPECIES; RUN;
PROC SORT DATA=COLORES2; BY SPECIES; RUN;


/*UNIR*/
DATA UNION2;
MERGE IRIS (IN=INA) COLORES2 (IN=INB);
BY SPECIES;
IF INA;
RUN;




/******************************************************************************************/


* TENEMOS OTRO CONJUTO DE DATOS CON LOS COLORES;
DATA COLORES3;
LENGTH SPECIES $10;
LENGTH COLOR3 $5;
INPUT SPECIES $ COLOR3 $;
DATALINES;
Setosa AZUL
Setosa ROSA
Virginica ROJO
Versicolor VERDE
Otra MORADO
;
RUN;


PROC SORT DATA=IRIS; BY SPECIES; RUN;
PROC SORT DATA=COLORES3; BY SPECIES; RUN;


/*UNIR*/
DATA UNION3;
MERGE IRIS (IN=INA) COLORES3 (IN=INB);
BY SPECIES;
IF INA;
RUN;





/******************************************************************************************/



PROC SORT DATA=COLORES1; BY SPECIES; RUN;
PROC SORT DATA=COLORES3; BY SPECIES; RUN;


/*UNIR*/
DATA UNION_COLORES;
MERGE COLORES1 (IN=TABLA1) COLORES3 (IN=TABLA2);
BY SPECIES;
*IF TABLA1;
RUN;




/*UNIR*/
DATA UNION_COLORES2;
MERGE COLORES1 (IN=INA) COLORES3 (IN=INB);
BY SPECIES;
IF INA;
RUN;





