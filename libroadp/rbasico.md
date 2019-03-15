
# (PART) Introducción a R {-}

# R básico {#rbas}
*Por Andrés Cruz Labrín*

## Instalación

### R

`R` (R Core Team, 2017) es un lenguaje de programación especialmente desarrollado para realizar análisis estadístico. Una de sus principales características, como se ha dejado a entrever en el prefacio, es que es de *código libre*: aparte de ser gratis, esto significa que las licencias que protegen legalmente a `R` son muy permisivas. Al amparo de esas licencias, miles de desarrolladores alrededor del mundo han añadido su granito de arena a la usabilidad y atractivo de `R`. ¡En *AnalizaR Datos Políticos* le sacaremos el jugo a esa diversidad!

Instalar `R` es fácil, independiente de si el usuario utiliza Windows, Mac o Linux. Basta con ingresar a https://cran.r-project.org/ y seguir las instrucciones de descarga a instalación.


### RStudio

Como dijimos, `R` es un lenguaje de programación. En términos informales, es una forma ordenada de pedirle al computador que realice ciertas operaciones. Esto significa que es posible usar R exclusivamente desde una consola o terminal -las pantallas negras de los hackers de las películas. Aunque esto tiene algunos atractivos -entre ellos, parecer hacker-, en general queremos interfaces más amigables. Ahí es cuando entra en escena `RStudio`, el programa más popular para utilizar `R`. Una vez esté instalado, todos nuestros análisis ocurrirán dentro de `RStudio`, que es también de código libre.
Para instalar `RStudio`, es necesario ya haber instalado `R`. La descarga e instalación es accesible en Windows, Mac y Linux. El link es https://www.rstudio.com/products/rstudio/download/#download

<div class="books">
<p>Instale ambos <code>R</code> y <code>RStudio</code>, que nosotros lo esperamos aquí.</p>
</div>
## Partes de RStudio

Si lograste bajar e instalar `R` y `RStudio`, bastará con ingresar a `RStudio´ para comenzar a trabajar. Se pillará con una pantalla como la de la figura \@ref(fig:rbas-rstudio). ###(*MEJORAR LA IMAGEN! mejor fuente, fondo blanco*):

###*(F:creo que antes de largar habría que explicarle al lector como cambiar el idioma y ver ese tema del UTF8)*

<div class="figure" style="text-align: center">
<img src="00-images/rbas-rstudio.png" alt="Al abrir RStudio lo primero que verás es la interfase de estos cuatro paneles que explicaremos uno a uno." width="415" />
<p class="caption">(\#fig:rbas-rstudio)Al abrir RStudio lo primero que verás es la interfase de estos cuatro paneles que explicaremos uno a uno.</p>
</div>

La pantalla de `RStudio` se divide en cuatro paneles. A continuación, vamos a explicar sus funciones. La idea en esta sección es familiarizar al lector con lo básico de `R` en el camino.

### Consola

El panel inferior izquierdo de `RStudio`. Es nuestro espacio de comunicación directa con el computador, en el que le solicitamos, hablando “lenguaje `R`”, realizar tareas específicas. Llamaremos **comandos** a estas solicitudes. Probemos correr un comando que realiza una operación aritmética básica:

```r
2 + 2
## [1] 4
```
Un truco importante de la consola es que con tus flechas del teclado de arriba y abajo podrás navegar en el historial de comandos recientes. 
<div class="books">
<p>Recomendamos al lector probar de realizar otros comandos con operaciones aritméticas y volver atrás con los botones de arriba y abajo.</p>
</div>

###*cambiar imagen de resumen de funciones porque esta en ingles*
Algunas de las funciones más básicas con las que aprender son las de la figura \@ref(fig:rbas-basiccalc):
<div class="figure" style="text-align: center">
<img src="00-images/rbas-basiccalc.png" alt="Estas son las funciones básicas con las que podrás trabajar en R. ¡Pronto veremos funciones más interesantes!" width="136" />
<p class="caption">(\#fig:rbas-basiccalc)Estas son las funciones básicas con las que podrás trabajar en R. ¡Pronto veremos funciones más interesantes!</p>
</div>
Por ejemplo:

```r
sqrt(100) - 2^3 * 3
## [1] -14
```

### Script

El panel superior izquierdo de `RStudio` puede describirse como una suerte de "bitácora de comandos". Aunque la consola puede ser útil para unos pocos comandos, análisis complejos requerirán que llevemos un registro de nuestros comandos.

Para abrir un script nuevo, basta con presionar `Ctrl + Shift + N` o ir a `File > New File > R Script` (utilizar atajos de teclado suele ser una buena idea, y no solo por el factor hacker. La pantalla en blanco de un nuevo script es similar a un bloc de notas sin usar, con la particularidad de que cada línea debe pensarse como un comando. El lector debe notar que escribir un comando en el script y presionar `Enter` no consigue nada más que un salto de párrafo. Para correr el comando de una línea basta con presionar `Ctrl + Enter` (en el caso de Mac, `Cmd + Enter`) mientras se tiene el teclado en ella. ¡Es posible seleccionar múltiples líneas/comandos a la vez y correrlas de una pasada con `Ctrl + Enter`!

También es fundamental para trabajar bien dejar comentarios explicativos en nuestros scripts. Esto no es solo relevante en el trabajo en grupo (el código ajeno puede ser inentendible sin una guía clara), sino que también denota atención por nuestros yo del futuro. En varias ocasiones nos ha tocado revisar código que escribimos hace un par de meses, no entender nada, y maldecir a nuestros yo del pasado por su poca consideración. A la hora de interpretar comandos, `R` reconoce que todo lo que siga a un numeral (# o *hashtag*) es un comentario. Así, hay dos formas de dejar comentarios, como "comandos estériles" o como apéndices de comandos funcionales:


```r
# Este es un comando estéril. R sabe que es solo un comentario, por lo que no retorna nada.
```

```r
2 + 2 # Este es un comando-apéndice. ¡R corre el comando hasta el # y luego sabe que es un comentario!
## [1] 4
```
Para guardar un script, basta con presionar `Ctrl + S` o clickear `File > Save`.

### Objetos

Este es el panel superior derecho de `RStudio`. Aunque tiene tres pestañas (“Environment”, “History” y “Connections”), la gran estrella es "Environment" que sirve como registro para los objetos que vayamos creando a medida que trabajamos. Una de las características centrales de `R `es que permite almacenar objetos para luego correr comandos con ellos. La forma para crear un objeto es usando la flechita `<-` de tal manera que `nombre_del_objeto <- contenido`. Por ejemplo:

```r
objeto_1 <- 2 + 2
```

El lector notará que en la pestaña "Environment" aparece un nuevo objeto, objeto_1. Este contiene el resultado de 2 + 2. Es posible preguntarle a `R` qué contiene un objeto simplemente corriendo su nombre como si fuera un comando:


```r
objeto_1
## [1] 4
```
Los objetos pueden insertarse en otros comandos, haciendo referencia a sus contenidos. Por ejemplo:


```r
objeto_1 + 10
## [1] 14
```

También es posible reasignar a los objetos. ¡Si nos aburrimos de `objeto_1` como un `4`, podemos asignarle cualquier valor que queramos! Valores de texto o no númericos se pueden asignar entre comillas:


```r
objeto_1 <- "democracia"
```

```r
objeto_1 
## [1] "democracia"
```

Borrar objetos es también muy simple. Aunque suene como perder nuestro duro trabajo, tener un "Environment" limpio y fácil de leer a menudo lo vale la pena. Para ello usamos la función `rm`

```r
rm(objeto_1)
```

#### Vectores

Hasta ahora hemos conocido los objetos más simples de `R`, que contienen un solo valor. Objetos un poco más complejos son los **vectores** o "lineas" de valores. Crear un vector es simple, basta con insertar sus componentes dentro de `c()`, separados por comas:

```r
vector_1 <- c(15, 10, 20)
```

```r
vector_1
## [1] 15 10 20
```

#### Funciones

Sin notarlo, hemos ya utilizado a través `sqrt()`, `log()` [###sqrt()`, `log()`no se han usado!] y `c()`una de las cualidades más importantes de `R`: las funciones. En términos muy básicos, una función es un procedimiento como el siguiente:

<div class="figure" style="text-align: center">
<img src="00-images/rbas-funs.png" alt="Las funciones nos permitirán hacer las transformaciones necesarias a nuestros datos." width="308" />
<p class="caption">(\#fig:rbas-funs)Las funciones nos permitirán hacer las transformaciones necesarias a nuestros datos.</p>
</div>

`sqrt()` toma un valor numérico como input y devuelve su raíz cuadrada como output. `log()` toma el mismo input, pero devuelve su logaritmo común (o en base a 10).  `c()` toma distintos valores únicos como input y devuelve un vector que los concatena.

Es a propósito de los vectores que las funciones de `R` comienzan a brillar y a alejarse de las cualidades básicas de una calculadora (que, a grandes rasgos, es lo que hemos visto ahora de `R`, nada muy impresionante). Veamos algunas funciones que extraen información útil sobre algún vector. ¿Qué hace cada una?


```r
mean(vector_1) # media
## [1] 15
median(vector_1) # mediana
## [1] 15
sd(vector_1) # desviación estándar
## [1] 5
sum(vector_1) # suma
## [1] 45
min(vector_1) # valor mínimo
## [1] 10
max(vector_1) # valor máximo
## [1] 20
length(vector_1) # longitud (cantidad de valores)
## [1] 3
sort(vector_1) # ...
## [1] 10 15 20
```

El lector podría haber deducido que `sort()`, la última función del lote anterior, ordena al vector de menor a mayor. ¿Qué pasa si quisiéramos ordenarlo de mayor a menor? Esto nos permite introducir a los *argumentos*, partes de las funciones que nos permiten modificar su comportamiento. A continuación agregaremos el argumento `decreasing = TRUE` al comando anterior, consiguiendo nuestro objetivo:
###F: OTRA OPCION NO SERIA PONER UN – DELANTE DE SORT? ASI SE HIZO TODO EL LIBRO, O ES SOLO PARA ARRANGE QUE SIRVE?

```r
sort(vector_1, decreasing = TRUE)
## [1] 20 15 10
```


### Archivos / gráficos / paquetes / ayuda

Es el cuadrante inferior derecho de la pantalla de `RStudio`. ¡Estas cuatro pestañas son las que se roban la película! Vamos una por una:

#### Archivos

Esta pestaña es una ventana a los archivos que tenemos en nuestro directorio de trabajo Funcionando como un pequeño gestor, nos permite moverlos, renombrarlos, copiarlos, etcétera. A propósito de archivos, una de las grandes novedades recientes de `R` son los *RStudio Projects*, o proyectos de `RStudio`. Los desarrolladores de `RStudio` se dieron cuenta de que sus usuarios tenían scripts y otros archivos de `R` desperdigados a lo largo y ancho de sus discos duros, sin orden alguno. Por eso implementaron la filosofía de "un proyecto, una carpeta". "Un proyecto, una carpeta" es tan simple como suena: la idea es que cada proyecto en el que trabajemos sea autosuficiente, que incluya todo lo que necesitemos para trabajar. Se pueden manejar los proyectos desde la esquina superior derecha de `R`. ¿Viste las tres solapas “Environment”, “History”, “Connections”? Bueno, mira un poquito más arriba y verás el logo de `R Projects`. Aquí debes ser cuidadoso y notar que crear o abrir un proyecto reiniciará tu sesión de `R`, borrando todo el trabajo que no guardes. Como nos has creado proyectos aún, tu sesión dirá `Project: (None)`. Al clicar en “New Project” se ofrecen tres alternativas

<img src="00-images/rproj.png" style="display: block; margin: auto;" />
### EXPLICAR CADA UNA DE ESTAS OPCIONES. *(F: creo que podemos expandir un poquito mas en la utilidad de los proyectos con un ejemplo, a mi me ha resultado muy grato el tema de los proyectos!)*

#### Gráficos

Aquí aparecen los gráficos que realizamos con `R`. ¡En el capítulo 5 aprenderemos a crearlos!

#### Instalar paquetes

Una de las cualidades de `R` a la que más hincapié hemos dado es su versatilidad. Su código libre hace que muchos desarrolladores se sientan atraídos a aportar a la comunidad de `R` con nuevas funcionalidades. En general, realizan esto a través de paquetes, que los usuarios pueden instalar como apéndices adicionales a `R`. Los paquetes contienen nuevas funciones, bases de datos, etcétera. La pestaña de `RStudio` aquí reseñada nos permite acceder a nuestros paquetes instalados.

En la introducción mencionamos la enorme contribución que significó la creación de `tidyverse`. Instalar un paquete es bastante simple, a través de la función `install.packages()`. A continuación vamos a instalar el paquete `tidyverse`, central en nuestros próximos análisis. El `tidyverse` es una recopilación que incluye algunos de los mejores paquetes modernos para análisis de datos en `R`.

```r
install.packages("tidyverse")
```

Cada vez que el usuario abre una nueva sesión de `R`, este se abre como "recién salido de fábrica". Es decir, no solo se abre sin objetos sino que solo con los paquetes básicos que permiten a `R` funcionar. Tenemos que cargar los paquetes extra que queramos usar, entonces. Es más o menos como cuando compramos un *smartphone* y descargamos las aplicaciones que más usaremos, para que se ajuste a nuestras necesidades cotidianas. La forma más común de hacer esto es a través de la función `library()`, como se ve a continuación:

```r
library("tidyverse")
## ── Attaching packages ────────────────────────────────────────── tidyverse 1.2.1 ──
## ✔ ggplot2 3.1.0       ✔ purrr   0.3.1  
## ✔ tibble  2.0.1       ✔ dplyr   0.8.0.1
## ✔ tidyr   0.8.3       ✔ stringr 1.4.0  
## ✔ readr   1.3.1       ✔ forcats 0.4.0
## ── Conflicts ───────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

El lector puede ahorrarse el trabajo de instalar los paquetes y funciones utilizados en *AnalizaR Datos Políticos* en el futuro y hacerlo todo ahora, corriendo el siguiente súper comando. Ojo: ¡esto no lo salvará de cargar los paquetes en cada nueva sesión de R que inicie! Ojo 2: puede que esto le tome un tiempo considerable.

###*paquetes a instalar*
*F: excelente que vamos a ofrecer esto, puede haber un paquete llamado ADP que tenga todo?*

#### Ayuda

Buscar ayuda es central a la hora de programar en `R`. Esta pestaña de `RStudio` abre los archivos de ayuda que necesitemos, permitiéndonos buscar en ellos. Las funciones tienen archivos de ayuda para sí solas. Por ejemplo, podemos acceder al archivo de ayuda de la función `sqrt()` a través del comando `help(sqrt)`. Los paquetes en su conjunto también tienen archivos de ayuda, más comprensivos. Por ejemplo, para ver los archivos de ayuda del tidyverse solo debemos recurrir al argumento "package": `help(package = tidyverse)`. El lector debe notar que los archivos de ayuda de paquetes y funciones de paquetes solo están disponibles si el paquete ha sido cargado.
<div class="figure" style="text-align: center">
<img src="00-images/help.png" alt="En la solapa Help podemos buscar los documentos de ayuda de los paquetes que queremos utilizar. ¡Esta es la mejor forma de aprender R!" width="254" />
<p class="caption">(\#fig:rbas-help)En la solapa Help podemos buscar los documentos de ayuda de los paquetes que queremos utilizar. ¡Esta es la mejor forma de aprender R!</p>
</div>
Dentro del archivo de ayuda para un paquete podemos buscar sub-funciones o dudas sobre comandos específicos en el cuadrante que hemos señalado en rojo.  

<div class="books">
<p><strong>Ejercicios antes de continuar al próximo capítulo</strong> - ¿Qué significa “correr” un comando desde un script? ¿Cómo se hace? - ¿Cuál es la media de los dígitos del hit de Rafaella Carrà, 0 3 0 3 4 5 6? ¿Y la mediana? Por último, ordénelos de mayor a menor. - Busque ayuda para el paquete “googledrive”. Recomendado: maravillarse con la variedad de los paquetes de <code>R</code>.</p>
</div>

