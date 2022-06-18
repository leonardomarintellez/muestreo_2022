

libname censo '~/my_shared_file_links/u60151886/Censo_2010';

/*********************************************************************************/
* Extraer una muestra MAS;

/*srs : simple random sampling*/
proc surveyselect data=sashelp.cars method=srs n=150 
                  seed=2020 out=work.muestra_mas;

run;



data muestra;
set muestra_mas;
factor_mas = 2.8;
run;


/*********************************************************************************/
* Hacer estimaciones con una muestra;

* Filtrar registros deseados;
data viviendas_cdmx;
set censo.viviendas_09_a;
if clavivp in ('1','2','3','4','9');
unos = 1;
personas = numpers+0;
run;

/* se excluyen las claves:
	'5' Local no construido para habitación
	'6' Vivienda móvil
	'7' Refugio
*/


proc surveymeans data = viviendas_cdmx sum alpha = 0.05 clsum;
var personas;
weight factor;
run;


/*======================================================================================================*/

libname censo '~/my_shared_file_links/u60151886/Censo_2010';

/*======================================================================================================*/




* Filtrar registros deseados;
data viviendas_ags;
set censo.viviendas_01_a;
if clavivp in ('1','2','3','4','9');
unos = 1;
personas = numpers+0;
run;


* Filtrar registros deseados;
data viviendas_cdmx;
set censo.viviendas_09_a;
if clavivp in ('1','2','3','4','9');
unos = 1;
personas = numpers+0;
run;


* crear una sola tabla;
data viviendas;
set viviendas_ags viviendas_cdmx;
run;


proc sort data = viviendas; by ent nom_ent; run;

proc surveyfreq data = viviendas;
by nom_ent;
cluster upm;
strata estrato;
weight factor;
table techos / cl alpha=0.10 cv;
run;



/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/

proc sort data = censo.viviendas_09_a out = tabla_viviendas_ordenada; by nom_mun; run;

proc surveyselect data=tabla_viviendas_ordenada (keep = ent mun nom_ent nom_mun)
method=srs n=100
seed=2022 out=muestra_estratificada1;
strata nom_mun;
run;

proc freq data = censo.viviendas_09_a;
table nom_mun;
run;

proc freq data = muestra_estratificada1;
table nom_mun;
run;

*------------------------------------------------------------------------------------------------------;

* HACER UNA MUESTRA ESTRATIFICADA PROPORCIONAL AL TAMAÑO ;


* Referencia: Libro SAS STAT Procedures.;

/*
SAMPSIZE=SAS-data-set
N=SAS-data-set
names a SAS data set that contains the sample sizes for the strata. This input data
set should contain all the STRATA variables, with the same type and length as in
the DATA= data set. The STRATA groups should appear in the same order in the
SAMPSIZE= data set as in the DATA= data set. The SAMPSIZE= data set should
have a variable _NSIZE_ that contains the sample size for each stratum.
Each stratum sample size value must be a positive integer.
*/

proc freq data = tabla_viviendas_ordenada noprint;
by nom_mun;
table mun / out = tabla_aux0;
run;


* sacar el total;

data tabla_aux1;
set tabla_aux0;
retain suma_acumulada 0;
suma_acumulada = suma_acumulada + count;
run;

* guardar el valor en una macro variable para utilizarlo ;

data _null_;
set tabla_aux1;
call symput("total",suma_acumulada);
run;

%put &total;


data tabla_aux2;
set tabla_aux1;
_nsize_ = round(15000 * count/&total);
run;


* utilizar la tabla auxiliar para hacer muestreo estratificado proporcional al tamaño;

proc surveyselect data=tabla_viviendas_ordenada (keep = ent mun nom_ent nom_mun)
method=srs n=tabla_aux2
seed=2022 out=muestra_estratificada2;
strata nom_mun;
run;




