
# (PART) Aplicaciones {-}

# Manejo avanzado de datos políticos {#manejo-av}
*Por Andrés Cruz Labrín y Francisco Urdinez*

## Introducción

En este capítulo tratamos dos problemas que son muy recurrente entre quienes usamos datos internacionales. El primero de ellos es el de la estandarización de los “códigos” que se utiliza para cada país. Estos códigos son importantes, porque a partir de estos es que unimos dos o más bases de datos de diferentes fuentes. Piense por ejemplo el siguiente escenario: su base tiene una variable llamada “país” donde Brasil es codificado en mayúsculas como “BRASIL”. Luego toma datos del Banco Mundial y los datos de Brasil están como “Brazil”, y luego toma datos de Correlates of War donde Brasil es el código 140. Si este problema se repite para los más de 200 países de su muestra, ¿cómo resuelve de manera rápida este rompecabezas? El segundo problema es que muchas veces nuestros datos tienen datos faltantes, o como se les llama comúnmente “missing values”.

Este problema no nos afecta demasiado para regresiones lineares o logísticas pues ´R´ simplemente elimina la observación que tiene algún dato faltante en su variable dependiente, independiente o controles. El problema se presenta cuando estos datos son usados para crear gráficos. Piense por ejemplo que queremos comparar diez países de América Latina en la evolución de su tasa de desempleo entre 2008 y 2018, y sin embargo, uno de ellos no tiene datos para el trienio 2010-2013. Además, en algunos modelos avanzados, como los espaciales, tener valores faltantes puede impedirnos ejecutar los comandos. Para estos casos, podemos considerar imputar estos datos, es decir, completar los datos faltantes a partir de la información que tenemos para los otros países. Hacer esto tiene un costo que discutiremos en breve, ya que como toda solución, no es perfecta. 

Para ejemplificar este ejercicio vamos a usar la base de datos sobre tratados internacionales creada por Carsten Schulz en base al repositorio de (Naciones Unidas con todos los tratados internacionales existentes)[https://treaties.un.org/]. La base del ejemplo está simplificada, apenas tenemos dos tratados internacionales en vez de las decenas que originalmente tiene la base. Estos son el Tratado de Prohibición Completa de los Ensayos Nucleares de 1996 y El Estatuto de Roma, que es es el instrumento constitutivo de la Corte Penal Internacional, de 1998.





```r
tratados <- read_csv("00-datos/schulz_tratados.csv")
## Parsed with column specification:
## cols(
##   treaty_name = col_character(),
##   adoption_date = col_date(format = ""),
##   location = col_character(),
##   country_name = col_character(),
##   action_type_string = col_character(),
##   action_date = col_date(format = "")
## )
names(tratados)
## [1] "treaty_name"        "adoption_date"      "location"          
## [4] "country_name"       "action_type_string" "action_date"
```
Cada tratado tiene información del proceso de incorporación doméstica del tratado, es decir, la firma, aceptación, ratificación y delegación. Estas acciones son cinco, y están categorizadas en la variable ´action_type_string´ y además son acompañadas de la fecha de cada acción en la variable ´action_date´. La variable ´location´ registra la ciudad donde se firmó el tratado internacional, y ´country name´ el nombre de cada país. 

## ¿Cómo aprovechar ´countrycode´?

Teniendo la base de datos de Carsten Schulz, queremos agregar a cada país el índice de capacidades materiales que codifica Correlates of War. Este índice es un proxy de la noción realista de poder, y combina seis indicadores de poder duro, a saber consumo primario de energía, la población total, la población urbana, producción de acero y hierro, gasto militar y número de tropas militares. El índice varía de 0 a 1 pues representa la proporción que cada país representa del poder mundial total en un año determinado. Una vez que hemos agregado estos datos a la base, queremos analizarlos pero únicamente para la región de América Latina. 
 El paquete ´countrycode´ nos permitirá hacer ambas cosas de manera simple. 

**PENDIENTE**. Pasos:

1. CONTAR QUÉ HACE EL PAQUETE.
1. HACER PRIMER PASO (dar un codebook que permita hacer el merge con COW)
1. HACER SEGUNDO PASO (agregar variable de regiones para poder filtar America Latina)
1. Mostrar resultado


## ¿Cómo imputar datos?

*PENDIENTE*

Dos opciones

- Amelia
- MICE
