
# Manejo de datos {#manejo-de-datos}

*Por Andrés Cruz*

## Introducción

Cuando hablamos de análisis de datos, casi siempre nos referimos a análisis de *bases de datos*.  Aunque hay varios formatos de bases de datos disponibles, en ciencias sociales generalmente usamos y creamos *bases de datos tabulares*, que son las que este libro tratará. Muy probablemente el lector estará familiarizado con la estructura básica de este tipo de bases, gracias a las planillas de Microsoft Excel, Google Spreadsheets y/o LibreOffice Calc. La primera fila suele ser un **header** o encabezado, que indica qué datos registran las celdas de esa columna.

En general, queremos que nuestras bases de datos tabulares tengan una estructura *tidy* (véase [R4DS](http://r4ds.had.co.nz/)). La idea de una base *tidy* es simple: cada columna es una variable, cada fila una observación (de acuerdo a la unidad de análisis) y, por lo tanto, cada celda es una observación.


### Nuestra base de datos

Para este capítulo usaremos una sección de la base de datos de *Quality of Government* [(QoG, 2017)](https://qog.pol.gu.se), un proyecto que registra diversos datos de países. 

Las variables de la base de datos están descritas a continuación:

variable           | descripción
------------------ | -------------------------------------------------------------------------------------------
cname              | Nombre del país
wdi_gdppppcon2011  | GDP PPP, en dólares del 2011, según los datos de WDI (p. 635 del codebook)
wdi_pop            | Población, según los datos de WDI (p. 665)
ti_cpi             | Índice de Percepción de la Corrupción de TI. Va de 0 a 100, con 0 lo más corrupto (p. 560)
lp_muslim80        | Porcentaje de población de religión musulmana, para 1980, según LP (p. 447)
fh_ipolity2        | Nivel de democracia según FH. Va de 0 a 10, con 0 como menos democrático (p. 291)
region             | Región del país, según WDI (añadida a la base)



Para comenzar a trabajar carguemos el paquete `tidyverse`, uno de los centrales del libro, que nos dará funciones útiles para trabajar con nuestra base datos.


```r
library(tidyverse)
```


Ahora carguemos la base de datos a nuestra sesión de R R. Se llama "qog", y podemos cargarla con facilidad desde el paquete del libro, por medio de la función `data()`:


```r
library(paqueteadp)
data(qog)
```

Puedes chequear que la base se cargó correctamente utilizando el comando `ls()` (o viendo la pestaña de Environment en RStudio):


```r
ls()
## [1] "qog"
```



### Describir la base

Para aproximarnos a nuestra base recién cargada tenemos varias opciones. Podemos, como antes, simplemente usar su nombre como un comando para un resumen rápido:


```r
qog
## # A tibble: 139 x 7
##    cname  wdi_gdppppcon2011 wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region  
##    <chr>              <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>   
##  1 Afgha…       57566228480  3.07e7      8      99.3         2.02  Souther…
##  2 Alban…       28715335680  2.90e6     31      20.5         8.08  Souther…
##  3 Alger…      507901640704  3.82e7     36      99.1         4.25  Norther…
##  4 Angola      152477499392  2.34e7     23       0           3.25  Middle …
##  5 Austr…      990474338304  2.31e7     81       0.200      10     Austral…
##  6 Austr…      373413642240  8.48e6     69       0.600      10     Western…
##  7 Baham…        8497731584  3.78e5     71       0          10     Caribbe…
##  8 Bahra…       56583507968  1.35e6     48      95           0.833 Western…
##  9 Bangl…      446835425280  1.57e8     27      85.9         6.42  Souther…
## 10 Barba…        4333428224  2.83e5     75       0.200      10     Caribbe…
## # … with 129 more rows
```

También podemos utilizar la función `glimpse()` para tener un resumen desde otra perspectiva:


```r
glimpse(qog)
## Observations: 139
## Variables: 7
## $ cname             <chr> "Afghanistan", "Albania", "Algeria", "Angola",…
## $ wdi_gdppppcon2011 <dbl> 5.8e+10, 2.9e+10, 5.1e+11, 1.5e+11, 9.9e+11, 3…
## $ wdi_pop           <dbl> 3.1e+07, 2.9e+06, 3.8e+07, 2.3e+07, 2.3e+07, 8…
## $ ti_cpi            <dbl> 8, 31, 36, 23, 81, 69, 71, 48, 27, 75, 75, 63,…
## $ lp_muslim80       <dbl> 99.3, 20.5, 99.1, 0.0, 0.2, 0.6, 0.0, 95.0, 85…
## $ fh_ipolity2       <dbl> 2.02, 8.08, 4.25, 3.25, 10.00, 10.00, 10.00, 0…
## $ region            <chr> "Southern Asia", "Southern Europe", "Northern …
```

Una alternativa que nos permite ver la base completa es la función `View()`, análoga a clickear nuestro objeto en la pestaña "Environment" de Rstudio:


```r
View(qog)
```


## Operaciones en bases

A continuación veremos varias operaciones en nuestra base de datos, en línea con lo enseñado en [el capítulo del R4DS](https://r4ds.had.co.nz/transform.html).

### Ordenar una base

Una de las operaciones más comunes con bases de datos es ordenarlas de acuerdo a alguna de las variables. Esto nos puede dar insights (¿traducción?) inmediatos sobre nuestras observaciones. Por ejemplo, ordenemos la base de acuerdo a población:


```r
arrange(qog, wdi_pop)
## # A tibble: 139 x 7
##    cname    wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region 
##    <chr>               <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>  
##  1 Dominica        722668736   72005   58         0           10    Caribb…
##  2 Seychel…       2229991168   89900   54         0.300        6.94 Easter…
##  3 Tonga           513904512  105139   31.4       0            8.59 Polyne…
##  4 Kiribati        183852816  108544   30.8       0           10    Micron…
##  5 St Lucia       1871906688  182305   71         0           10    Caribb…
##  6 Sao Tom…        540452288  182386   42         0            8.59 Middle…
##  7 Samoa          1047012608  190390   52         0            8.59 Polyne…
##  8 Barbados       4333428224  282503   75         0.200       10    Caribb…
##  9 Iceland       13266284544  323764   78         0           10    Northe…
## 10 Bahamas        8497731584  377841   71         0           10    Caribb…
## # … with 129 more rows
```

El lector debe notar cómo el primer argumento, "qog", toma la base de datos y los siguientes enuncian **cómo** ordenarla, en este caso, por "wdi_pop", la variable de población.

Debe notar también cómo el comando anterior no crea ningún objeto, solo muestra los resultados en la consola. Para crear uno tenemos que seguir la fórmula típica de asignación:


```r
qog_ordenada <- arrange(qog, wdi_pop)
```

Podemos realizar ambas operaciones, mostrar los resultados y crear el objeto, rodeando este último comando con paréntesis:


```r
( qog_ordenada <- arrange(qog, wdi_pop) )
## # A tibble: 139 x 7
##    cname    wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region 
##    <chr>               <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>  
##  1 Dominica        722668736   72005   58         0           10    Caribb…
##  2 Seychel…       2229991168   89900   54         0.300        6.94 Easter…
##  3 Tonga           513904512  105139   31.4       0            8.59 Polyne…
##  4 Kiribati        183852816  108544   30.8       0           10    Micron…
##  5 St Lucia       1871906688  182305   71         0           10    Caribb…
##  6 Sao Tom…        540452288  182386   42         0            8.59 Middle…
##  7 Samoa          1047012608  190390   52         0            8.59 Polyne…
##  8 Barbados       4333428224  282503   75         0.200       10    Caribb…
##  9 Iceland       13266284544  323764   78         0           10    Northe…
## 10 Bahamas        8497731584  377841   71         0           10    Caribb…
## # … with 129 more rows
```

La operación para ordenar realizada antes iba de menor a mayor, en términos de población. Si queremos el orden inverso (decreciente), basta con añadir un signo menos (-) antes de la variable:


```r
arrange(qog, -wdi_pop)
## # A tibble: 139 x 7
##    cname   wdi_gdppppcon2011 wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region 
##    <chr>               <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>  
##  1 China      16023988207616  1.36e9     40       2.40         1.17 Easter…
##  2 India       6566166134784  1.28e9     36      11.6          8.5  Southe…
##  3 United…    16230494765056  3.16e8     73       0.800       10    Northe…
##  4 Indone…     2430921605120  2.51e8     32      43.4          7.83 South-…
##  5 Brazil      3109301780480  2.04e8     42       0.100        8.67 South …
##  6 Pakist…      810954457088  1.81e8     28      96.8          6.33 Southe…
##  7 Nigeria      941462781952  1.73e8     25      45            5.58 Wester…
##  8 Bangla…      446835425280  1.57e8     27      85.9          6.42 Southe…
##  9 Japan       4535077044224  1.27e8     74       0           10    Easter…
## 10 Mexico      1997247479808  1.24e8     34       0            7.83 Centra…
## # … with 129 more rows
```

¡Con eso tenemos los países con mayor población en el mundo! ¿Qué pasa si queremos los países con mayor población **dentro de cada región**? Tendríamos que realizar un ordenamiento en dos pasos: primero por región y luego por población. Con `arrange()` esto es simple:


```r
arrange(qog, region, -wdi_pop)
## # A tibble: 139 x 7
##    cname   wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region  
##    <chr>              <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>   
##  1 Austra…     990474338304  2.31e7     81       0.200       10    Austral…
##  2 New Ze…     148189986816  4.44e6     91       0           10    Austral…
##  3 Cuba        226685157376  1.14e7     46       0            1.17 Caribbe…
##  4 Haiti        16999370752  1.04e7     19       0            4.58 Caribbe…
##  5 Domini…     122657308672  1.03e7     29       0            8.25 Caribbe…
##  6 Jamaica      22884503552  2.71e6     38       0.100        8.5  Caribbe…
##  7 Trinid…      40973463552  1.35e6     38       6.5          9.17 Caribbe…
##  8 Bahamas       8497731584  3.78e5     71       0           10    Caribbe…
##  9 Barbad…       4333428224  2.83e5     75       0.200       10    Caribbe…
## 10 St Luc…       1871906688  1.82e5     71       0           10    Caribbe…
## # … with 129 more rows
```

A propósito del resultado anterior, el lector puede deducir que cuando `arrange()` ordena variables categóricas (en vez de numéricas) lo hace alfabéticamente. Añadir un signo menos (-) antes de la variable hará que el orden sea al revés en términos del alfabeto:


```r
arrange(qog, desc(region), -wdi_pop) # no sé por qué - no funciona, ARREGLAR
## # A tibble: 139 x 7
##    cname    wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region 
##    <chr>               <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>  
##  1 France …    2459435270144  6.59e7     71       3            9.75 Wester…
##  2 Netherl…     762382450688  1.68e7     83       1           10    Wester…
##  3 Belgium      452154359808  1.12e7     75       1.10         9.5  Wester…
##  4 Austria      373413642240  8.48e6     69       0.600       10    Wester…
##  5 Switzer…     444201566208  8.09e6     85       0.300       10    Wester…
##  6 Luxembo…      48842280960  5.43e5     80       0           10    Wester…
##  7 Turkey      1392197369856  7.50e7     50      99.2          7.67 Wester…
##  8 Iraq         510895521792  3.38e7     16      95.8          4.5  Wester…
##  9 Saudi A…    1478747750400  3.02e7     46      98.8          0    Wester…
## 10 United …     560986259456  9.04e6     69      94.9          1.33 Wester…
## # … with 129 more rows
```



### Seleccionar columnas

A veces queremos trabajar solo con algunas variables de una base de datos. Para esto existe la función `select()`. Pensemos que queremos solo el nombre de cada país (cname) y su porcentaje de población musulmana para 1980:


```r
select(qog, cname, lp_muslim80)
## # A tibble: 139 x 2
##    cname       lp_muslim80
##    <chr>             <dbl>
##  1 Afghanistan      99.3  
##  2 Albania          20.5  
##  3 Algeria          99.1  
##  4 Angola            0    
##  5 Australia         0.200
##  6 Austria           0.600
##  7 Bahamas           0    
##  8 Bahrain          95    
##  9 Bangladesh       85.9  
## 10 Barbados          0.200
## # … with 129 more rows
```

Al igual que para `arrange()`, aquí el primer argumento designa la base a modificar y los demás cómo se debería hacer eso -en este caso, qué variables deben ser seleccionadas.



Añadir un signo menos (-) aquí indica qué variables *no* seleccionar. Por ejemplo, quitemos el porcentaje de población musulmana para 1980 de la base:


```r
select(qog, -lp_muslim80)
## # A tibble: 139 x 6
##    cname     wdi_gdppppcon2011  wdi_pop ti_cpi fh_ipolity2 region          
##    <chr>                 <dbl>    <dbl>  <dbl>       <dbl> <chr>           
##  1 Afghanis…       57566228480   3.07e7      8       2.02  Southern Asia   
##  2 Albania         28715335680   2.90e6     31       8.08  Southern Europe 
##  3 Algeria        507901640704   3.82e7     36       4.25  Northern Africa 
##  4 Angola         152477499392   2.34e7     23       3.25  Middle Africa   
##  5 Australia      990474338304   2.31e7     81      10     Australia and N…
##  6 Austria        373413642240   8.48e6     69      10     Western Europe  
##  7 Bahamas          8497731584   3.78e5     71      10     Caribbean       
##  8 Bahrain         56583507968   1.35e6     48       0.833 Western Asia    
##  9 Banglade…      446835425280   1.57e8     27       6.42  Southern Asia   
## 10 Barbados         4333428224   2.83e5     75      10     Caribbean       
## # … with 129 more rows
```

Aparte de seleccionar variables específicas, `select()` es capaz de entender referencias a intervalos de variables. Por ejemplo, podemos querer las cuatro primeras variables:


```r
select(qog, cname:ti_cpi)
## # A tibble: 139 x 4
##    cname       wdi_gdppppcon2011   wdi_pop ti_cpi
##    <chr>                   <dbl>     <dbl>  <dbl>
##  1 Afghanistan       57566228480  30682500      8
##  2 Albania           28715335680   2897366     31
##  3 Algeria          507901640704  38186136     36
##  4 Angola           152477499392  23448202     23
##  5 Australia        990474338304  23125868     81
##  6 Austria          373413642240   8479375     69
##  7 Bahamas            8497731584    377841     71
##  8 Bahrain           56583507968   1349427     48
##  9 Bangladesh       446835425280 157157392     27
## 10 Barbados           4333428224    282503     75
## # … with 129 more rows
select(qog, 1:4) # lo mismo, aunque no recomendado
## # A tibble: 139 x 4
##    cname       wdi_gdppppcon2011   wdi_pop ti_cpi
##    <chr>                   <dbl>     <dbl>  <dbl>
##  1 Afghanistan       57566228480  30682500      8
##  2 Albania           28715335680   2897366     31
##  3 Algeria          507901640704  38186136     36
##  4 Angola           152477499392  23448202     23
##  5 Australia        990474338304  23125868     81
##  6 Austria          373413642240   8479375     69
##  7 Bahamas            8497731584    377841     71
##  8 Bahrain           56583507968   1349427     48
##  9 Bangladesh       446835425280 157157392     27
## 10 Barbados           4333428224    282503     75
## # … with 129 more rows
```

Otra herramienta para complejizar nuestra selección se encuentra en las funciones de ayuda. Entre ellas, `starts_with` es de particular utilidad, permitiendo seleccionar variables que empiecen con cierto patrón. Por ejemplo, podríamos querer, a partir del nombre del país, todas las variables que provengan de los World Development Indicators (WDI) del Banco Mundial:


```r
select(qog, cname, starts_with("wdi_"))
## # A tibble: 139 x 3
##    cname       wdi_gdppppcon2011   wdi_pop
##    <chr>                   <dbl>     <dbl>
##  1 Afghanistan       57566228480  30682500
##  2 Albania           28715335680   2897366
##  3 Algeria          507901640704  38186136
##  4 Angola           152477499392  23448202
##  5 Australia        990474338304  23125868
##  6 Austria          373413642240   8479375
##  7 Bahamas            8497731584    377841
##  8 Bahrain           56583507968   1349427
##  9 Bangladesh       446835425280 157157392
## 10 Barbados           4333428224    282503
## # … with 129 more rows
```

Otra función de ayuda útil es `everything()`, que se lee como "todas las demás variables". Es especialmente útil para cambiar el orden de las variables en una bases de datos. Por ejemplo, pasemos región al segundo lugar entre las variables:


```r
select(qog, cname, region, everything())
## # A tibble: 139 x 7
##    cname  region    wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2
##    <chr>  <chr>                <dbl>   <dbl>  <dbl>       <dbl>       <dbl>
##  1 Afgha… Southern…      57566228480  3.07e7      8      99.3         2.02 
##  2 Alban… Southern…      28715335680  2.90e6     31      20.5         8.08 
##  3 Alger… Northern…     507901640704  3.82e7     36      99.1         4.25 
##  4 Angola Middle A…     152477499392  2.34e7     23       0           3.25 
##  5 Austr… Australi…     990474338304  2.31e7     81       0.200      10    
##  6 Austr… Western …     373413642240  8.48e6     69       0.600      10    
##  7 Baham… Caribbean       8497731584  3.78e5     71       0          10    
##  8 Bahra… Western …      56583507968  1.35e6     48      95           0.833
##  9 Bangl… Southern…     446835425280  1.57e8     27      85.9         6.42 
## 10 Barba… Caribbean       4333428224  2.83e5     75       0.200      10    
## # … with 129 more rows
```



### Renombrar columnas

La notación para el GDP es un poco confusa. ¿Y si queremos cambiar el nombre de la variable? Aprovechemos también de cambiar el nombre de la variable de identificación por país.


```r
rename(qog, wdi_gdp = wdi_gdppppcon2011, country_name = cname)
## # A tibble: 139 x 7
##    country_name   wdi_gdp wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region    
##    <chr>            <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>     
##  1 Afghanistan    5.76e10  3.07e7      8      99.3         2.02  Southern …
##  2 Albania        2.87e10  2.90e6     31      20.5         8.08  Southern …
##  3 Algeria        5.08e11  3.82e7     36      99.1         4.25  Northern …
##  4 Angola         1.52e11  2.34e7     23       0           3.25  Middle Af…
##  5 Australia      9.90e11  2.31e7     81       0.200      10     Australia…
##  6 Austria        3.73e11  8.48e6     69       0.600      10     Western E…
##  7 Bahamas        8.50e 9  3.78e5     71       0          10     Caribbean 
##  8 Bahrain        5.66e10  1.35e6     48      95           0.833 Western A…
##  9 Bangladesh     4.47e11  1.57e8     27      85.9         6.42  Southern …
## 10 Barbados       4.33e 9  2.83e5     75       0.200      10     Caribbean 
## # … with 129 more rows
```



### Filtrar observaciones

Es muy común el querer filtrar nuestras observaciones de acuerdo a algún tipo de criterio lógico. Para esto R cuenta con operadores lógicos. Los más comunes son los siguientes:

| operador | descripción
|:--------:|------------
| ==       | es igual a
| !=       | es distinto a
| >        | es mayor a
| <        | es menor a
| >=       | es mayor o igual a
| <=       | es menor o igual a
| &        | y (intersección)
| |        | o (unión)

Por ejemplo, podríamos querer solo los países (observaciones) sudamericanos. Hacer esto con `filter()` es simple, con la ayuda de operadores lógicos:


```r
filter(qog, region == "South America")
## # A tibble: 11 x 7
##    cname   wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region  
##    <chr>              <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr>   
##  1 Bolivia      63344840704  1.04e7     34       0            7.58 South A…
##  2 Brazil     3109301780480  2.04e8     42       0.100        8.67 South A…
##  3 Chile       383162515456  1.76e7     71       0           10    South A…
##  4 Colomb…     582488686592  4.73e7     36       0.200        7.17 South A…
##  5 Ecuador     166412222464  1.57e7     35       0            7.08 South A…
##  6 Guyana        5066298368  7.61e5     27       9            7.75 South A…
##  7 Paragu…      53195030528  6.47e6     24       0            8.08 South A…
##  8 Peru        346126876672  3.06e7     38       0            8.5  South A…
##  9 Surina…       8388805120  5.33e5     36      13            7.92 South A…
## 10 Uruguay      65827684352  3.41e6     73       0           10    South A…
## 11 Venezu…     535572054016  3.03e7     20       0            5.17 South A…
```

¿Qué pasa si queremos solo las filas de países sudamericanos con más de 10 millones de habitantes (nos quedamos con 8 de 12)?



¿Cuáles son los filtros que aplican los siguientes comandos?


```r
filter(qog, fh_ipolity2 > 9)

filter(qog, wdi_pop > 10e7)

filter(qog, cname != "Albania")

filter(qog, lp_muslim80 >= 95)

filter(qog, region == "South America" & wdi_pop > 10e6)

filter(qog, region == "South America" | region == "South-Eastern Asia")
```



### Crear nuevas variables

Muchas veces queremos crear nuevas variables, a partir de las que ya tenemos. Por ejemplo, podríamos querer el GDP per capita, en vez del absoluto. Tenemos los ingredientes para calcularlo: el GDP absoluto y la población. Creemos una nueva variable, entonces:


```r
mutate(qog, gdp_ppp_per_capita = wdi_gdppppcon2011/wdi_pop)
## # A tibble: 139 x 8
##    cname wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region
##    <chr>            <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr> 
##  1 Afgh…      57566228480  3.07e7      8      99.3         2.02  South…
##  2 Alba…      28715335680  2.90e6     31      20.5         8.08  South…
##  3 Alge…     507901640704  3.82e7     36      99.1         4.25  North…
##  4 Ango…     152477499392  2.34e7     23       0           3.25  Middl…
##  5 Aust…     990474338304  2.31e7     81       0.200      10     Austr…
##  6 Aust…     373413642240  8.48e6     69       0.600      10     Weste…
##  7 Baha…       8497731584  3.78e5     71       0          10     Carib…
##  8 Bahr…      56583507968  1.35e6     48      95           0.833 Weste…
##  9 Bang…     446835425280  1.57e8     27      85.9         6.42  South…
## 10 Barb…       4333428224  2.83e5     75       0.200      10     Carib…
## # … with 129 more rows, and 1 more variable: gdp_ppp_per_capita <dbl>
```

Otra nueva variable que podría interesarnos es el número de musulmanes por país. Con la proporción de musulmanes y la población total del país podemos hacer una buena estimación:


```r
mutate(qog, n_muslim = wdi_pop * lp_muslim80)
## # A tibble: 139 x 8
##    cname wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region
##    <chr>            <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr> 
##  1 Afgh…      57566228480  3.07e7      8      99.3         2.02  South…
##  2 Alba…      28715335680  2.90e6     31      20.5         8.08  South…
##  3 Alge…     507901640704  3.82e7     36      99.1         4.25  North…
##  4 Ango…     152477499392  2.34e7     23       0           3.25  Middl…
##  5 Aust…     990474338304  2.31e7     81       0.200      10     Austr…
##  6 Aust…     373413642240  8.48e6     69       0.600      10     Weste…
##  7 Baha…       8497731584  3.78e5     71       0          10     Carib…
##  8 Bahr…      56583507968  1.35e6     48      95           0.833 Weste…
##  9 Bang…     446835425280  1.57e8     27      85.9         6.42  South…
## 10 Barb…       4333428224  2.83e5     75       0.200      10     Carib…
## # … with 129 more rows, and 1 more variable: n_muslim <dbl>
```

¡Es posible crear más de una variable con el mismo comando! Creemos las dos de antes, a la vez:


```r
mutate(qog, 
       gdp_ppp_per_capita = wdi_gdppppcon2011/wdi_pop,
       n_muslim           = wdi_pop * lp_muslim80)
## # A tibble: 139 x 9
##    cname wdi_gdppppcon20… wdi_pop ti_cpi lp_muslim80 fh_ipolity2 region
##    <chr>            <dbl>   <dbl>  <dbl>       <dbl>       <dbl> <chr> 
##  1 Afgh…      57566228480  3.07e7      8      99.3         2.02  South…
##  2 Alba…      28715335680  2.90e6     31      20.5         8.08  South…
##  3 Alge…     507901640704  3.82e7     36      99.1         4.25  North…
##  4 Ango…     152477499392  2.34e7     23       0           3.25  Middl…
##  5 Aust…     990474338304  2.31e7     81       0.200      10     Austr…
##  6 Aust…     373413642240  8.48e6     69       0.600      10     Weste…
##  7 Baha…       8497731584  3.78e5     71       0          10     Carib…
##  8 Bahr…      56583507968  1.35e6     48      95           0.833 Weste…
##  9 Bang…     446835425280  1.57e8     27      85.9         6.42  South…
## 10 Barb…       4333428224  2.83e5     75       0.200      10     Carib…
## # … with 129 more rows, and 2 more variables: gdp_ppp_per_capita <dbl>,
## #   n_muslim <dbl>
```



### Concatenar comandos

A menudo no queremos hacer una sola de las operaciones con bases de datos reseñadas antes, sino que una seguidilla de estas. Si quisiéramos crear una nueva base a través de, por ejemplo, (1) seleccionar las variables de país, población y GDP, (2) crear la variable de GDP per capita, y (3) ordenar los países de mayor a menor según GDP per capita, nuestro procedimiento en R sería algo como esto:


```r
qog_seguidilla_1 <- select(qog, cname, wdi_pop, wdi_gdppppcon2011)
qog_seguidilla_2 <- mutate(qog_seguidilla_1, 
                               gdp_ppp_per_capita = wdi_gdppppcon2011/wdi_pop)
qog_seguidilla_3 <- arrange(qog_seguidilla_2, -gdp_ppp_per_capita)
```


```r
qog_seguidilla_3
## # A tibble: 139 x 4
##    cname                  wdi_pop wdi_gdppppcon2011 gdp_ppp_per_capita
##    <chr>                    <dbl>             <dbl>              <dbl>
##  1 Qatar                  2101288      280302059520            133395.
##  2 Luxembourg              543360       48842280960             89889.
##  3 Singapore              5399200      419630612480             77721.
##  4 Kuwait                 3593689      266584637440             74181.
##  5 Norway                 5079623      321651408896             63322.
##  6 United Arab Emirates   9039978      560986259456             62056.
##  7 Switzerland            8089346      444201566208             54912.
##  8 United States        316497536    16230494765056             51282.
##  9 Saudi Arabia          30201052     1478747750400             48963.
## 10 Ireland                4598294      212357021696             46182.
## # … with 129 more rows
```

El lector notará que esto es bastante complicado y nos deja con dos **objetos intermedios** que no nos interesan, "qog_seguidilla_1" y "qog_seguidilla_2".



La solución del paquete tidyverse que estamos utilizando son **las pipes**. El lector notará que en las tres funciones de nuestra seguidilla anterior (select, mutate y arrange) el primer argumento es la base de datos a tratar. En vez de crear objetos intermedios podemos "chutear" la base de datos a través de nuestros comandos con pipes, omitiendo los primeros argumentos:


```r
qog_seguidilla <- qog %>%
  select(cname, wdi_pop, wdi_gdppppcon2011) %>%
  mutate(gdp_ppp_per_capita = wdi_gdppppcon2011/wdi_pop) %>%
  arrange(-gdp_ppp_per_capita)
```


```r
qog_seguidilla
## # A tibble: 139 x 4
##    cname                  wdi_pop wdi_gdppppcon2011 gdp_ppp_per_capita
##    <chr>                    <dbl>             <dbl>              <dbl>
##  1 Qatar                  2101288      280302059520            133395.
##  2 Luxembourg              543360       48842280960             89889.
##  3 Singapore              5399200      419630612480             77721.
##  4 Kuwait                 3593689      266584637440             74181.
##  5 Norway                 5079623      321651408896             63322.
##  6 United Arab Emirates   9039978      560986259456             62056.
##  7 Switzerland            8089346      444201566208             54912.
##  8 United States        316497536    16230494765056             51282.
##  9 Saudi Arabia          30201052     1478747750400             48963.
## 10 Ireland                4598294      212357021696             46182.
## # … with 129 more rows
```

Las pipes pueden leerse como "pero luego". Nuestra seguidilla anterior, entonces, se leería de la siguiente forma:

> qog_seguilla es igual a qog; pero luego seleccionamos las variables cname, wdi_pop, wdi_gdppppcon2011; pero luego creamos la variable gdp_ppp_per_capita; pero luego ordenamos la base en forma decreciente según gdp_ppp_per_capita.

### Operaciones agrupadas

**PENDIENTE**

## Reformatear bases

**PENDIENTE**

<div class="books">
<p><strong>Ejercicios antes de continuar al próximo capítulo</strong> - Cree una base nueva, llamada <code>qog_2</code>, con una nueva variable llamada <code>porc_muslim</code>, que sea el porcentaje de población musulmana del país.</p>
<ul>
<li><p>Cree una base nueva, llamada <code>qog_3</code>, que incluya solo países latinoamericanos, China y Sudáfrica.</p></li>
<li><p>Cree una base nueva, llamada <code>qog_4</code>, que incluya solo países con población mayor a la media de población entre todos los países. Debe contener solo las variables de nombre del país, región y población (en ese orden). Ordene la base según población, de mayor a menor. ¡Use pipes!</p></li>
</ul>
</div>