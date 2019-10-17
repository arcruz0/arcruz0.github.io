
# Manejo de datos {#manejo-de-datos}

*Por Andrés Cruz*




## Introducción

La bases de datos tabulares son la forma por excelencia de guardar información en ciencias sociales. Su poder radica en que podemos registrar múltiples dimensiones de información para cada observación que nos interese. Por ejemplo, para cada diputado de un Congreso podemos saber su género, edad, porcentaje de asistencia a sala, número de proyectos de ley que ha presentado, etcétera:

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> diputado </th>
   <th style="text-align:left;"> genero </th>
   <th style="text-align:right;"> edad </th>
   <th style="text-align:right;"> asistencia </th>
   <th style="text-align:right;"> num_proyectos_presentados </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Ana C. </td>
   <td style="text-align:left;"> F </td>
   <td style="text-align:right;"> 48 </td>
   <td style="text-align:right;"> 68 </td>
   <td style="text-align:right;"> 8 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> José T. </td>
   <td style="text-align:left;"> M </td>
   <td style="text-align:right;"> 37 </td>
   <td style="text-align:right;"> 74 </td>
   <td style="text-align:right;"> 3 </td>
  </tr>
</tbody>
</table>

Seguramente ya tendrás algún grado de familiaridad con este tipo de bases, gracias a Microsoft Excel o alguna de sus alternativas. La primera fila es el **encabezado**, que indica qué datos registran las celdas de esa columna. La primera columna en este caso es nuestra **columna identificadora**: consultando "diputado" podemos saber a qué observación refiere cada fila. Así, sobre esta pequeña base de datos podemos decir que la **unidad observacional** es el diputado, sobre la que tenemos información en cuatro variables: género, edad, asistencia a las sesiones y núnmero de proyectos presentados.

En el presente capítulo veremos cómo modificar bases de datos tabulares como la del ejemplo. Aprenderás a ordenar las bases, filtrar sus observaciones, crear nuevas variables, generar resúmenes, cambiar nombres, recodificar valores y modificar la estructura de las bases. Todas estas operaciones son un paso inicial para cualquier análisis o visualización: a menudo se estima que el 80% del análisis de datos se invierte en modificar y limpiar nuestros datos para llevarlos a la forma óptima para el análisis (Dasu & Johnson, 2003 en [Wickham, 2014](https://www.jstatsoft.org/index.php/jss/article/view/v059i10/v59i10.pdf)).

### Nuestra base de datos

Para este capítulo usaremos datos de [Reyes-Housholder (2019)](https://reyes-housholder.weebly.com/uploads/8/1/0/9/81091026/10._prq_manuscript_feb_2019.pdf), con algunas adiciones de los World Development Indicators del Banco Mundial, recopiladas por [Quality of Government (2018)](https://qog.pol.gu.se/data). La autora argumenta que, ante escándalos de corrupción similares, las presidentas latinoamericanas sufren caídas mucho más importantes en aprobación que sus pares masculinos.

Para comenzar a trabajar carguemos el paquete `tidyverse`, uno de los centrales del libro, que nos dará funciones útiles para trabajar con nuestra base datos.


```r
library(tidyverse)
```

Ahora carguemos la base a nuestra sesión de R. Podemos hacer esto con con facilidad desde el paquete del libro, por medio de la función `data()`. La base se llama "aprob_presidencial":


```r
# library(paqueteadp)
# data(aprob_presidencial)
```


```r
aprob_presidencial <- read_csv("00-datos/aprob_presidencial_esp.csv")
## Parsed with column specification:
## cols(
##   pais = col_character(),
##   anio = col_double(),
##   trimestre = col_double(),
##   presidente = col_character(),
##   pres_sexo = col_character(),
##   aprob_neta = col_double(),
##   corr_ejec = col_double(),
##   pib = col_double(),
##   poblacion = col_double(),
##   desempleo = col_double(),
##   crec_pib = col_double()
## )
```

Con esto podemos comenzar a trabajar con los datos. Puedes chequear que la base se cargó correctamente utilizando el comando `ls()` (o viendo la pestaña de Environment en RStudio):


```r
ls()
## [1] "aprob_presidencial"
```

Las siguientes son las variables de la base:

Variable   | Descripción
---------- | -------------------------------------------------------------------
pais       | País.
anio       | Año.
trimestre  | Trimestre.
presidente | Presidente/a.
pres_sexoo  | Sexo del presidente/a.
aprob_neta | Aprobación neta del presidente/a (% aprobación - % rechazo).
pib        | Producto interno bruto del país, ajustado por paridad de cambio (PPP) y constante en dólares del 2011, según los World Development Indicators del Banco Mundial.
poblacion  | Población según los World Development Indicators del Banco Mundial.
corr_ejec  | Corrupción en el Ejecutivo, según V-Dem. De 0 a 100 (mayor es más corrupción).
desempleo  | Porcentaje de desempleo.
crec_pib   | Crecimiento del PIB.


### Describir la base

Para aproximarnos a nuestra base recién cargada tenemos varias opciones. Podemos, como antes, simplemente usar su nombre como un comando para un resumen rápido:


```r
aprob_presidencial
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

También podemos utilizar la función `glimpse()` para tener un resumen desde otra perspectiva, viendo rápidamente las primeras observaciones en cada variable:


```r
glimpse(aprob_presidencial)
## Observations: 1,020
## Variables: 11
## $ pais       <chr> "Argentina", "Argentina", "Argentina", "Argentina", "…
## $ anio       <dbl> 2000, 2000, 2000, 2000, 2001, 2001, 2001, 2001, 2002,…
## $ trimestre  <dbl> 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2,…
## $ presidente <chr> "Fernando de la Rúa", "Fernando de la Rúa", "Fernando…
## $ pres_sexo  <chr> "Masculino", "Masculino", "Masculino", "Masculino", "…
## $ aprob_neta <dbl> 40.1, 16.4, 24.0, -18.3, -7.0, -20.1, -19.4, -23.2, -…
## $ corr_ejec  <dbl> 14, 14, 14, 14, 14, 14, 14, 14, 25, 25, 25, 25, 50, 5…
## $ pib        <dbl> 5.5e+11, 5.5e+11, 5.5e+11, 5.5e+11, 5.3e+11, 5.3e+11,…
## $ poblacion  <dbl> 3.7e+07, 3.7e+07, 3.7e+07, 3.7e+07, 3.7e+07, 3.7e+07,…
## $ desempleo  <dbl> 15, 15, 15, 15, 18, 18, 18, 18, 18, 18, 18, 18, 20, 1…
## $ crec_pib   <dbl> -0.8, -0.8, -0.8, -0.8, -4.4, -4.4, -4.4, -4.4, -10.9…
```

Una alternativa que nos permite ver la base completa es la función `View()`, análoga a clickear nuestro objeto en la pestaña "Environment" de Rstudio:


```r
View(aprob_presidencial)
```

Podemos obtener un resumen rápido de las variables de nuestra base usando la función `skim()` del paquete `skimr`:


```r
# install.packages("skimr")
library(skimr)
```


```r
skim(aprob_presidencial)
```


```
## Skim summary statistics
##  n obs: 1020 
##  n variables: 11 
## 
## ── Variable type:character ──────────────────────────
##    variable missing complete    n min max empty n_unique
##        pais       0     1020 1020   4  11     0       17
##   pres_sexo       0     1020 1020   8   9     0        2
##  presidente       0     1020 1020  11  38     0       70
## 
## ── Variable type:numeric ────────────────────────────
##    variable missing complete    n       mean       sd          p0        p25        p50      p75        p100     hist
##        anio       0     1020 1020 2007        4.32     2000          2003    2007        2011     2014       ▇▇▇▇▃▇▇▇
##  aprob_neta       0     1020 1020   15.28    27.82      -65.79         -6.57   16          37.59    86.92    ▁▂▆▇▇▇▃▁
##   corr_ejec       0     1020 1020   43.35    26.9         2.13         19.57   39.98       66.62    94.42    ▇▂▅▆▃▃▅▃
##    crec_pib       0     1020 1020    3.77     3.54      -10.9           2.31    4.06        5.63    18.29    ▁▁▁▆▇▂▁▁
##   desempleo       0     1020 1020    7.04     3.61        1.3           4.38    6.41        8.9     20.52    ▅▇▇▃▂▁▁▁
##         pib       0     1020 1020    4.1e+11  6.9e+11     1.7e+10   4e+10       9.2e+10 4e+11        3.1e+12 ▇▁▁▁▁▁▁▁
##   poblacion       0     1020 1020    3.1e+07  4.8e+07 3e+06       5867626       1.3e+07 3e+07    2e+08       ▇▂▁▁▁▁▁▁
##   trimestre       0     1020 1020    2.5      1.12        1             1.75    2.5         3.25     4       ▇▁▇▁▁▇▁▇
```


Obtener la tabulación de una de las columnas de nuestra base, una operación común para variables categóricas, es sencillo gracias a la función `count()`. Por ejemplo, podemos comprobar que los países-años-trimestres con mujeres como presidentas son una minoría en la región:


```r
count(aprob_presidencial, pres_sexo, 
      sort = T) # ordenar de mayor a menor según n
## # A tibble: 2 x 2
##   pres_sexo     n
##   <chr>     <int>
## 1 Masculino   922
## 2 Femenino     98
```


## Operaciones básicas

A continuación veremos algunas operaciones básicas para nuestra base de datos, que en su conjunto nos permitirán editar dramáticamente su estructura y contenidos [(Wickham & Grolemund, 2017)](https://r4ds.had.co.nz/transform.html). Esta subsección utiliza las herramientas del paquete `dplyr` (Wickham et al., 2019), que esta disponible al cargar el `tidyvese`, lo que ya hicimos.

### Seleccionar columnas

A veces queremos trabajar con solo un extracto de las variables de una base. Para esto existe la función `select()`. Seleccionemos solo la columna de países:


```r
select(aprob_presidencial, pais)
## # A tibble: 1,020 x 1
##    pais     
##    <chr>    
##  1 Argentina
##  2 Argentina
##  3 Argentina
##  4 Argentina
##  5 Argentina
##  6 Argentina
##  7 Argentina
##  8 Argentina
##  9 Argentina
## 10 Argentina
## # … with 1,010 more rows
```

El primer argumento de la función anterior ("aprob_presidencial") es la base en la que queremos realizar la operación. El siguiente argumento, en tanto, indica qué columnas seleccionar ("pais"). Todas las funciones de operaciones básicas que veremos en esta subsección siguen esta lógica: el primer argumento es siempre la base en la que operaremos, mientras que los demás designan cómo queremos realizar la operación.

Recuerda que el código anterior no creó ningún objeto nuevo, es solo un comando que estamos ejecutando en la consola. Si quisiéramos crear un objeto nuevo, tendríamos que asignarlo:


```r
aprob_presidencial_reducida <- select(aprob_presidencial, pais)
aprob_presidencial_reducida
## # A tibble: 1,020 x 1
##    pais     
##    <chr>    
##  1 Argentina
##  2 Argentina
##  3 Argentina
##  4 Argentina
##  5 Argentina
##  6 Argentina
##  7 Argentina
##  8 Argentina
##  9 Argentina
## 10 Argentina
## # … with 1,010 more rows
```

Podemos seleccionar múltiples columnas a la vez, separadas por comas:


```r
select(aprob_presidencial, pais, anio, desempleo)
## # A tibble: 1,020 x 3
##    pais       anio desempleo
##    <chr>     <dbl>     <dbl>
##  1 Argentina  2000      15  
##  2 Argentina  2000      15  
##  3 Argentina  2000      15  
##  4 Argentina  2000      15  
##  5 Argentina  2001      18.3
##  6 Argentina  2001      18.3
##  7 Argentina  2001      18.3
##  8 Argentina  2001      18.3
##  9 Argentina  2002      17.9
## 10 Argentina  2002      17.9
## # … with 1,010 more rows
```

Supongamos que queremos las primeras cinco variables de la base de datos. Las siguientes tres formas obtienen el mismo resultado, aunque la segunda es la que recomendamos, pues es sucinta pero explícita:


```r
select(aprob_presidencial, pais, anio, trimestre, presidente, aprob_neta)
select(aprob_presidencial, pais:aprob_neta) # forma recomendada
select(aprob_presidencial, 1:5)
```


```
## # A tibble: 1,020 x 6
##    pais       anio trimestre presidente              pres_sexo aprob_neta
##    <chr>     <dbl>     <dbl> <chr>                   <chr>          <dbl>
##  1 Argentina  2000         1 Fernando de la Rúa      Masculino      40.1 
##  2 Argentina  2000         2 Fernando de la Rúa      Masculino      16.4 
##  3 Argentina  2000         3 Fernando de la Rúa      Masculino      24.0 
##  4 Argentina  2000         4 Fernando de la Rúa      Masculino     -18.3 
##  5 Argentina  2001         1 Fernando de la Rúa      Masculino      -6.97
##  6 Argentina  2001         2 Fernando de la Rúa      Masculino     -20.1 
##  7 Argentina  2001         3 Fernando de la Rúa      Masculino     -19.4 
##  8 Argentina  2001         4 Fernando de la Rúa      Masculino     -23.2 
##  9 Argentina  2002         1 Eduardo Alberto Duhalde Masculino      -2.01
## 10 Argentina  2002         2 Eduardo Alberto Duhalde Masculino     -20.1 
## # … with 1,010 more rows
```

El comando `select()` también nos sirve para reordenar las columnas. Supongamos que queremos que la variable `presidente` sea la primera. Podemos hacer algo como esto, obteniendo la misma base pero con un nuevo orden de columnas:


```r
select(aprob_presidencial, presidente, pais:anio, aprob_neta:desempleo)
## # A tibble: 1,020 x 8
##    presidente     pais    anio aprob_neta corr_ejec      pib poblacion desempleo
##    <chr>          <chr>  <dbl>      <dbl>     <dbl>    <dbl>     <dbl>     <dbl>
##  1 Fernando de l… Argen…  2000      40.1       14.0  5.52e11  37057452      15  
##  2 Fernando de l… Argen…  2000      16.4       14.0  5.52e11  37057452      15  
##  3 Fernando de l… Argen…  2000      24.0       14.0  5.52e11  37057452      15  
##  4 Fernando de l… Argen…  2000     -18.3       14.0  5.52e11  37057452      15  
##  5 Fernando de l… Argen…  2001      -6.97      14.0  5.28e11  37471509      18.3
##  6 Fernando de l… Argen…  2001     -20.1       14.0  5.28e11  37471509      18.3
##  7 Fernando de l… Argen…  2001     -19.4       14.0  5.28e11  37471509      18.3
##  8 Fernando de l… Argen…  2001     -23.2       14.0  5.28e11  37471509      18.3
##  9 Eduardo Alber… Argen…  2002      -2.01      25.0  4.70e11  37889370      17.9
## 10 Eduardo Alber… Argen…  2002     -20.1       25.0  4.70e11  37889370      17.9
## # … with 1,010 more rows
```

Esta forma es tediosa, en especial para bases con múltiples variables. Hay una función de ayuda que nos será útil en este caso, llamada `everything()`. En este caso seleccionará la columna "president" y *todo lo demás*:


```r
select(aprob_presidencial, presidente, everything()) 
## # A tibble: 1,020 x 11
##    presidente pais   anio trimestre pres_sexo aprob_neta corr_ejec     pib
##    <chr>      <chr> <dbl>     <dbl> <chr>          <dbl>     <dbl>   <dbl>
##  1 Fernando … Arge…  2000         1 Masculino      40.1       14.0 5.52e11
##  2 Fernando … Arge…  2000         2 Masculino      16.4       14.0 5.52e11
##  3 Fernando … Arge…  2000         3 Masculino      24.0       14.0 5.52e11
##  4 Fernando … Arge…  2000         4 Masculino     -18.3       14.0 5.52e11
##  5 Fernando … Arge…  2001         1 Masculino      -6.97      14.0 5.28e11
##  6 Fernando … Arge…  2001         2 Masculino     -20.1       14.0 5.28e11
##  7 Fernando … Arge…  2001         3 Masculino     -19.4       14.0 5.28e11
##  8 Fernando … Arge…  2001         4 Masculino     -23.2       14.0 5.28e11
##  9 Eduardo A… Arge…  2002         1 Masculino      -2.01      25.0 4.70e11
## 10 Eduardo A… Arge…  2002         2 Masculino     -20.1       25.0 4.70e11
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

Otra función de ayuda para select es `starts_with()`, que nos permite seleccionar columnas según patrones en sus nombres. Por ejemplo, lo siguiente seleccionará todas las columnas que comiencen con el prefijo "wdi_", que indica como fuente los World Development Indicators del Banco Mundial.


```r
select(aprob_presidencial, starts_with("wdi_"))
## # A tibble: 1,020 x 0
```


### Renombrar columnas

Podemos cambiar el nombre columnas en la base con el comando `rename()`. Por ejemplo, hagamos el nombre de la variable de PIB más explícito:


```r
rename(aprob_presidencial, pib_ppp_c2011 = pib)
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec pib_ppp_c2011
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>         <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 552151219031.
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 552151219031.
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 552151219031.
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 552151219031.
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 527807756979.
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 527807756979.
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 527807756979.
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 527807756979.
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 470305820970.
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 470305820970.
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

También podemos hacer varios cambios de nombre a la vez. Nota cómo modificamos tres nombres en un solo comando:


```r
rename(aprob_presidencial, 
       pib_ppp_c2011 = pib, 
       porc_desempleo = desempleo, 
       porc_crecimiento_pib = crec_pib)
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec pib_ppp_c2011
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>         <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 552151219031.
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 552151219031.
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 552151219031.
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 552151219031.
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 527807756979.
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 527807756979.
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 527807756979.
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 527807756979.
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 470305820970.
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 470305820970.
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   porc_desempleo <dbl>, porc_crecimiento_pib <dbl>
```


### Filtrar observaciones

A menudo queremos quedarnos solo con algunas observaciones de nuestra base de datos, filtrando de acuerdo a características específicas. Podemos hacer esto gracias a la función `filter()` y operadores lógicos. Para comenzar, quedémonos solo con las observaciones de Chile:


```r
filter(aprob_presidencial, pais == "Chile")
## # A tibble: 60 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Chile  2000         1 Eduardo F… Masculino       6.22      3.63 2.18e11
##  2 Chile  2000         2 Ricardo L… Masculino      19.8       3.63 2.18e11
##  3 Chile  2000         3 Ricardo L… Masculino      19.5       3.63 2.18e11
##  4 Chile  2000         4 Ricardo L… Masculino      14.8       3.63 2.18e11
##  5 Chile  2001         1 Ricardo L… Masculino       7.99      3.63 2.26e11
##  6 Chile  2001         2 Ricardo L… Masculino       1.81      3.63 2.26e11
##  7 Chile  2001         3 Ricardo L… Masculino      -1.40      3.63 2.26e11
##  8 Chile  2001         4 Ricardo L… Masculino       6.90      3.63 2.26e11
##  9 Chile  2002         1 Ricardo L… Masculino       6.60      3.63 2.33e11
## 10 Chile  2002         2 Ricardo L… Masculino       3.65      3.63 2.33e11
## # … with 50 more rows, and 3 more variables: poblacion <dbl>, desempleo <dbl>,
## #   crec_pib <dbl>
```

Le estamos diciendo a `filter()`, por medio del segundo argumento, que solo conserve observaciones en las que la variable pais *es igual a * Chile. Este "es igual a" es un operador lógico, que se escribe como "==" en R. Aquí hay una lista de operadores lógicos comunes:

| operador   | descripción
|:---------: |------------
| `==`       | es igual a
| `!=`       | es distinto a
| `>`        | es mayor a
| `<`        | es menor a
| `>=`       | es mayor o igual a
| `<=`       | es menor o igual a
| `&`        | intersección
| `|`        | unión
| `%in%`     | está contenido en

Por ejemplo, podemos obtener todas las observaciones (país-año-trimestre) en las que la aprobación presidencial neta es positiva:


```r
filter(aprob_presidencial, aprob_neta > 0)
## # A tibble: 709 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino       40.1      14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino       16.4      14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino       24.0      14.0 5.52e11
##  4 Arge…  2003         2 Eduardo A… Masculino       26.5      50.1 5.12e11
##  5 Arge…  2003         3 Néstor Ca… Masculino       53.7      50.1 5.12e11
##  6 Arge…  2003         4 Néstor Ca… Masculino       53.0      50.1 5.12e11
##  7 Arge…  2004         1 Néstor Ca… Masculino       57.1      50.1 5.58e11
##  8 Arge…  2004         2 Néstor Ca… Masculino       52.8      50.1 5.58e11
##  9 Arge…  2004         3 Néstor Ca… Masculino       39.1      50.1 5.58e11
## 10 Arge…  2004         4 Néstor Ca… Masculino       44.9      50.1 5.58e11
## # … with 699 more rows, and 3 more variables: poblacion <dbl>, desempleo <dbl>,
## #   crec_pib <dbl>
```

Podemos también realizar filtros más complejos. Obtengamos solo las observaciones del Cono Sur:


```r
filter(aprob_presidencial, pais == "Argentina" | pais == "Chile" | pais == "Uruguay")
## # A tibble: 180 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 170 more rows, and 3 more variables: poblacion <dbl>, desempleo <dbl>,
## #   crec_pib <dbl>
# Lo mismo, con otro operador lógico:
filter(aprob_presidencial, pais %in% c("Argentina", "Chile", "Uruguay")) 
## # A tibble: 180 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 170 more rows, and 3 more variables: poblacion <dbl>, desempleo <dbl>,
## #   crec_pib <dbl>
```

Podemos también incluir pequeñas operaciones en nuestros filtros. Obtengamos todas las observaciones en las que la corrupción ejecutiva es mayor a la del promedio de toda la base:


```r
filter(aprob_presidencial, corr_ejec > mean(corr_ejec))
## # A tibble: 456 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2003         1 Eduardo A… Masculino      -2.78      50.1 5.12e11
##  2 Arge…  2003         2 Eduardo A… Masculino      26.5       50.1 5.12e11
##  3 Arge…  2003         3 Néstor Ca… Masculino      53.7       50.1 5.12e11
##  4 Arge…  2003         4 Néstor Ca… Masculino      53.0       50.1 5.12e11
##  5 Arge…  2004         1 Néstor Ca… Masculino      57.1       50.1 5.58e11
##  6 Arge…  2004         2 Néstor Ca… Masculino      52.8       50.1 5.58e11
##  7 Arge…  2004         3 Néstor Ca… Masculino      39.1       50.1 5.58e11
##  8 Arge…  2004         4 Néstor Ca… Masculino      44.9       50.1 5.58e11
##  9 Arge…  2005         1 Néstor Ca… Masculino      45.7       50.1 6.07e11
## 10 Arge…  2005         2 Néstor Ca… Masculino      45.4       50.1 6.07e11
## # … with 446 more rows, and 3 more variables: poblacion <dbl>, desempleo <dbl>,
## #   crec_pib <dbl>
```

### (Ejercicio A)

- Selecciona solo las dos columnas que registran el sexo del presidente/a en la base de datos.

- Filtra la base de datos para que solo tenga las observaciones del año 2000.

- Filtra la base de datos para que solo incluya observaciones de crisis económica, definida de la siguiente forma: cuando el crecimiento del PIB sea negativo y/o el desempleo sea mayor al 20%.


### Ordenar una base

Una de las operaciones más comunes con bases de datos es ordenarlas de acuerdo a alguna de las variables. Esto nos puede dar indicios inmediatos sobre nuestras observaciones. Podemos hacer esto gracias a la función `arrange()`. Por ejemplo, ordenemos las observaciones desde el país-año-trimestre menos corrupto al más corrupto:


```r
arrange(aprob_presidencial, corr_ejec)
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Urug…  2000         1 Julio San… Masculino      41.2       2.13 4.28e10
##  2 Urug…  2000         2 Jorge Bat… Masculino      45.4       2.13 4.28e10
##  3 Urug…  2000         3 Jorge Bat… Masculino      31.4       2.13 4.28e10
##  4 Urug…  2000         4 Jorge Bat… Masculino      18.1       2.13 4.28e10
##  5 Urug…  2001         1 Jorge Bat… Masculino      18.5       2.13 4.11e10
##  6 Urug…  2001         2 Jorge Bat… Masculino      17.8       2.13 4.11e10
##  7 Urug…  2001         3 Jorge Bat… Masculino      15.9       2.13 4.11e10
##  8 Urug…  2001         4 Jorge Bat… Masculino      14.5       2.13 4.11e10
##  9 Urug…  2002         1 Jorge Bat… Masculino       6.36      2.13 3.79e10
## 10 Urug…  2002         2 Jorge Bat… Masculino      -6.37      2.13 3.79e10
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

Si quisiéramos ordenarlo inversamente, tendríamos que añadir un - (signo menos) antes de la variable:


```r
arrange(aprob_presidencial, -corr_ejec)
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Vene…  2013         1 Hugo Cháv… Masculino      -12.6      94.4 5.36e11
##  2 Vene…  2013         2 Nicolás M… Masculino      -13.7      94.4 5.36e11
##  3 Vene…  2013         3 Nicolás M… Masculino      -16.8      94.4 5.36e11
##  4 Vene…  2013         4 Nicolás M… Masculino      -16.6      94.4 5.36e11
##  5 Vene…  2014         1 Nicolás M… Masculino      -18.1      94.4 5.15e11
##  6 Vene…  2014         2 Nicolás M… Masculino      -19.4      94.4 5.15e11
##  7 Vene…  2014         3 Nicolás M… Masculino      -22.1      94.4 5.15e11
##  8 Vene…  2014         4 Nicolás M… Masculino      -24.9      94.4 5.15e11
##  9 Vene…  2007         1 Hugo Cháv… Masculino      -10.2      93.5 4.78e11
## 10 Vene…  2007         2 Hugo Cháv… Masculino      -11.0      93.5 4.78e11
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

En el caso de utilizar una variable categórica, el orden se realizará en forma alfabética:


```r
arrange(aprob_presidencial, presidente)
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Cost…  2002         3 Abel Pach… Masculino      43.6       11.5 4.15e10
##  2 Cost…  2002         4 Abel Pach… Masculino      49.0       11.5 4.15e10
##  3 Cost…  2003         1 Abel Pach… Masculino      32.2       11.5 4.32e10
##  4 Cost…  2003         2 Abel Pach… Masculino      20.9       11.5 4.32e10
##  5 Cost…  2003         3 Abel Pach… Masculino       4.59      11.5 4.32e10
##  6 Cost…  2003         4 Abel Pach… Masculino       6.76      11.5 4.32e10
##  7 Cost…  2004         1 Abel Pach… Masculino      15.2       11.5 4.51e10
##  8 Cost…  2004         2 Abel Pach… Masculino      17.3       11.5 4.51e10
##  9 Cost…  2004         3 Abel Pach… Masculino      16.8       11.5 4.51e10
## 10 Cost…  2004         4 Abel Pach… Masculino      27.0       11.5 4.51e10
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

Para utilizar un orden alfabético inverso (desde la Z hasta la A), debemos utilizar la función de ayuda `desc()`.


```r
arrange(aprob_presidencial, desc(presidente))
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Méxi…  2001         1 Vicente F… Masculino       53.8      37.6 1.59e12
##  2 Méxi…  2001         2 Vicente F… Masculino       40.7      37.6 1.59e12
##  3 Méxi…  2001         3 Vicente F… Masculino       40.1      37.6 1.59e12
##  4 Méxi…  2001         4 Vicente F… Masculino       30.5      37.6 1.59e12
##  5 Méxi…  2002         1 Vicente F… Masculino       15.0      37.6 1.59e12
##  6 Méxi…  2002         2 Vicente F… Masculino       22.0      37.6 1.59e12
##  7 Méxi…  2002         3 Vicente F… Masculino       28.2      37.6 1.59e12
##  8 Méxi…  2002         4 Vicente F… Masculino       27.5      37.6 1.59e12
##  9 Méxi…  2003         1 Vicente F… Masculino       26.8      37.6 1.61e12
## 10 Méxi…  2003         2 Vicente F… Masculino       33.2      37.6 1.61e12
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

Por último, podemos ordenar por más de una variable. Esto es, ordenar a partir de una primera variable y luego ordenar los empates a partir de otra segunda variable. Veamos el siguiente ejemplo:


```r
arrange(aprob_presidencial, pres_sexo, -aprob_neta)
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Bras…  2013         1 Dilma Van… Femenino        62.5      27.3 3.12e12
##  2 Bras…  2012         4 Dilma Van… Femenino        60.9      33.4 3.03e12
##  3 Bras…  2012         2 Dilma Van… Femenino        60.5      33.4 3.03e12
##  4 Bras…  2012         3 Dilma Van… Femenino        58.7      33.4 3.03e12
##  5 Bras…  2012         1 Dilma Van… Femenino        57.2      33.4 3.03e12
##  6 Bras…  2011         4 Dilma Van… Femenino        54.3      33.4 2.97e12
##  7 Bras…  2011         1 Dilma Van… Femenino        47.7      33.4 2.97e12
##  8 Bras…  2011         3 Dilma Van… Femenino        45.6      33.4 2.97e12
##  9 Bras…  2013         2 Dilma Van… Femenino        44.4      27.3 3.12e12
## 10 Arge…  2011         4 Cristina … Femenino        44.3      52.4 8.18e11
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```

### Transformar y crear variables

Muchas veces queremos crear nuevas variables, a partir de las que ya tenemos. Supongamos que queremos transformar la escala de `poblacion` a millones:


```r
mutate(aprob_presidencial, poblacion_mill = poblacion / 1000000)
## # A tibble: 1,020 x 12
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 1,010 more rows, and 4 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>, poblacion_mill <dbl>
```

El comando anterior genera una nueva variable en la base, "poblacion_mill", que es "poblacion" pero en la escala de los millones. Podemos realizar cualquier tipo de operación en nuestras columnas, como crear una variable con el PIB en versión logarítmica:


```r
mutate(aprob_presidencial, pib_log = log(pib))
## # A tibble: 1,020 x 12
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 1,010 more rows, and 4 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>, pib_log <dbl>
```

Crucialmente, también podemos generar operaciones entre las variables. Por ejemplo, calculemos el PIB *per capita*, lo que nos permitirá comparar de mejor forma entre países con distintas poblaciones:


```r
mutate(aprob_presidencial, pib_pc = pib / poblacion)
## # A tibble: 1,020 x 12
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 1,010 more rows, and 4 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>, pib_pc <dbl>
```

Para terminar, podemos también generar más de una transfomación a la vez por medio de `mutate()`, utilizando múltiples argumentos:


```r
mutate(aprob_presidencial, 
       poblacion_mill = poblacion / 1000000,
       pib_pc   = pib / poblacion)
## # A tibble: 1,020 x 13
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 1,010 more rows, and 5 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>, poblacion_mill <dbl>, pib_pc <dbl>
```


### (Ejercicio B)

- Crea un nuevo *data frame*, que esté ordenado desde el país-año-trimeste con menor aprobación presidencial al con mayor aprobación presidencial (recuerda *crear* el nuevo objeto y darle un nombre descriptivo).
- En tu nuevo objeto, obtén solo con las observaciones que tengan presidentas.
- Crea una nueva variable, que registre el desempleo como proporción en vez de porcentaje.

## Resúmenes

Podemos hacer resúmenes para nuestra base de datos con `summarize`:


```r
summarize(aprob_presidencial, prom_desemp = mean(desempleo))
## # A tibble: 1 x 1
##   prom_desemp
##         <dbl>
## 1        7.04
```

A menudo este procedimiento se denomina **colapsar una base de datos**: estamos comprimiendo la información de las filas para generar una única fila de resumen. En este caso, la función de resumen `mean()` opera en el vector "desempleo" para obtener su media.

Como con las otras operaciones, podemos hacer varios resúmenes a la vez:


```r
summarize(aprob_presidencial, 
          prom_desemp   = mean(desempleo),
          prom_crec     = mean(crec_pib),
          prom_aprob    = mean(aprob_neta))
## # A tibble: 1 x 3
##   prom_desemp prom_crec prom_aprob
##         <dbl>     <dbl>      <dbl>
## 1        7.04      3.77       15.3
```

### Resúmenes agrupados

Lo realmente interesante es hacer resúmenes por grupos. Esto implicará colapsar las filas no hasta tener una sola, sino que hasta obtener filas que resuman la información de distintos grupos en la base de datos.

Para realizar esto, primero debemos tener una versión "agrupada" de la base de datos. Esta es igual que nuestra base original, pero R sabe que las siguientes operaciones que realicemos en ella deberán ser agrupadas.


```r
aprob_presidencial_por_pais <- group_by(aprob_presidencial, pais)
```

Hagamos una operación de resumen en esta nueva base:


```r
summarize(aprob_presidencial_por_pais, 
          prom_desemp   = mean(desempleo),
          prom_crec_pib = mean(crec_pib),
          prom_aprob    = mean(aprob_neta))
## # A tibble: 17 x 4
##    pais        prom_desemp prom_crec_pib prom_aprob
##    <chr>             <dbl>         <dbl>      <dbl>
##  1 Argentina         11.0           2.72      16.7 
##  2 Bolivia            3.70          4.24      11.3 
##  3 Brasil             8.35          3.4       34.2 
##  4 Chile              8.18          4.33       5.71
##  5 Colombia          12.5           4.35      27.1 
##  6 Costa Rica         6.73          4.15      14.5 
##  7 Ecuador            6.76          4.31      37.1 
##  8 El Salvador        5.75          1.87      39.1 
##  9 Guatemala          2.80          3.47       5.44
## 10 Honduras           4.22          4.08      12.7 
## 11 México             3.99          2.10      28.9 
## 12 Nicaragua          6.78          3.73      16.2 
## 13 Panamá             8.45          6.31      14.2 
## 14 Paraguay           5.69          3.66      10.9 
## 15 Perú               4.32          5.30     -26.2 
## 16 Uruguay           10.3           3.08      26.9 
## 17 Venezuela         10.3           3.04     -14.8
```

Los grupos pueden también ser de combinaciones de variables. Por ejemplo, nuestra base a nivel país-año-trimestre puede ser agrupada en países-años, para luego obtener los mismos cálculos anteriores:


```r
aprob_presidencial_por_pais_anio <- group_by(aprob_presidencial, pais, anio)

summarize(aprob_presidencial_por_pais_anio, 
          prom_desemp   = mean(desempleo),
          prom_crec_pib = mean(crec_pib),
          prom_aprob    = mean(aprob_neta))
## # A tibble: 255 x 5
## # Groups:   pais [17]
##    pais       anio prom_desemp prom_crec_pib prom_aprob
##    <chr>     <dbl>       <dbl>         <dbl>      <dbl>
##  1 Argentina  2000       15             -0.8      15.6 
##  2 Argentina  2001       18.3           -4.4     -17.4 
##  3 Argentina  2002       17.9          -10.9     -16.0 
##  4 Argentina  2003       17.0            8.8      32.6 
##  5 Argentina  2004       13.5            9        48.5 
##  6 Argentina  2005       11.5            8.9      43.8 
##  7 Argentina  2006       10.1            8        45.9 
##  8 Argentina  2007        8.39           9        34.3 
##  9 Argentina  2008        7.84           4.1       9.52
## 10 Argentina  2009        8.65          -5.9      -9.99
## # … with 245 more rows
```

Por cierto, podemos desagrupar una base con `ungroup()`. Esto es una buena idea si es que ya no queremos correr operaciones agrupadas, ahorrándonos errores:


```r
aprob_presidencial_por_pais_anio %>% 
  ungroup() # nota cómo ya no hay "groups" en el resumen de los datos
## # A tibble: 1,020 x 11
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 1,010 more rows, and 3 more variables: poblacion <dbl>,
## #   desempleo <dbl>, crec_pib <dbl>
```


## Comandos en cadena

La mayor parte del tiempo queremos hacer **más de una operación** en una base de datos. Por ejemplo, podríamos querer (1) crear una nueva variable con PIB per capita, y luego (2) filtrar las observaciones con valores iguales o mayores a la media de PIB per capita en toda la base:


```r
aprob_presidencial_con_pib_pc <- mutate(aprob_presidencial, pib_pc = pib / poblacion)

filter(aprob_presidencial_con_pib_pc, pib_pc > mean(pib_pc))
## # A tibble: 492 x 12
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 482 more rows, and 4 more variables: poblacion <dbl>, desempleo <dbl>,
## #   crec_pib <dbl>, pib_pc <dbl>
```

Esta misma cadena de operaciones se puede escribir de la siguiente forma:


```r
aprob_presidencial %>% 
  mutate(pib_pc = pib / poblacion) %>% 
  filter(pib_pc > mean(pib_pc))
## # A tibble: 492 x 12
##    pais   anio trimestre presidente pres_sexo aprob_neta corr_ejec     pib
##    <chr> <dbl>     <dbl> <chr>      <chr>          <dbl>     <dbl>   <dbl>
##  1 Arge…  2000         1 Fernando … Masculino      40.1       14.0 5.52e11
##  2 Arge…  2000         2 Fernando … Masculino      16.4       14.0 5.52e11
##  3 Arge…  2000         3 Fernando … Masculino      24.0       14.0 5.52e11
##  4 Arge…  2000         4 Fernando … Masculino     -18.3       14.0 5.52e11
##  5 Arge…  2001         1 Fernando … Masculino      -6.97      14.0 5.28e11
##  6 Arge…  2001         2 Fernando … Masculino     -20.1       14.0 5.28e11
##  7 Arge…  2001         3 Fernando … Masculino     -19.4       14.0 5.28e11
##  8 Arge…  2001         4 Fernando … Masculino     -23.2       14.0 5.28e11
##  9 Arge…  2002         1 Eduardo A… Masculino      -2.01      25.0 4.70e11
## 10 Arge…  2002         2 Eduardo A… Masculino     -20.1       25.0 4.70e11
## # … with 482 more rows, and 4 more variables: poblacion <dbl>, desempleo <dbl>,
## #   crec_pib <dbl>, pib_pc <dbl>
```

¡Este código es sorprendemente legible! Las pipes (`%>%`) se leen como "luego" (o "pero luego") y se insertan con Ctrl/Cmd + Shift + M en RStudio^[Puedes ver todos los atajos de teclado de RStudio en Help > Keyboard Shortcuts Help]. Entonces, el siguiente bloque de código puede leerse de la siguiente forma:

> Toma la base "aprob_presidencial", *luego* genera una variable llamada pib_pc (la división entre "pib" y "poblacion"), *luego* filtra las observaciones para dejar solo aquellas en las que "pib_pc" es mayor a su valor promedio.

Uno de los usos más comunes de las pipes es el combo `group_by()` + `summarize()`. Repitamos nuestras operaciones de antes para hacer un resumen agrupado:


```r
aprob_presidencial %>% 
  group_by(pais) %>% 
  summarize(prom_desemp   = mean(desempleo),
            prom_crec     = mean(crec_pib),
            prom_aprob    = mean(aprob_neta))
## # A tibble: 17 x 4
##    pais        prom_desemp prom_crec prom_aprob
##    <chr>             <dbl>     <dbl>      <dbl>
##  1 Argentina         11.0       2.72      16.7 
##  2 Bolivia            3.70      4.24      11.3 
##  3 Brasil             8.35      3.4       34.2 
##  4 Chile              8.18      4.33       5.71
##  5 Colombia          12.5       4.35      27.1 
##  6 Costa Rica         6.73      4.15      14.5 
##  7 Ecuador            6.76      4.31      37.1 
##  8 El Salvador        5.75      1.87      39.1 
##  9 Guatemala          2.80      3.47       5.44
## 10 Honduras           4.22      4.08      12.7 
## 11 México             3.99      2.10      28.9 
## 12 Nicaragua          6.78      3.73      16.2 
## 13 Panamá             8.45      6.31      14.2 
## 14 Paraguay           5.69      3.66      10.9 
## 15 Perú               4.32      5.30     -26.2 
## 16 Uruguay           10.3       3.08      26.9 
## 17 Venezuela         10.3       3.04     -14.8
```

### (Ejercicio C)

- Calcula, ayudándote de las pipes, la mediana por país de corrupción ejecutiva y PIB. Recuerda que puedes insertar pipes con Ctrl/Cmd + Shift + M.
- De nuevo usando pipes, ordena los países en la base desde el que tuvo el mayor PIB per cápita promedio en el período 2010-2014 hasta el que tuvo el menor. 
- ¿Qué país-año-trimestre, entre los gobernados por mujeres, tuvo la corrupción ejecutiva más alta? ¿Y la aprobación neta más alta?

## Recodificar valores {#manejo-de-datos-recodificar}

Un ejercicio común en manejo de datos es generar variables (o editar las existentes) en base a ciertas condiciones lógicas. Ya construimos condiciones lógicas para `filter()` antes, por lo que la sintaxis general debería ser familiar. Por ejemplo, podríamos querer registrar los valores de una variable categórica binaria como ceros y unos, creando una variable *dummy*. Esto es sencillo gracias al comando `if_else()`. Podemos especificar una condición lógica (`pres_sexo == female`) y luego los valores que se asignarán cuando esta se cumple (`1`) o no (`0`):


```r
aprob_presidencial %>% 
  mutate(d_pres_mujer = if_else(condition = pres_sexo == "female",
                                true      = 1,
                                false     = 0)) %>% 
  select(pais:presidente, pres_sexo, d_pres_mujer) # seleccionamos solo para legibilidad
## # A tibble: 1,020 x 6
##    pais       anio trimestre presidente              pres_sexo d_pres_mujer
##    <chr>     <dbl>     <dbl> <chr>                   <chr>            <dbl>
##  1 Argentina  2000         1 Fernando de la Rúa      Masculino            0
##  2 Argentina  2000         2 Fernando de la Rúa      Masculino            0
##  3 Argentina  2000         3 Fernando de la Rúa      Masculino            0
##  4 Argentina  2000         4 Fernando de la Rúa      Masculino            0
##  5 Argentina  2001         1 Fernando de la Rúa      Masculino            0
##  6 Argentina  2001         2 Fernando de la Rúa      Masculino            0
##  7 Argentina  2001         3 Fernando de la Rúa      Masculino            0
##  8 Argentina  2001         4 Fernando de la Rúa      Masculino            0
##  9 Argentina  2002         1 Eduardo Alberto Duhalde Masculino            0
## 10 Argentina  2002         2 Eduardo Alberto Duhalde Masculino            0
## # … with 1,010 more rows
```

Es posible especificar condiciones lógicas más complejas, tal como en `filter()`. Por ejemplo, generemos una variable *dummy* para los países-años-trimestres en crisis económica, definida como en el Ejercicio A: cuando el crecimiento del PIB sea negativo y/o el desempleo sea mayor al 20%. Bajo esta clasificación sencilla, Argentina estaría en crisis en el año 2001, mas no en el 2013:


```r
aprob_presidencial %>% 
  # no explicitamos los argumentos para hacer el código más sucinto:
  mutate(d_crisis_ec = if_else(crec_pib < 0 | desempleo > 20, 1, 0)) %>% 
  # lo siguiente es solo para mostrar más claramente los resultados:
  select(pais:trimestre, crec_pib, desempleo, d_crisis_ec) %>% 
  filter(pais == "Argentina" & anio %in% c(2001, 2013))
## # A tibble: 8 x 6
##   pais       anio trimestre crec_pib desempleo d_crisis_ec
##   <chr>     <dbl>     <dbl>    <dbl>     <dbl>       <dbl>
## 1 Argentina  2001         1     -4.4     18.3            1
## 2 Argentina  2001         2     -4.4     18.3            1
## 3 Argentina  2001         3     -4.4     18.3            1
## 4 Argentina  2001         4     -4.4     18.3            1
## 5 Argentina  2013         1      2.4      7.93           0
## 6 Argentina  2013         2      2.4      7.25           0
## 7 Argentina  2013         3      2.4      6.83           0
## 8 Argentina  2013         4      2.4      6.40           0
```

Sin embargo, a menudo `if_else()` no es lo suficientemente flexible, pues solo no permite asignar dos valores en base a una condición lógica. ¿Qué pasa si la variable que queremos crear toma más de dos valores? Por ejemplo, podríamos querer una variable que divida nuestras observaciones en tres categorías, según el país: "Cono Sur" (Argentina, Chile, Uruguay), "Centroamérica" y "Resto de AL". Para comenzar, miremos los valores que toma la variable "país":


```r
unique(aprob_presidencial$pais)
##  [1] "Argentina"   "Bolivia"     "Brasil"      "Chile"       "Colombia"   
##  [6] "Costa Rica"  "Ecuador"     "El Salvador" "Guatemala"   "Honduras"   
## [11] "México"      "Nicaragua"   "Panamá"      "Paraguay"    "Perú"       
## [16] "Uruguay"     "Venezuela"
```

`if_else()` no nos permitirá generar esta nueva variable, pero su primo `case_when()` sí. Veamos primero el código y su resultado:


```r
aprob_presidencial %>% 
  mutate(grupo_pais = case_when(
    pais %in% c("Argentina", "Chile", "Uruguay") ~ "Cono Sur",
    pais %in% c("Costa Rica", "El Salvador", "Guatemala", "Honduras",
                   "Nicaragua", "Panama") ~ "Centroamérica",
    TRUE ~ "Resto de AL"
  )) %>% 
  # para ver mejor los resultados, achicaremos la base:
  filter(anio == 2000 & trimestre == 1) %>% 
  select(pais, grupo_pais)
## # A tibble: 17 x 2
##    pais        grupo_pais   
##    <chr>       <chr>        
##  1 Argentina   Cono Sur     
##  2 Bolivia     Resto de AL  
##  3 Brasil      Resto de AL  
##  4 Chile       Cono Sur     
##  5 Colombia    Resto de AL  
##  6 Costa Rica  Centroamérica
##  7 Ecuador     Resto de AL  
##  8 El Salvador Centroamérica
##  9 Guatemala   Centroamérica
## 10 Honduras    Centroamérica
## 11 México      Resto de AL  
## 12 Nicaragua   Centroamérica
## 13 Panamá      Resto de AL  
## 14 Paraguay    Resto de AL  
## 15 Perú        Resto de AL  
## 16 Uruguay     Cono Sur     
## 17 Venezuela   Resto de AL
```

La nueva variable ("grupo país") esta construida en base a varias condiciones lógicas, que se evalúan en orden. Si la primera se cumple (`pais %in% c("Argentina", "Chile", "Uruguay")`), entonces se asigna el valor "Cono Sur" en la nueva variable. La condición lógica y el valor asignado están separados por un "~"^[Aprendí a decirle "colita de chancho" a este símbolo], que se puede leer como "entonces". Lo mismo sucederá con la siguiente condición, que si se cumple asigna "Centroamérica". Nuestro último argumento para `case_when()` tiene una condición lógica con mucho alcance: *en todos los demás casos* se aplicará el valor "Resto de AL".

### (Ejercicio D)

- `if_else()` puede pensarse como una versión reducida de `case_when()`: todo lo que hagamos con la primera función podríamos convertirlo a la sintaxis de la segunda. Traduce uno de los ejemplos anteriores con `if_else()` a la sintaxis de `case_when()`.

- Genera una variable que separe a los países en tres grupos: "Norteamérica", "Centroamérica" y "Sudamérica".

## Pivoteo de bases {#manejo-de-datos-pivoteo}

La estructura de la base anterior, donde las filas son las observaciones, las variables son columnas y nuestra base tiene solo una unidad observacional es la **estructura tidy** de representar datos (Wickham, 2010). En general, R y el `tidyverse` funcionan muy bien bajo esta forma, por lo que queremos utilizarla cuando sea posible.

Sin embargo, no siempre los datos con los que trabajamos en el mundo real siguen esta estructura. A menudo otros formatos resultan más convenientes en contextos distintos al análisis de datos, por ejemplo, el registro manual de la administración pública. Para comenzar, generemos una base de datos al nivel país-año con los niveles de aprobación promedio:


```r
aprob_presidencial_por_anio_pais <- aprob_presidencial %>% 
  group_by(pais, anio) %>% 
  summarize(aprob_neta = mean(aprob_neta)) %>% 
  ungroup()

aprob_presidencial_por_anio_pais
## # A tibble: 255 x 3
##    pais       anio aprob_neta
##    <chr>     <dbl>      <dbl>
##  1 Argentina  2000      15.6 
##  2 Argentina  2001     -17.4 
##  3 Argentina  2002     -16.0 
##  4 Argentina  2003      32.6 
##  5 Argentina  2004      48.5 
##  6 Argentina  2005      43.8 
##  7 Argentina  2006      45.9 
##  8 Argentina  2007      34.3 
##  9 Argentina  2008       9.52
## 10 Argentina  2009      -9.99
## # … with 245 more rows
```

Estos mismos datos *tidy* pueden presentarse en distintos formatos. El más común es *wide*, en el que una de las variables de identificación se distribuye en las columnas^[A veces se utiliza la nomenclatura *long* (polo opuesto de *wide*) para denominar a bases que aquí referimos como *tidy*.] (en este caso, "anio"). Carguemos la base en este formato desde el paquete del libro:


```r
# library(paqueteadp)
# data(aprob_presidencial_anual_wide)
```


```r
aprob_presidencial_anual_wide <- read_csv("00-datos/aprob_presidencial_esp_wide.csv")
## Parsed with column specification:
## cols(
##   pais = col_character(),
##   `2000` = col_double(),
##   `2001` = col_double(),
##   `2002` = col_double(),
##   `2003` = col_double(),
##   `2004` = col_double(),
##   `2005` = col_double(),
##   `2006` = col_double(),
##   `2007` = col_double(),
##   `2008` = col_double(),
##   `2009` = col_double(),
##   `2010` = col_double(),
##   `2011` = col_double(),
##   `2012` = col_double(),
##   `2013` = col_double(),
##   `2014` = col_double()
## )
```

Estos datos son exactamente los mismos a los que creamos manualmente, solo cambia su forma de presentación. Esta estructura *wide* tiene algunos beneficios, el más destacado de los cuales es su brevedad: no se repiten los años en múltiples celdas, como sí sucede en la base *tidy*. Para un codificador manual, este ahorro de espacio (y tiempo) resulta atractivo. No obstante, el formato *wide* tiene una gran desventaja al compararlo con *tidy*: en su forma tradicional, solo es posible registrar información de una variable por base. En el caso del ejemplo, no hay forma de añadir fácilmente, por ejemplo, información sobre la corrupción de los países-años. Como vimos antes, este ejercicio es trivial en una base *tidy*, en la que se pueden añadir las variables como columnas. Tener múltiples variables en nuestras bases es justamente lo que necesitamos para generar análisis de datos sociales, en los que buscamos explorar distintas dimensiones de nuestros fenómenos de estudio. 

Por suerte, el paquete `tidyr` (Wickham & Henry, 2019), que se carga automáticamente junto al `tidyverse`, provee funciones para convertir rápidamente nuestros datos desde *wide* a otro más amigable para los análisis. Este tipo de conversiones de estructura se suele llamar *pivoteo*. La función clave aquí es `pivot_longer()`, que nos permite pivotear la base a un formato "más largo". La base que obtendremos es igual a los datos *tidy* que creamos antes:


```r
aprob_presidencial_anual_wide %>% 
  pivot_longer(cols = -pais, names_to = "anio", values_to = "aprob_neta")
## # A tibble: 255 x 3
##    pais      anio  aprob_neta
##    <chr>     <chr>      <dbl>
##  1 Argentina 2000       15.6 
##  2 Argentina 2001      -17.4 
##  3 Argentina 2002      -16.0 
##  4 Argentina 2003       32.6 
##  5 Argentina 2004       48.5 
##  6 Argentina 2005       43.8 
##  7 Argentina 2006       45.9 
##  8 Argentina 2007       34.3 
##  9 Argentina 2008        9.52
## 10 Argentina 2009       -9.99
## # … with 245 more rows
```

El primer argumento de `pivot_longer()`, `cols =`, nos solicita seleccionar las columnas que transformar en una variable de identificación, utilizando la sintaxis de `select()` que vimos antes en el capítulo. En este caso, le estamos indicando a `pivot_longer()` que transforme todas las variables, excepto "pais", una variable de identificación. Luego, el argumento `names_to = ` nos pregunta cómo queremos llamar a la nueva variable de identificación, que nace de transformar la base. Por último, `values_to =` requiere el nombre de la nueva variable de interés que crearemos, a partir de los valores de las celdas de la base original.

En algunos casos nos resulta útil también hacer la operación inversa, transformar una base *tidy* al formato *wide*. Para esto podemos utilizar la otra función estrella de `tidyr`, llamada `pivot_wider()`. Veamos un ejemplo, partiendo de los datos en formato *tidy*:


```r
aprob_presidencial_por_anio_pais %>% 
  pivot_wider(names_from = "anio", values_from = "aprob_neta")
## # A tibble: 17 x 16
##    pais  `2000` `2001` `2002` `2003`  `2004`  `2005` `2006`  `2007` `2008`
##    <chr>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl>   <dbl>  <dbl>   <dbl>  <dbl>
##  1 Arge…  15.6  -17.4  -16.0   32.6   48.5    43.8    45.9   34.3     9.52
##  2 Boli… -18.8  -14.1   -5.77 -16.8   -0.301  24.5    34.7   28.1    16.9 
##  3 Bras…  -8.72  -2.87   3.51  45.8   26.3    21.3    30.8   40.1    58.3 
##  4 Chile  15.1    3.82   6.34   8.85  20.8    29.0    23.1   -0.790  -1.37
##  5 Colo… -22.3  -22.0    2.33  45.5   49.9    46.4    45.9   46.9    55.2 
##  6 Cost…   1.04  16.8   40.4   16.1   19.0     8.29   13.8   32.6    23.3 
##  7 Ecua…  28.5   20.4   26.5   18.7   -6.86   12.9    14.3   63.4    51.7 
##  8 El S…  14.8   35.5   36.6   27.5   55.3    57.4    28.2   24.5    17.9 
##  9 Guat…  11.6  -19.6  -37.7  -34.9    7.37   -2.87   -1.84   8.73    7.15
## 10 Hond…  40.7   48.8   32.2    8.65   7.71   -0.248  13.1   41.1     1.19
## 11 Méxi…  40.5   41.3   23.2   28.5   22.1    26.2    36.0   44.0    37.3 
## 12 Nica…   5.02  -2.43  36.1   11.9    8.87   -0.355  -5.93  14.5    -3.22
## 13 Pana…  -3.35  -3.37  -5.61 -17.3   -8.23   -5.09   30.6   26.8     1.16
## 14 Para… -20.0  -19.9  -19.2   -6.54  30.1    10.2   -10.9   -0.224  34.4 
## 15 Perú  -22.2   -3.02 -42.9  -53.4  -63.7   -61.0   -11.3   -3.70  -32.6 
## 16 Urug…  34.0   16.7   -7.98 -25.2  -18.8    54.8    38.7   35.3    38.6 
## 17 Vene… -10.0  -14.0  -21.2  -21.6  -17.1   -10.3    -8.89 -11.4   -14.0 
## # … with 6 more variables: `2009` <dbl>, `2010` <dbl>, `2011` <dbl>,
## #   `2012` <dbl>, `2013` <dbl>, `2014` <dbl>
```

Los argumentos esta vez son prácticamente un espejo de los anteriores. Aquí los queremos es que la nueva base tome desde "anio" sus nombres de columnas a lo ancho (`names_from = "anio"`), mientras que los valores los recoja desde nuestra variable de interés "aprob_neta" (`values_from = "aprob_neta"`).

Así, estos comandos son perfectamente simétricos. Por ejemplo, los siguiente cadena de comandos será inocua, pues `pivot_wider()` revertirá la transformación aplicada por `pivot_longer()`:


```r
aprob_presidencial_anual_wide %>%
  pivot_longer(cols = -pais, names_to = "anio", values_to = "aprob_neta") %>% 
  pivot_wider(names_from = "anio", values_from = "aprob_neta")
## # A tibble: 17 x 16
##    pais  `2000` `2001` `2002` `2003`  `2004`  `2005` `2006`  `2007` `2008`
##    <chr>  <dbl>  <dbl>  <dbl>  <dbl>   <dbl>   <dbl>  <dbl>   <dbl>  <dbl>
##  1 Arge…  15.6  -17.4  -16.0   32.6   48.5    43.8    45.9   34.3     9.52
##  2 Boli… -18.8  -14.1   -5.77 -16.8   -0.301  24.5    34.7   28.1    16.9 
##  3 Bras…  -8.72  -2.87   3.51  45.8   26.3    21.3    30.8   40.1    58.3 
##  4 Chile  15.1    3.82   6.34   8.85  20.8    29.0    23.1   -0.790  -1.37
##  5 Colo… -22.3  -22.0    2.33  45.5   49.9    46.4    45.9   46.9    55.2 
##  6 Cost…   1.04  16.8   40.4   16.1   19.0     8.29   13.8   32.6    23.3 
##  7 Ecua…  28.5   20.4   26.5   18.7   -6.86   12.9    14.3   63.4    51.7 
##  8 El S…  14.8   35.5   36.6   27.5   55.3    57.4    28.2   24.5    17.9 
##  9 Guat…  11.6  -19.6  -37.7  -34.9    7.37   -2.87   -1.84   8.73    7.15
## 10 Hond…  40.7   48.8   32.2    8.65   7.71   -0.248  13.1   41.1     1.19
## 11 Méxi…  40.5   41.3   23.2   28.5   22.1    26.2    36.0   44.0    37.3 
## 12 Nica…   5.02  -2.43  36.1   11.9    8.87   -0.355  -5.93  14.5    -3.22
## 13 Pana…  -3.35  -3.37  -5.61 -17.3   -8.23   -5.09   30.6   26.8     1.16
## 14 Para… -20.0  -19.9  -19.2   -6.54  30.1    10.2   -10.9   -0.224  34.4 
## 15 Perú  -22.2   -3.02 -42.9  -53.4  -63.7   -61.0   -11.3   -3.70  -32.6 
## 16 Urug…  34.0   16.7   -7.98 -25.2  -18.8    54.8    38.7   35.3    38.6 
## 17 Vene… -10.0  -14.0  -21.2  -21.6  -17.1   -10.3    -8.89 -11.4   -14.0 
## # … with 6 more variables: `2009` <dbl>, `2010` <dbl>, `2011` <dbl>,
## #   `2012` <dbl>, `2013` <dbl>, `2014` <dbl>
```

### (Ejercicio E)

- Genera una base *tidy* con el promedio de crecimiento del PIB por país-año. 

- Convierte esta base a formato *wide*, moviendo los años a las columnas. 

- Por último, vuelve a pivotear estos datos al formato *tidy*.

### Bases en formato *wide* con más de una variable de interés

Anteriormente mencionamos que no es posible registrar, de forma simple, información para más de una variable de interés en la estructura *wide*. Pero nuestras fuentes de datos a menudo tienen sorpresas poco amables para nosotros, como la siguiente:


```r
# library(paqueteadp)
# data(aprob_presidencial_anual_wide2)
```


```r
aprob_presidencial_anual_wide2 <- read_csv(
  "00-datos/aprob_presidencial_esp_wide2.csv"
  )
## Parsed with column specification:
## cols(
##   .default = col_double(),
##   pais = col_character()
## )
## See spec(...) for full column specifications.
```

Nota que en estos datos las columnas registran información en el tiempo para dos variables, "pib" y "poblacion". Lo que queremos es *alargar* esta información hacia las filas, reconstruyendo nuestros pares países-año y las dos variables de interés. Primero podemos pivotear los datos para dejarlos en el nivel país-año-variable. En `pivot_longer()` podemos indicar que los nombres de las columnas contienen información de más de una variable. Primero, el argumento `names_to = c("variable", "anio")` toma dos valores en esta ocasión, los nombres de las nuevas variables tras nuestro pivoteo. Segundo, `names_sep = "_"` indica que en las columnas de la base original la información de las dos variables está separada por un guión bajo (esto podría ser otro caracter, como un guión o una barra^[Si la separación entre tus variables es menos clara, pues ocupar el argumento `names_pattern =` en vez de `names_sep =`. Para esto deberás utilizar expresiones regulares, un tema tratado en el Capítulo \@ref(qta), de análisis de texto. Por ejemplo, podríamos escribir la misma operación aquí realizada con el siguiente argumento: `names_pattern = "(\\D+)_(\\d+)"`]).


```r
aprob_presidencial_anual_wide2 %>% 
  pivot_longer(cols = -pais, 
               names_to = c("variable", "anio"), names_sep = "_")
## # A tibble: 510 x 4
##    pais      variable anio          value
##    <chr>     <chr>    <chr>         <dbl>
##  1 Argentina pib      2000  552151219031.
##  2 Argentina pib      2001  527807756979.
##  3 Argentina pib      2002  470305820970.
##  4 Argentina pib      2003  511866938234.
##  5 Argentina pib      2004  558086338624.
##  6 Argentina pib      2005  607486243380.
##  7 Argentina pib      2006  656371581729.
##  8 Argentina pib      2007  715495242254.
##  9 Argentina pib      2008  744524552077.
## 10 Argentina pib      2009  700459679763.
## # … with 500 more rows
```

Luego podemos pivotear las variables a lo ancho para obtener nuestra base objetivo, tal como hicimos antes, con `pivot_wider()`. Hagamos todo en una cadena:


```r
aprob_presidencial_anual_wide2 %>% 
  pivot_longer(cols = -pais, 
               names_to = c("variable", "anio"), names_sep = "_") %>% 
  pivot_wider(names_from = "variable", values_from = "value")
## # A tibble: 255 x 4
##    pais      anio            pib poblacion
##    <chr>     <chr>         <dbl>     <dbl>
##  1 Argentina 2000  552151219031.  37057452
##  2 Argentina 2001  527807756979.  37471509
##  3 Argentina 2002  470305820970.  37889370
##  4 Argentina 2003  511866938234.  38309379
##  5 Argentina 2004  558086338624.  38728696
##  6 Argentina 2005  607486243380.  39145488
##  7 Argentina 2006  656371581729.  39558890
##  8 Argentina 2007  715495242254.  39970224
##  9 Argentina 2008  744524552077.  40382389
## 10 Argentina 2009  700459679763.  40799407
## # … with 245 more rows
```
