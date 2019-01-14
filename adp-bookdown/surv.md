

# Modelos de supervivencia {#surv}

***

**Lecturas de referencia**

- Box-Steffensmeier, J. M. & Jones, B. S. (2004). *Event history modeling: A guide for social scientists*. Cambridge: Cambridge University Press.

- Box-Steffensmeier, J. M., & Jones, B. S. (1997). Time is of the essence: Event history models in political science. *American Journal of Political Science*, 41(4), 1414-1461.

- Allison, P. D. (2014). *Event history and survival analysis: Regression for longitudinal event data* (2nd edition). Thousand Oaks, CA: SAGE publications.

- Box-Steffensmeier, J. M., Brady, H. E., & Collier, D. (Eds.). (2008). *The Oxford handbook of political methodology* (Vol. 10). Oxford: Oxford University Press.

***

Hay una serie de preguntas recurrentes al análisis de datos políticos que aún no hemos cubierto. Muchas veces nos interesa saber por qué ciertos eventos duran lo que duran, o porqué tardan más que otros en ocurrir ¿Por qué la paz es tan duradera entre algunos países mientras que otros guerrean con frecuencia? ¿Cuál era la probabilidad de que Turquía ingresara a la Unión Europea en 2018? ¿Por qué algunos legisladores permanecen en sus cargos por varios periodos consecutivos mientras que otros no logran reelegirse tan solo una vez? ¿Cuánto demora un sindicato en entrar en huelga durante una crisis económica? 

## Nociones básicas

Todas estas preguntas son sobre la duración de un evento. El momento de ocurrencia de un evento es parte de la respuesta que buscamos, necesitamos de un modelo que nos permita llegar a esta respuesta. Janet Box-Steffensmeier, una de las principales referencias en Ciencia Política de este método, se refiere a ellos como “modelos de eventos históricos” aunque buena parte de la literatura los llama modelos de supervivencia o modelos de duración. Si bien en la Ciencia Política no son modelos tan utilizados como uno creería (en el fondo, casi todas las preguntas que nos hacemos pueden ser reformuladas en una pregunta sobre la duración del evento), las ciencias médicas han explorado estos métodos en profundidad, y muchas las referencias que uno encuentra en R sobre paquetes accesorios a estos modelos son de departamentos bioestadísticos y médicos. De allí que “modelos de supervivencia” sea el nombre más frecuentemente utilizado para estos modelos, ya que en medicina comenzó a utilizárselos para modelar qué variables afectaban la sobrevida de sus pacientes enfermos.  

Podemos tener dos tipos de bases de datos para estos problemas. Por un lado podemos tener una base en formato de panel en el que para un momento dado nuestra variable dependiente codifica si el evento ha ocurrido ($=1$) o no ($=0$). Así, por ejemplo, podemos tener una muestra de veinte países para cincuenta años (1965-2015) en los que nuestra variable de interés es si el país ha implementado una reforma constitucional. La variable independiente asumirá el valor 1 para el año 1994 en Argentina, pero será 0 para el resto de los años en este país. Por otro lado, podemos tener una base de datos transversal en la que cada observación aparece codificada apenas una vez. En este caso necesitamos, además de la variable que nos dirá si en el periodo de interés el evento ocurrió o no para cada observación (por ejemplo, Argentina debería ser codificada como “1”), una variable extra que codifique el tiempo de “supervivencia” de cada observación, es decir, cuánto tiempo pasó hasta que finalmente el evento sucedió. Para el caso de Argentina, esta variable codificará 29 (años), que es lo que demoró en implementarse una reforma constitucional desde 1965. La elección del año de partida, como podrá sospechar, es decisión del investigador, pero tiene un efecto enorme sobre nuestros resultados. Además, muchas veces la fecha de inicio acaba determinada por la disponibilidad de datos y se alejan del ideal que quisieramos modelar. 

Supongamos que nos hacemos la pregunta que se hizo [David Altman](https://www.cambridge.org/core/books/citizenship-and-contemporary-direct-democracy/5F2081B8D1FD8AE7C7B9D784D272ED33): “¿Por qué algunos países demoran menos que otros en implementar instancias de democracia directa?”. Para ello tenemos una base de datos en formato de panel que parte del año 1900 y que llega a 2016 para 202 países (algunas observaciones, como la Unión Soviética se transforman en otras observaciones a partir de un determinado año en que dejan de existir). Al observar sus datos uno nota algo que probablemente también te suceda en tu base de datos. Para el año 2016 apenas un pequeño porcentaje de países había implementado este tipo de mecanismos (27% para ser más precisos) pero la base está censurada ya que a partir de ese año no sabemos que ha ocurrido con los países que aún no han implementado mecanismos de democracia directa. No todas las observaciones han “muerto” aún, ¿cómo saber cuándo lo harán? Ésta es una pregunta válida, que podremos responder con este tipo de modelos, ya que podemos calcular el tiempo que demorará cada uno de los países censurados en nuestra muestra (con la información que le damos al modelo, que siempre es incompleta). 

En nuestra base de datos tendremos, al menos, cuatro tipos de observaciones (ver figura 1): (a) aquellas que, para el momento en que tenemos datos ya estaban en la muestra, aunque no siempre sabremos hace cuanto que “existen”. Son, en la figura, las observaciones B y C. En la base de datos de Altman, por ejemplo, México ya existía como entidad política en 1900, cuando su base de datos parte (sabemos que la Primera República Federal existió como entidad política desde octubre de 1824, por lo que México sería codificado como existente a partir de esa fecha). También sabemos que en 2012, por primera vez, México implementó una iniciativa de democracia directa, lo que define como positiva la ocurrencia del evento que nos interesa medir. Así, México sería como la observación B de la figura; (b) Algunas observaciones estarán desde el comienzo de la muestra, y existirán hasta el último momento sin haber registrado el evento de interés. Tal es el caso, de la observación C en la figura. En la muestra de Altman un ejemplo sería Argentina, que desde 1900 está registrado en la base (ya había "nacido"), y hasta el último año de la muestra no había registrado instancias de democracia directa (no "murió"), lo que la transforma en una observación censurada. A los fines prácticos no cambia saber qué ocurrió a partir del año en que nuestra base termina. Por ejemplo, en la figura, nuestra base cubre hast $t_7$, y sabemos que en $t_8$ la observación C aún no había muerto, y la observación D lo había hecho en $t_8$. En nuestra base, C y D serán ambas observaciones censuradas en $t_7$; (c) Algunas observaciones pueden entrar “tarde” en la muestra, como es el caso de las observaciones A y D. Por ejemplo, Eslovenia entra a la muestra de Altman en 1991, que es cuando se independiza de Yugoslavia y "nace" como país; (d) Algunas observaciones, independientemente de cuando entren a la muestra, "moriran" durante el periodo analizado. Por ejemplo, A y B mueren dentro del periodo que hemos medido entrte $t_1$ y $t_7$. Ya para la observación D, no registramos su muerte. Hay un caso no considerado en el ejemplo, de observaciones que nacen y mueren sucesivamente a lo largo del periodo de estudio. Para ellas, deberemos decidir si las tratamos como observaciones independientes, o si modelamos la posibilidad de morir más de una vez. Si es así, la probabilidad de morir por segunda vez deberá estar condicionada por la probabilidad de haber muerto (y cuando!) por primera vez. Este es un tipo de caso algo más complejo que no cubriremos en este caoítulo.

<div class="figure" style="text-align: center">
<img src="00-images/surv_fig_10_1.PNG" alt="Ejemplos de observaciones presentes en una base de datos de supervivencia."  />
<p class="caption">(\#fig:unnamed-chunk-3)Ejemplos de observaciones presentes en una base de datos de supervivencia.</p>
</div>

Los modelos de supervivencia se interpretan a partir de la probabilidad de que en un momento dado el evento de interés ocurra siendo que que no ha ocurrido aun. Esta probabilidad recibe el nombre de tasa de riesgo. Partimos sabiendo que tenemos una variable, que llamaremos $T$, y que representa un valor aleatorio positivo y que tiene una distribución de probabilidades (correspondiente a la probabilidad del evento ocurrir en cada uno de los momentos posibles) que llamaremos $f(t)$. Esta probabilidad se puede expresar de manera acumulada, como una densidad acumulada $F(t)$. Com, en la que vemos que $F(t)$ viene dada por la probabilidad de que el tiempo de supervivencia $T$ sea menor o igual a un tiempo específico $t$ :

$$F(t)=\int\limits_0^t f(u)d(u)=Pr(T)\leq t)$$

La función de supervivencia $\hat S(t)$, que es un concepto clave en estos modelos, está relacionada a $F(t)$, ya que 

$$\hat S(t)= 1-F(t)=Pr(T\geq t)$$


Es decir, la función de supervivencia es la probabilidad inversa de $F(t)$, pues dice respecto a la probabilidad de que el tiempo de supervivencia $T$ sea mayor o igual un tiempo $t$ de interés. Para el ejemplo concreto de Altman, uno podría preguntarse cuál es la probabilidad de que un país no implemente un mecanismo de democracia directa (lo que sería equivalente a “sobrevivir” a dicha implementación) siendo que ya ha sobrevivido a los mismos por 30 años. A medida que más y más países en la muestra van implementando iniciativas de democracia directa, la probabilidad de supervivencia va disminuyendo. 

Los coeficientes de los modelos de supervivencia se suelen interpretar como tasas de riesgo (o “hazard rates” en inglés), que es el cociente de la probabilidad de que el evento suceda y la función de supervivencia

$$h(t)=\frac{f(t)}{S(t)}$$

Así, la tasa de riesgo indica la tasa a la que las observaciones “mueren” en nuestra muestra en el momento $t$, considerando que la observación ha sobrevivido hasta el momento $t$. Veremos más adelante como en el ejemplo de Altman podemos interpretar los coeficientes de nuestras regresiones como tasas de riesgo. En definitiva, la tasa de riesgo $h(t)$ es el riesgo de que el evento ocurra en un intervalo de tiempo determinado, que viene dado por 

$$f(t)=\lim_{\bigtriangleup x \to 0} \frac {P(t+\bigtriangleup t > T \geq t)}{\bigtriangleup t}$$

## El modelo Cox de riesgos proporcionales

Hay dos tipos de modelos de supervivencia, los llamados modelos paramétricos y los llamados semi-parametricos. Los primeros son aquellos que hacen supuestos sobre las características de la población a la que la muestra pertenece. En este caso, los supuestos son sobre el “baseline hazard”, es decir, sobre el riesgo de que el evento ocurra cuando todas nuestras variables independientes son iguales a cero. El tipo de modelo de surpervivencia más común para esta categoría es el modelo de Weibull. Por otro lado, los modelos semi-parametricos no hacen ningún tipo de supuestos sobre la función de base, ya que ésta es estimada a partir de los datos. El ejemplo más famoso de ésta especificación es la del modelo de Cox. 

El *Oxford Handbook* sobre metodología política dedica un capítulo entero a discutir modelos de supervivencia, y en el se toma una posición fuerte en favor de los modelos semi-parametricos. Aquí seguiremos dicha recomendación ya que las ventajas son varias. Por un lado, como no se hacen presupustos sobre la función del riesgo de base, su estimación es mucho más precisa. En una estimación paramétrica, elegir un “baseline hazard” equivocado siginificará que todo nuestro trabajo analítico estará sesgado. La decisión de la forma que adopta la curva de base en un modelo de Weibull debería estar orientado por razones teóricas de cuál es el efecto de nuestra variable independiente sobre la probabilidad de supervivencia de la observación (ver figura 2). Sin embargo, no siempre hay tales presupuestos. Elegir una especificación por Cox nos ahorra de tomar una decisión tan costosa.


<div class="figure" style="text-align: center">
<img src="00-images/surv_fig_10_2.png" alt="Diferentes riesgos de base en el modelo de Weibull" width="423" />
<p class="caption">(\#fig:unnamed-chunk-4)Diferentes riesgos de base en el modelo de Weibull</p>
</div>


Una segunda ventaja de los modelos semi-parametricos sobre los paramétricos tiene que ver con el presupuesto de riesgos proporcionales. Ambos, modelos paramétricos y semi-parametricos, asumen que los riesgos entre dos individuos cualquiera de la muestra se mantienen constantes a lo largo de todo su periodo de supervivencia. Es decir, se asume que la curva de riesgo de cada individuo sigue la misma curva en el tiempo. Este es un presupuesto fuerte para trabajos en ciencia política, ya que las observaciones cambian en el tiempo y se diferencian unas de otras. Piénsense en el trabajo de Altman, por ejemplo. Uno puede teorizar que la probabilidad de una iniciativa de democracia directa en un determinado año en un determinado país estará afectada por el nivel de solidez de las instituciones democráticas, que podemos medir con algún tipo de variable estándar como los 21 puntos de Polity IV o la más reciente medición de V-Dem. Podemos, entonces, teorizar que a mayor solidez institucional mayor probabilidad de implementar mecanismos de democracia directa. 

Sin embargo, los valores de estas variables no solo difieren ente países, sino que a lo largo del tiempo estas variables cambian mucho para un mismo país. Piénsese en Colombia, por ejemplo, en que la variable de V-Dem “v2x_polyarchy” sufrió avances y retrocesos entre 1900 y 2016 (ver figura 3). Cada vez que el valor de esta variable cambia, necesariamente cambia la tasa de riesgo de democracia directa para Colombia, rompiendo el presupuesto de proporcionalidad de los riesgos.

<div class="figure" style="text-align: center">
<img src="00-images/surv_fig_10_3.png" alt="Valores de poliarquía para Colombia según V-Dem" width="600" />
<p class="caption">(\#fig:unnamed-chunk-5)Valores de poliarquía para Colombia según V-Dem</p>
</div>

La ventaja del modelo de Cox sobre sus contrapartes paramétricas es que existen tests para saber si alguna variable de nuestro modelo rompe el presupuesto de proporcionalidad de los riesgos, y de esa forma podremos corregirlo generando interacciones entre estas variables y variables temporales. De esta forma, permitimos que en nuestro modelo haya dos tipos de coeficientes: coeficientes constantes en el tiempo, y coeficientes cambiantes en el tiempo. Por ejemplo, podemos imaginar que ante un aumento brusco en la calidad de las instituciones democráticas de un país la tasa de riesgo de implementar democracia directa se dispare, pero que dicho efecto de desvanezca en el lapso de cuatro o cinco años. Cuando definas tu modelo, es importante que reflexiones sobre qué variables puede asumirse que permanezcan constantes en los riesgos y cuales no. 

La recomendación dada por el *Oxford Handbook* para una buena implementación de modelos de supervivencia es la siguiente: (a) Primero, dada las ventajas de los modelos semi-paramétricos sobre los paramétricos, se recomienda el uso de Cox por sobre Weibull u otro modelo paramétrico. (b) Una vez que hemos definido nuestra variable dependiente (el evento), el tiempo de “nacimiento” y de “muerte” de cada observación, podemos especificar nuestro modelo. (c) Los coeficientes deben ser interpretados en tasas de riesgo (hazard rates), lo que exige exponenciar los coeficientes brutos que obtenemos en `R`.  (d) Una vez que tenemos el modelo que creemos correcto, en función de nuestras intuiciones teóricas, es necesario testear que ninguno de los coeficientes viole el presupuesto de proporcionalidad de los riesgos. Para ello ejecutamos un test de Grambsch y Therneau, o mediante el análisis de los residuos de Schoenfeld. (e) Una vez identificados los coeficientes problemáticos, permitimos que estos interactúen con el logaritmo natural de la variable que mide la duración del evento. De esta forma, permitimos que haya coeficientes cuyo efecto se desvanece o se potencia con el tiempo. Una vez corregidos los coeficientes problemáticos, podemos si, proceder a interpretar nuestro modelo y la función de supervivencia del modelo. 

## Aplicación en R

Volvamos, entonces, a pregunta que se hizo David Altman en el capítulo 3 de [Citizenship and Contemporary Direct Democracy (2019)](https://www.cambridge.org/core/books/citizenship-and-contemporary-direct-democracy/5F2081B8D1FD8AE7C7B9D784D272ED33), "Catching on: waves of adoption of citizen-initiated mechanisms of direct democracy since World War I": “¿Por qué algunos países demoran menos que otros en implementar instancias de democracia directa?”. Para poder responder a esta pregunta, uno debe correr modelos de supervivencia. Para cargar la base de datos vamos a usar la función `read_rds` de `tidyverse`:


```r
library(tidyverse)
datos_altman <- read_rds("00-datos/data_altman.rds")
```

A lo largo del ejemplo usaremos los paquetes `skimr`, `countrycode`, `survival`, `rms`, `survminer`, `ggalt`, `tidyverse`y `texreg`, pero los iremos cargando uno a uno para que veas para que sirven. 
Si utilizamos `skim`, como ya hicimos en otros capítulos, podemos ver que es una base en formato de panel balanceado. Es decir, tenemos una variable "país" (`country_name`), que se repite a lo largo de una variable "año" (`year`).





```r
skim(datos_altman)
## Skim summary statistics
##  n obs: 13885 
##  n variables: 23 
## 
## ── Variable type:character ────────────────────────────────────────────────────────────────────────
##      variable missing complete     n min max empty n_unique
##  country_name       0    13885 13885   4  32     0      202
## 
## ── Variable type:numeric ──────────────────────────────────────────────────────────────────────────
##              variable missing complete     n      mean    sd        p0
##        p25     p50      p75    p100     hist
##  [ reached getOption("max.print") -- omitted 22 rows ]
```
Los países entran a la base cuando comienzan a existir como países independientes. Veamos el caso de Albania, por ejemplo, que nace como país en 1912 luego de las [Guerras los Balcanes](https://es.wikipedia.org/wiki/Guerras_de_los_Balcanes):


```r
datos_altman %>% 
  filter(country_name == "Albania")
## # A tibble: 105 x 23
##    country_name  year cic_dummy dem_positive dem_negative memory
##    <chr>        <dbl>     <dbl>        <dbl>        <dbl>  <dbl>
##  1 Albania       1912         0            0            0      0
##  2 Albania       1913         0            0            0      0
##  3 Albania       1914         0            0            0      0
##  4 Albania       1915         0            0            0      0
##  5 Albania       1916         0            0            0      0
##  6 Albania       1917         0            0            0      0
##  7 Albania       1918         0            0            0      0
##  8 Albania       1919         0            0            0      0
##  9 Albania       1920         0            0            0      0
## 10 Albania       1921         0            0            0      0
## # ... with 95 more rows, and 17 more variables: v2x_polyarchy <dbl>,
## #   capabilities_geo_ide <dbl>, occur_geo_ide <dbl>,
## #   c_pos_capabilities <dbl>, c_pos_occurrences <dbl>, c_pos_memory <dbl>,
## #   log_pop <dbl>, c_gbr <dbl>, c_fra <dbl>, c_ussr <dbl>, c_spa <dbl>,
## #   c_usa <dbl>, c_ned <dbl>, c_prt <dbl>, c_bel <dbl>, c_ahe <dbl>,
## #   c_ote <dbl>
```

Para que los modelos funcionen correctamente en `R`, los países deberían salir del análisis (¡y de la base!) cuando "mueren", en este caso cuando adoptan mecanismos de democracia directa. Albania, siguiendo el ejemplo, debería salir en 1998, y no perdurar en la base hasta 2016 como sucede ahora. Entonces crearemos una segunda versión de nuestra base de datos donde esto ya ha sido corregido. Si tu base de datos está en este formato desde el comienzo, entonces podrás saltarte este paso:


```r
datos_altman_b <- datos_altman %>%
  group_by(country_name) %>%
  # que la suma acumulada de la dummy sea como máximo 1
  filter(cumsum(cic_dummy) <= 1) %>%
  ungroup()
```
Lo que estamos haciendo es filtrar de tal forma que al registrar el primer evento de interés (en este caso es la variable `cic_dummy`) el resto es dejado a un lado. Si comparamos el caso de Albania para la base original  y para la base actual veremos la diferencia: 

```r
datos_altman %>%
  filter(country_name == "Albania" & cic_dummy == 1)
## # A tibble: 19 x 23
##    country_name  year cic_dummy dem_positive dem_negative memory
##    <chr>        <dbl>     <dbl>        <dbl>        <dbl>  <dbl>
##  1 Albania       1998         1            0            0  1    
##  2 Albania       1999         1            0            0  1    
##  3 Albania       2000         1            0            0  1    
##  4 Albania       2001         1            0            0  1    
##  5 Albania       2002         1            0            0  0.94 
##  6 Albania       2003         1            0            0  0.88 
##  7 Albania       2004         1            0            0  0.82 
##  8 Albania       2005         1            0            0  0.76 
##  9 Albania       2006         1            0            0  0.7  
## 10 Albania       2007         1            0            0  0.64 
## 11 Albania       2008         1            0            0  0.580
## 12 Albania       2009         1            0            0  0.52 
## 13 Albania       2010         1            0            0  0.46 
## 14 Albania       2011         1            0            0  0.4  
## 15 Albania       2012         1            0            0  0.34 
## 16 Albania       2013         1            0            0  0.28 
## 17 Albania       2014         1            0            0  0.22 
## 18 Albania       2015         1            0            0  0.16 
## 19 Albania       2016         1            0            0  0.1  
## # ... with 17 more variables: v2x_polyarchy <dbl>,
## #   capabilities_geo_ide <dbl>, occur_geo_ide <dbl>,
## #   c_pos_capabilities <dbl>, c_pos_occurrences <dbl>, c_pos_memory <dbl>,
## #   log_pop <dbl>, c_gbr <dbl>, c_fra <dbl>, c_ussr <dbl>, c_spa <dbl>,
## #   c_usa <dbl>, c_ned <dbl>, c_prt <dbl>, c_bel <dbl>, c_ahe <dbl>,
## #   c_ote <dbl>

datos_altman_b %>% 
  filter(country_name == "Albania" & cic_dummy == 1)
## # A tibble: 1 x 23
##   country_name  year cic_dummy dem_positive dem_negative memory
##   <chr>        <dbl>     <dbl>        <dbl>        <dbl>  <dbl>
## 1 Albania       1998         1            0            0      1
## # ... with 17 more variables: v2x_polyarchy <dbl>,
## #   capabilities_geo_ide <dbl>, occur_geo_ide <dbl>,
## #   c_pos_capabilities <dbl>, c_pos_occurrences <dbl>, c_pos_memory <dbl>,
## #   log_pop <dbl>, c_gbr <dbl>, c_fra <dbl>, c_ussr <dbl>, c_spa <dbl>,
## #   c_usa <dbl>, c_ned <dbl>, c_prt <dbl>, c_bel <dbl>, c_ahe <dbl>,
## #   c_ote <dbl>
```
En resumen, ahora tenemos un panel desbalanceado, en el que los países entran a la base cuando comienzan a existir como tales y salen, o bien cuando adoptan mecanismos de democracia directa, o bien cuando la base termina en su extensión temporal (en 2016). De esta forma nuestra base se acerca mucho a la figura 1 con la que ejemplificamos los distintos tipos de observaciones. ¿Qué tal si probamos hacer algo similar a la figura 1 pero con los datos de David Altman? Este tipo de figuras se llaman gráficos de Gantt, y pueden recrearse con `ggplot2` aunque es justo decir que hay que seguir unos cuantos pasos, y puede ser algo dificil. Ojalá que con este ejemplo puedas recrearlo con tus propios datos porque una figura así es de mucha utlidad para el lector. 

Primero debemos crear una base de datos que, para cada país, registre el año de entrada y el año de salida. También nos interesa por qué sale el país: ¿adopta democracia directa o la base termina? Vamos a crear un subonjunto que llamaremos `gantt_plot_df` donde nos quedamos solamente con tres variables de la base, que son el nombre del país `country_name`, el año `year`, y la variable dependiente `cic_dummy`. También quitaremos de la base aquellas observaciones que para el primer año de la base ya han "muerto". Por ejemplo, Suiza había implementado mecanismos de democracia directa mucho antes que 1900, así que desde el primer año de la base hasta el último la variable dependiente será "1":

```r
gantt_plot_df <- datos_altman_b %>%
  # las variables que nos interesan
  dplyr::select(country_name, year, cic_dummy) %>%
  group_by(country_name) %>%
  filter(year == min(year) | year == max(year)) %>%
  # debemos sacar las observaciones para países que "nacen" (para nuestra base) con democracia directa:
  filter(!(year == min(year) & cic_dummy == 1)) %>%
  summarise(year_enters = min(year),
            year_exits  = max(year),
            exits_bc_dd = max(cic_dummy)) %>%
  ungroup()
gantt_plot_df
## # A tibble: 194 x 4
##    country_name        year_enters year_exits exits_bc_dd
##    <chr>                     <dbl>      <dbl>       <dbl>
##  1 Afghanistan                1919       2016           0
##  2 Albania                    1912       1998           1
##  3 Algeria                    1962       2016           0
##  4 Andorra                    1900       2016           0
##  5 Angola                     1975       2016           0
##  6 Antigua and Barbuda        1981       2016           0
##  7 Argentina                  1900       2016           0
##  8 Armenia                    1991       2016           0
##  9 Australia                  1901       2016           0
## 10 Austria                    1918       2016           0
## # ... with 184 more rows
```
Los países que salen por democracia directa ("mueren") son:

```r
gantt_plot_df %>% filter(exits_bc_dd == 1)
## # A tibble: 49 x 4
##    country_name year_enters year_exits exits_bc_dd
##    <chr>              <dbl>      <dbl>       <dbl>
##  1 Albania             1912       1998           1
##  2 Belarus             1991       1995           1
##  3 Belize              1981       2008           1
##  4 Bolivia             1900       2004           1
##  5 Bulgaria            1908       2009           1
##  6 Cape Verde          1975       1992           1
##  7 Colombia            1900       1991           1
##  8 Costa Rica          1900       2002           1
##  9 Croatia             1992       2001           1
## 10 Ecuador             1900       1998           1
## # ... with 39 more rows
```
Podemos identificar en una nueva variable la región geopolítica de cada país, gracias a la función `countrycode::countrycode()` (VER CAP X). Este paquete es de gran utilidad para quienes hacen política comparada o relaciones internacionales porque facilita mucho darle códigos a los países. Lo que nos permite el paquete es asignar a cada país su región de pertenencia de manera casi automática:

```r
library(countrycode)
gantt_plot_df_region <- gantt_plot_df %>%
  mutate(region = countrycode(country_name, origin = "country.name", dest = "region"))
## Warning in countrycode(country_name, origin = "country.name", dest = "region"): Some values were not matched unambiguously: Kosovo, South Yemen, Vietnam, Democratic Republic of, Vietnam, Republic of

gantt_plot_df_region
## # A tibble: 194 x 5
##    country_name      year_enters year_exits exits_bc_dd region             
##    <chr>                   <dbl>      <dbl>       <dbl> <chr>              
##  1 Afghanistan              1919       2016           0 Southern Asia      
##  2 Albania                  1912       1998           1 Southern Europe    
##  3 Algeria                  1962       2016           0 Northern Africa    
##  4 Andorra                  1900       2016           0 Southern Europe    
##  5 Angola                   1975       2016           0 Middle Africa      
##  6 Antigua and Barb…        1981       2016           0 Caribbean          
##  7 Argentina                1900       2016           0 South America      
##  8 Armenia                  1991       2016           0 Western Asia       
##  9 Australia                1901       2016           0 Australia and New …
## 10 Austria                  1918       2016           0 Western Europe     
## # ... with 184 more rows
```
Como dice el warning, algunos países no fueron encontrados. Estos son los países que `countrycode` no pudo encontrar, seguramente porque los países están escritos de otra manera:

```r
gantt_plot_df_region %>%
  filter(is.na(region))
## # A tibble: 4 x 5
##   country_name                    year_enters year_exits exits_bc_dd region
##   <chr>                                 <dbl>      <dbl>       <dbl> <chr> 
## 1 Kosovo                                 2008       2016           0 <NA>  
## 2 South Yemen                            1967       2016           0 <NA>  
## 3 Vietnam, Democratic Republic of        1945       2016           0 <NA>  
## 4 Vietnam, Republic of                   1949       1975           0 <NA>
```
Podemos corregir esto a mano ex-post o correr `countrycode::countrycode()` de nuevo, pero con el argumento `custom_match`:


```r
gantt_plot_df_region <- gantt_plot_df %>%
  mutate(region = countrycode(country_name, 
                              origin       = "country.name", 
                              dest         = "region",
                              custom_match = c("Korea, North" = "Eastern Asia",
                                               "Kosovo" = "Eastern Europe",
                                               "South Yemen" = "Western Asia",
                                               "Vietnam, Democratic Republic of" = "South-Eastern Asia",
                                               "Vietnam, Republic of" = "South-Eastern Asia")))
gantt_plot_df_region
## # A tibble: 194 x 5
##    country_name      year_enters year_exits exits_bc_dd region             
##    <chr>                   <dbl>      <dbl>       <dbl> <chr>              
##  1 Afghanistan              1919       2016           0 Southern Asia      
##  2 Albania                  1912       1998           1 Southern Europe    
##  3 Algeria                  1962       2016           0 Northern Africa    
##  4 Andorra                  1900       2016           0 Southern Europe    
##  5 Angola                   1975       2016           0 Middle Africa      
##  6 Antigua and Barb…        1981       2016           0 Caribbean          
##  7 Argentina                1900       2016           0 South America      
##  8 Armenia                  1991       2016           0 Western Asia       
##  9 Australia                1901       2016           0 Australia and New …
## 10 Austria                  1918       2016           0 Western Europe     
## # ... with 184 more rows
```
Ahora no tenemos NA! Hemos logrado asignar una región a cada país de la muestra.

```r
gantt_plot_df_region %>%
  filter(is.na(region))
## # A tibble: 0 x 5
## # ... with 5 variables: country_name <chr>, year_enters <dbl>,
## #   year_exits <dbl>, exits_bc_dd <dbl>, region <chr>
```
Con nuestra base ya armada, podemos hacer el plot con facilidad, gracias a `ggalt::geom_dumbbell()`:

```r
library(ggalt)
gantt_plot <- ggplot(data    = gantt_plot_df_region, 
                     mapping = aes(x     = year_enters, 
                                   xend  = year_exits, 
                                   y     = fct_rev(country_name), 
                                   color = factor(exits_bc_dd))) +
  geom_dumbbell(size_x = 2, size_xend = 2)

gantt_plot
```

<img src="surv_files/figure-html/unnamed-chunk-18-1.png" width="672" style="display: block; margin: auto;" />
En el eje vertical tenemos los países ordenados alfabeticamente, y en el eje x hay dos variables que informan al gráfico, por un lado el comienzo de la línea (`year_enters`) y por otro su fin (`year_exits`). Además, hay una tercer variable informativa que es el color de la línea, que denota si el país implementó o no una instancia de democracia directa (`exits_bc_dd`). Los pa[ises en azul son los que implementaron dicha instancia entre 1900 y 2016.  

Si bien la figura es de una enorme utilidad visual, hay que reconocer que son demasiados países para incluirla en el cuerpo de un artículo. Un enfoque posible es concentrarnos en ciertas regiones. Veamos Sudamérica, por ejemplo:

```r
gantt_plot_sa <- ggplot(data    = gantt_plot_df_region %>% filter(region == "South America"), 
                     mapping = aes(x     = year_enters, 
                                   xend  = year_exits, 
                                   y     = fct_rev(country_name), 
                                   color = fct_recode(factor(exits_bc_dd)))) +
  geom_dumbbell(size_x = 2, size_xend = 2)

gantt_plot_sa
```

<img src="surv_files/figure-html/unnamed-chunk-19-1.png" width="480" style="display: block; margin: auto;" />
Podemos agregarle los años como texto para mejorar aún más la lectura de la figura:

```r
gantt_plot_sa <- gantt_plot_sa + 
  geom_text(aes(label = year_enters), vjust = -.4) +
  geom_text(aes(x = year_exits, label = year_exits), vjust = -.4)

gantt_plot_sa
```

<img src="surv_files/figure-html/unnamed-chunk-20-1.png" width="480" style="display: block; margin: auto;" />
Finalmente, algunos retoques estéticos, con todo lo que hemos aprendido en el CAP X:

```r
library(ggplot2)
gantt_plot_sa <- gantt_plot_sa +
  labs(x     = "año", y = "",
       title = "Años de entrada y salida, Sudamérica",
       color = "¿Adopta democracia directa?") +
    theme(axis.text.x = element_blank())

gantt_plot_sa
```

<img src="surv_files/figure-html/unnamed-chunk-21-1.png" width="480" style="display: block; margin: auto;" />

Además de gráficos de Gantt, es muy común que quien trabaja con modelos de supervivencia muestre gráficos con las curvas de supervivencia comparando dos grupos de interés. Por ejemplo, David Altman se pregunta si hubo una diferencia en el siglo XX entre países que se democratizaron rápidamente y aquellos que demoraron décadas en hacerlo sobre la rapidez con que implementaron mecanismos de democracia directa. Este tipo de figuras no tiene valor inferencial, pero si gran valor decriptivo. Tenemos que estimar una curva de supervivencia no paramétrica, usando el método de Kaplan-Meier. 

A partir de este punto debemos hacer una modificación más a nuestra base. Seguramente tu también debas hacerlo con tus propios datos, así que presta atención. Los modelos de supervivencia no trabajan con datos de panel tradicionales, como el de nuestra base. Tenemos que convertirlos a "tiempo en riesgo". ¿Qué quiere decir esto?



```r
datos_altman_c <- datos_altman_b %>%
  group_by(country_name) %>%
  # vamos a eliminar el primer año para cada país. no está en riesgo, por definición!
  filter(year != min(year)) %>%
  mutate(risk_time_at_end   = c(1:n()),
         risk_time_at_start = c(0:(n() - 1))) %>%
  ungroup() %>%
  dplyr::select(country_name, year, risk_time_at_start, risk_time_at_end, everything())
```


```r
datos_altman_c
## # A tibble: 12,014 x 25
##    country_name  year risk_time_at_st… risk_time_at_end cic_dummy
##    <chr>        <dbl>            <int>            <int>     <dbl>
##  1 Afghanistan   1920                0                1         0
##  2 Afghanistan   1921                1                2         0
##  3 Afghanistan   1922                2                3         0
##  4 Afghanistan   1923                3                4         0
##  5 Afghanistan   1924                4                5         0
##  6 Afghanistan   1925                5                6         0
##  7 Afghanistan   1926                6                7         0
##  8 Afghanistan   1927                7                8         0
##  9 Afghanistan   1928                8                9         0
## 10 Afghanistan   1929                9               10         0
## # ... with 12,004 more rows, and 20 more variables: dem_positive <dbl>,
## #   dem_negative <dbl>, memory <dbl>, v2x_polyarchy <dbl>,
## #   capabilities_geo_ide <dbl>, occur_geo_ide <dbl>,
## #   c_pos_capabilities <dbl>, c_pos_occurrences <dbl>, c_pos_memory <dbl>,
## #   log_pop <dbl>, c_gbr <dbl>, c_fra <dbl>, c_ussr <dbl>, c_spa <dbl>,
## #   c_usa <dbl>, c_ned <dbl>, c_prt <dbl>, c_bel <dbl>, c_ahe <dbl>,
## #   c_ote <dbl>
```

Corramos la curva de  supervivencia no paramétrica, usando el método de Kaplan-Meier:


```r
library(survival)

km <- survfit(Surv(time = risk_time_at_start, time2 = risk_time_at_end,
                   event = cic_dummy) ~ dem_positive,
              type      = "kaplan-meier", 
              conf.type = "log", 
              data      = datos_altman_c)
```

Ahora podemos armar nuestro plot con `survminer::ggsurvplot()`

```r
library(survminer)
## Loading required package: ggpubr
## Loading required package: magrittr
## 
## Attaching package: 'magrittr'
## The following object is masked from 'package:purrr':
## 
##     set_names
## The following object is masked from 'package:tidyr':
## 
##     extract
ggsurvplot(km, conf.int = T, legend.title = "",
           break.x.by = 20,
           legend.labs = c("Fast democratization = 0", "Fast democratization = 1"), 
           data = datos_altman_c) +
  labs(title    = "Kaplan-Meir Survival estimates")
```

<img src="surv_files/figure-html/unnamed-chunk-25-1.png" width="1056" style="display: block; margin: auto;" />

Altman tiene la hipótesis de que países que sufrieron "shocks" democratizadores fueron mucho más rápidos en implementar mecanismos directos. La figura confirma su intuición, pues vemos que la probabilidad de supervivencia de un país (léase como la probabilidad de que persista sin implementar mecanismos de democracia directa) se reduce a la mitad en los primeros cuatro años que siguien al shock democratizador. Por el contrario, países que se democratizan de a poco, no sufren este efecto. 


### Replicar la tabla 1.2 de Altman e interpretar sus coeficientes como Hazard Ratios.

Vamos a correr los modelos y correr los tests de Grambsch and Therneau.


```r
cox_m1 <- coxph(Surv(risk_time_at_start, risk_time_at_end, cic_dummy) ~ 
                  dem_positive + dem_negative + memory + v2x_polyarchy + 
                  capabilities_geo_ide + occur_geo_ide, 
                data   = datos_altman_c, 
                robust = T, 
                method ="breslow")
```


```r
cox.zph(cox_m1)
##                          rho  chisq      p
## dem_positive         -0.1234 0.7250 0.3945
## dem_negative          0.0147 0.0106 0.9178
##  [ reached getOption("max.print") -- omitted 5 rows ]
```



```r
cox_m2 <- coxph(Surv(risk_time_at_start, risk_time_at_end, cic_dummy) ~ 
                  dem_positive + dem_negative + memory + v2x_polyarchy + 
                  capabilities_geo_ide + occur_geo_ide + c_pos_capabilities +
                  c_pos_occurrences, 
                data   = datos_altman_c, 
                robust = TRUE, 
                method ="breslow")
```


```r
cox.zph(cox_m2)
##                           rho   chisq      p
## dem_positive         -0.08383 0.30625 0.5800
## dem_negative          0.00630 0.00200 0.9643
##  [ reached getOption("max.print") -- omitted 7 rows ]
```


```r
cox_m3 <- coxph(Surv(risk_time_at_start, risk_time_at_end, cic_dummy) ~ 
                  dem_positive + dem_negative + memory + v2x_polyarchy + 
                  capabilities_geo_ide + occur_geo_ide + c_pos_capabilities +
                  c_pos_occurrences + c_pos_memory, 
                data   = datos_altman_c, 
                robust = TRUE, 
                method ="breslow")
```


```r
cox.zph(cox_m3)
##                          rho   chisq      p
## dem_positive         -0.2785  2.8244 0.0928
## dem_negative         -0.0242  0.0298 0.8630
##  [ reached getOption("max.print") -- omitted 8 rows ]
```


```r
cox_m4 <- coxph(Surv(risk_time_at_start, risk_time_at_end, cic_dummy) ~ 
                  dem_positive + dem_negative + memory + v2x_polyarchy + 
                  capabilities_geo_ide + occur_geo_ide + c_pos_capabilities +
                  c_pos_occurrences + c_pos_memory + log_pop, 
                data   = datos_altman_c, 
                robust = TRUE, 
                method = "breslow")
```


```r
cox.zph(cox_m4)
##                          rho   chisq      p
## dem_positive         -0.2834  2.9290 0.0870
## dem_negative          0.0278  0.0413 0.8389
##  [ reached getOption("max.print") -- omitted 9 rows ]
```



```r
cox_m5 <- coxph(Surv(risk_time_at_start, risk_time_at_end, cic_dummy) ~ 
                  dem_positive + dem_negative + memory + v2x_polyarchy + 
                  capabilities_geo_ide + occur_geo_ide + c_pos_capabilities +
                  c_pos_occurrences + c_pos_memory + log_pop + c_gbr, 
                data   = datos_altman_c, 
                robust = TRUE, 
                method ="breslow")
```


```r
cox.zph(cox_m5)
##                          rho   chisq      p
## dem_positive         -0.2640  2.5838 0.1080
## dem_negative          0.0462  0.1158 0.7336
##  [ reached getOption("max.print") -- omitted 10 rows ]
```

¿Cómo arreglar este problema?


```r
cox_m5_int <- coxph(Surv(risk_time_at_start, risk_time_at_end, cic_dummy) ~ 
                  dem_positive + dem_negative + memory + v2x_polyarchy + 
                  capabilities_geo_ide + occur_geo_ide + c_pos_capabilities +
                  c_pos_occurrences + c_pos_memory + log_pop + c_gbr +
                  v2x_polyarchy:log(risk_time_at_end) +
                  log_pop:log(risk_time_at_end), 
                data   = datos_altman_c, 
                robust = TRUE, 
                method ="breslow")
```

Veamos todos los modelos juntos con `texreg`:


```r
library(texreg)
```

**PENDIENTE**: Explicar el cálculo de errores estándares ajustados para modelos lineales generalizados.


```r
f_get_adj_se <- function(model){
  # adaptado de https://www.andrewheiss.com/blog/2016/04/25/convert-logistic-regression-standard-errors-to-odds-ratios-with-r/
  
  model_df <- broom::tidy(model)
  
  model_df_extra <- model_df %>% 
    mutate(hr       = exp(estimate),      # Hazard ratios
           var_diag = diag(vcov(model)),  # Varianza de cada coeficiente
           hr_se    = sqrt(hr^2 * var_diag))
  
  return(model_df_extra$hr_se)
}
```

**PENDIENTE:** Explicar que aquí se están utilizando iteraciones para reemplazar los coeficientes y errores estándar (y dejar el código legible)


```r
lista_modelos <- list(cox_m1, cox_m2, cox_m3, cox_m4, cox_m5, cox_m5_int)

screenreg(l = lista_modelos,
          custom.model.names = c("Modelo 1", "Modelo 2", "Modelo 3", "Modelo 4", "Modelo 5", "Modelo 5 c/int"),
          override.coef = map(lista_modelos, ~ exp(coef(.x))),
          override.se   = map(lista_modelos, ~ f_get_adj_se(.x)))
## 
## =========================================================================================================================
##                                      Modelo 1      Modelo 2      Modelo 3      Modelo 4      Modelo 5      Modelo 5 c/int
## -------------------------------------------------------------------------------------------------------------------------
## dem_positive                             7.00 ***      6.37 ***     13.18 ***     12.75 ***     12.44 ***      9.25 ***  
##                                         (2.53)        (2.91)        (7.71)        (7.34)        (7.20)        (6.23)     
## dem_negative                             2.42          2.42          2.40          2.39          2.21          2.32      
##                                         (1.77)        (1.77)        (1.75)        (1.76)        (1.63)        (1.72)     
## memory                                   5.11 ***      5.07 ***      6.60 ***      6.53 ***      6.06 ***      6.30 ***  
##                                         (1.85)        (1.89)        (2.75)        (2.72)        (2.58)        (2.66)     
## v2x_polyarchy                            3.91 *        3.96 *        3.99 *        4.26 *        5.97 **     498.25 ***  
##                                         (2.17)        (2.21)        (2.26)        (2.54)        (3.62)      (765.22)     
## capabilities_geo_ide                     2.98 ***      3.15 **       3.23 **       3.22 **       3.01 **       2.89 **   
##                                         (0.99)        (1.14)        (1.21)        (1.21)        (1.10)        (1.14)     
## occur_geo_ide                            0.03          0.02          0.01          0.01          0.01          0.02      
##                                         (0.05)        (0.04)        (0.03)        (0.03)        (0.03)        (0.05)     
## c_pos_capabilities                                     0.71          0.85          0.89          0.95          1.32      
##                                                       (1.32)        (1.61)        (1.68)        (1.68)        (2.22)     
## c_pos_occurrences                                     12.97         20.24         18.22         17.52         11.77      
##                                                      (65.70)      (107.88)       (97.37)       (88.32)       (52.45)     
## c_pos_memory                                                         0.29          0.30          0.26          0.23      
##                                                                     (0.25)        (0.25)        (0.21)        (0.19)     
## log_pop                                                                            1.03          1.03          1.61 *    
##                                                                                   (0.09)        (0.09)        (0.33)     
## c_gbr                                                                                            0.41 *        0.44      
##                                                                                                 (0.18)        (0.20)     
## v2x_polyarchy:log(risk_time_at_end)                                                                            0.25 **   
##                                                                                                               (0.11)     
## log_pop:log(risk_time_at_end)                                                                                  0.88 *    
##                                                                                                               (0.05)     
## -------------------------------------------------------------------------------------------------------------------------
## AIC                                    379.23        382.86        382.79        384.58        382.46        375.85      
## R^2                                      0.01          0.01          0.01          0.01          0.01          0.01      
## Max. R^2                                 0.04          0.04          0.04          0.04          0.04          0.04      
## Num. events                             48            48            48            48            48            48         
## Num. obs.                            11276         11276         11276         11245         11245         11245         
## Missings                               738           738           738           769           769           769         
## PH test                                  0.25          0.45          0.20          0.06          0.12          0.58      
## =========================================================================================================================
## *** p < 0.001, ** p < 0.01, * p < 0.05
```


