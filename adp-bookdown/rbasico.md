

# (PART) Introducción a R {-}

# R básico {#rbas}

*Por Andrés Cruz Labrín*

## Instalación

### R

R (R Core Team, 2017) es un lenguaje de programación especialmente desarrollado para realizar análisis estadístico. Una de sus principales características, como se ha dejado a entrever en el prefacio, es que es de *código libre*: aparte de ser gratis, esto significa que las licencias que protegen legalmente a R son muy permisivas. Al amparo de esas licencias, miles de desarrolladores alrededor del mundo han añadido su granito de arena a la usabilidad y atractivo de R. ¡En *analizaR datos políticos* le sacaremos el jugo a esa diversidad!

Instalar R es fácil, independiente de si el usuario utiliza Windows, Mac o Linux. Basta con ingresar a https://cran.r-project.org/ y seguir las instrucciones de descarga a instalación.


### RStudio

Como dijimos, R es un lenguaje de programación. En términos informales, es una forma ordenada de pedirle al computador que realice ciertas operaciones. Esto significa que es posible usar R exclusivamente desde una consola o terminal -las pantallas negras de los hackers de las películas. Aunque esto tiene algunos atractivos -entre ellos, parecer hacker-, en general queremos interfaces más amigables. Ahí es cuando entra al ruedo RStudio, el programa de facto para utilizar R. Una vez esté instalado, todos nuestros análisis ocurrirán dentro de RStudio, que, para más remate, es también de código libre.
Para instalar RStudio, es necesario ya haber instalado R. Como para este, la descarga e instalación es accesible en Windows, Mac y Linux. El link es https://www.rstudio.com/products/rstudio/download/#download

Instale ambos R y RStudio, que nosotros lo esperamos aquí. 

Será bueno que nos acompañe a lo largo del capítulo con el programa abierto en su computador, nada mejor que aprender juntos. 

## Partes de RStudio

Si el lector consiguió descargar e instalar R y RStudio, bastará con ingresar a RStudio para comenzar a trabajar. Se pillará con una pantalla como esta (*pulir! mejor fuente, fondo blanco*):

*(F:creo que antes de largar habría que explicarle al lector como cambiar el idioma y ver ese tema del UTF8)*

<img src="00-images/rbas-rstudio.png" width="415" style="display: block; margin: auto;" />


La pantalla de RStudio se divide en cuatro paneles. A continuación, vamos a explicar sus funciones. La idea en esta sección es familiarizar al lector con lo básico de R en el camino.

### Consola

El panel inferior izquierdo de RStudio. Es nuestro espacio de comunicación directa con el computador, en el que le solicitamos, hablando R, realizar tareas específicas. Llamaremos **comandos** a estas solicitudes. Probemos correr un comando que realiza una operación aritmética básica:


```r
2 + 2
## [1] 4
```

Un truco importante de la consola es que con los botones de arriba y abajo es posible navegar en el historial de comandos recientes. Recomendamos al lector probar de realizar otros comandos con operaciones aritméticas y volver atrás con los botones de arriba y abajo.

*cambiar imagen de resumen*

<img src="00-images/rbas-basiccalc.png" width="136" style="display: block; margin: auto;" />



Por ejemplo:




```r
sqrt(100) - 2^3 * 3
## [1] -14
```


### Script

El panel superior izquierdo de RStudio puede describirse como una suerte de "bitácora de comandos". Aunque la consola puede ser útil para unos pocos comandos, análisis complejos requerirán que llevemos un registro de nuestros comandos.

Para abrir un script nuevo, basta con presionar `Ctrl + Shift + N` o ir a File > New File > R Script (utilizar atajos de teclado suele ser una buena idea, y no solo por el factor hacker *A:footnote al anexo tips?* *F: Yo creo que puede ir a la Parte III*). La pantalla en blanco de un nuevo script es similar a un bloc de notas sin usar, con la particularidad de que cada línea debe pensarse como un comando. El lector debe notar que escribir un comando en el script y presionar `Enter` no consigue nada más que un salto de párrafo. Para correr el comando de una línea basta con presionar `Ctrl + Enter` (en el caso de Mac, `Cmd + Enter`) mientras se tiene el teclado en ella. ¡Es posible seleccionar múltiples líneas/comandos a la vez y correrlas de una pasada con `Ctrl + Enter`!

Es fundamental el dejar comentarios explicativos en nuestros scripts. Esto no es solo relevante en el trabajo en grupo (el código ajeno puede ser inentendible sin una guía clara), sino que también denota atención por nuestros yo del futuro. En varias ocasiones nos ha tocado revisar código que escribimos hace un par de meses, no entender nada, y maldecir a nuestros yo del pasado por su poca consideración. A la hora de interpretar comandos, R reconoce que todo lo que siga a un numeral (# o *hashtag*, en estos días) es un comentario. Así, hay dos formas de dejar comentarios, como "comandos estériles" o como apéndices de comandos funcionales:


```r
# Este es un comando estéril. R sabe que es solo un comentario, por lo que no retorna nada.
```


```r
2 + 2 # Este es un comando-apéndice. ¡R corre el comando hasta el gato y luego sabe que es un comentario!
## [1] 4
```

Para guardar un script, basta con presionar `Ctrl + S` o clickear File > Save.

### Objetos

El panel superior derecho de RStudio. Aunque tiene tres pestañas, la gran estrella es "Environment", que sirve como registro para los objetos que vayamos creando a medida que trabajamos. Una de las características centrales de R es que permite almacenar objetos, para luego correr comandos en ellos. La forma tipo para crear un objeto es `nombre_del_objeto <- contenido`. Por ejemplo:


```r
objeto_1 <- 2 + 2
```

El lector notará que en la pestaña "Environment" aparece un nuevo objeto, objeto_1. Este contiene *el resultado* de 2 + 2. Es posible preguntarle a R qué contiene un objeto simplemente corriendo su nombre como si fuera un comando:


```r
objeto_1
## [1] 4
```

Los objetos pueden insertarse en otros comandos, haciendo referencia a sus contenidos. Por ejemplo:


```r
objeto_1 + 10
## [1] 14
```

También es posible reasignar a los objetos. ¡Si nos aburrimos de objeto_1 como un 4, podemos asignarle cualquier valor que queramos! Valores de caracter o no númericos se pueden asignar entre comillas:


```r
objeto_1 <- "democracia"
```


```r
objeto_1 
## [1] "democracia"
```

Borrar objetos es también muy simple. ¡Aunque suene como perder nuestro duro trabajo, tener un "Environment" limpio y fácil de leer a menudo lo vale!


```r
rm(objeto_1)
```


#### Vectores

Hasta ahora hemos conocido los objetos más simples de R, que contienen un solo valor. Objetos un poco más complejos son los vectores, "lineas" de valores. Crear un vector es simple, basta con insertar sus componentes dentro de `c()`, separados por comas:


```r
vector_1 <- c(15, 10, 20)
```


```r
vector_1
## [1] 15 10 20
```

#### Funciones

Sin notarlo, hemos ya utilizado a través `sqrt()`, `log()` y `c()`una de las cualidades más importantes de R, las funciones. En términos muy básicos, una función es un procedimiento como el siguiente:

<img src="00-images/rbas-funs.png" width="308" style="display: block; margin: auto;" />

`sqrt()` toma un valor numérico como input y devuelve su raíz cuadrada como output. `log()` toma el mismo input, pero devuelve su logaritmo común (o en base a 10).  `c()` toma distintos valores únicos como input y devuelve un vector que los concatena.

Es a propósito de los vectores que las funciones de R comienzan a brillar y a alejarse de las cualidades básicas de una calculadora (que, a grandes rasgos, es lo que hemos visto ahora de R, nada muy impresionante). Veamos algunas funciones que extraen información útil sobre nuestro vector. ¿Qué hace cada una?


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


```r
sort(vector_1, decreasing = TRUE)
## [1] 20 15 10
```


### Archivos / gráficos / paquetes / ayuda

En el panel inferior derecho de RStudio estas cuatro pestañas son las que se roban la película.

#### Archivos

Esta pestaña es una ventana a nuestros archivos. Funcionando como un pequeño gestor, nos permite moverlos, renombrarlos, copiarlos, etcétera. A propósito de archivos, una de las grandes novedades recientes de R son los *RStudio Projects*, o proyectos de RStudio. Los desarrolladores de RStudio se dieron cuenta de que sus usuarios tenían scripts y otros archivos de R (de los que aprenderemos luego, como bases de datos) desperdigados a lo largo y ancho de sus discos duros, sin orden alguno. Por eso implementaron la filosofía de "un proyecto, una carpeta". Es tan simple como suena: la idea es que cada proyecto en el que trabajemos sea autosuficiente, que incluya todo lo que necesitemos en una sola carpeta. Se pueden manejar los proyectos desde la esquina superior derecha de R. El lector debe ser cuidadoso y notar que crear o abrir un proyecto reiniciará su sesión de R, borrando todo el trabajo que no guarde.

*(F: creo que podemos expandir un poquito mas en la utilidad de los proyectos con un ejemplo, a mi me ha resultado muy grato el tema de los proyectos!)*

*(screenshot de RStudio Projects)*

#### Gráficos

Aquí aparecen los gráficos que realizamos con R. ¡En el capítulo *X* aprenderemos a crearlos!

#### Paquetes

Una de las cualidades de R a la que más hincapié hemos dado es su versatilidad. Su código libre hace que muchos desarrolladores se sientan atraídos a aportar a la comunidad de R con nuevas funcionalidades. En general, realizan esto a través de paquetes, que los usuarios pueden instalar como apéndices adicionales a R. Los paquetes contienen nuevas funciones, bases de datos, etcétera. La pestaña de RStudio aquí reseñada nos permite acceder a nuestros paquetes instalados.

Instalar un paquete es bastante simple, a través de la función `install.packages()`. A continuación vamos a instalar el paquete "tidyverse", central en nuestros próximos análisis. El tidyverse es una recopilación que incluye algunos de los mejores paquetes modernos para análisis de datos en R.


```r
install.packages("tidyverse")
```

Cada vez que el usuario abre una nueva sesión de R, este carga "como de fábrica". No solo sin objetos, sino que solo con los paquetes básicos que permiten a R funcionar. Tenemos que cargar los paquetes extra que queramos usar, entonces. Es más o menos como cuando compramos un *smartphone* y descargamos las aplicaciones que más usaremos, para que se ajuste a nuestras necesidades cotidianas. La forma más común de hacer esto es a través de la función `library()`, como se ve a continuación:


```r
library("tidyverse")
## ── Attaching packages ────────────────────────────────────────────────────────── tidyverse 1.2.1 ──
## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
## ✔ tibble  1.4.2     ✔ dplyr   0.7.8
## ✔ tidyr   0.8.2     ✔ stringr 1.3.1
## ✔ readr   1.2.0     ✔ forcats 0.3.0
## ── Conflicts ───────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

El lector puede ahorrarse el trabajo de instalar los paquetes utilizados en *AnalizaR Datos Políticos* en el futuro y hacerlo todo ahora, corriendo el siguiente súper comando. Ojo: ¡esto no lo salvará de cargar los paquetes en cada nueva sesión de R que inicie! Ojo 2: puede que esto le tome un tiempo considerable.

*paquetes a instalar*
*F: excelente que vamos a ofrecer esto, puede haber un paquete llamado ADP que tenga todo?*

#### Ayuda

Buscar ayuda es central a la hora de programar (y no solo de programar...). Esta pestaña de RStudio abre los archivos de ayuda que necesitemos, permitiéndonos buscar en ellos. Las funciones tienen archivos de ayuda para sí solas. Por ejemplo, podemos acceder al archivo de ayuda de la función `sqrt()` a través del comando `help(sqrt)`. Los paquetes en su conjunto también tienen archivos de ayuda, más comprensivos. Por ejemplo, para ver los archivos de ayuda del tidyverse solo debemos recurrir al argumento "package": `help(package = tidyverse)`. El lector debe notar que los archivos de ayuda de paquetes y funciones de paquetes solo están disponibles si el paquete ha sido cargado.

## Ejercicios

* ¿Qué significa "correr" un comando desde un script? ¿Cómo se hace?
* ¿Cuál es la media de los dígitos del hit de Rafaella Carrà, 0 3 0 3 4 5 6? ¿Y la mediana? Por último, órdenelos de mayor a menor.
* Busque ayuda para el paquete "googledrive". Recomendado: maravillarse con la variedad de los paquetes de R.
