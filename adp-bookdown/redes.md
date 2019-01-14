
# Análisis de redes {#redes}
*Por Andrés Cruz Labrín*

***

**Lecturas de referencia**

- Newman, M. (2018). *Networks: An Introduction* (2a ed). New York, NY: Oxford University Press.

- Scott, J. (2013). *Social Network Analysis* (3a ed). London: Sage Publications.


***

## Introducción

No es exagerado decir que en política todo está conectado con todo lo demás. Como ejemplo, fíjemonos en el caso de los legisladores. Entre ellos, las conexiones son evidentes: partidos, coaliciones, comisiones, familias, colegios... Para comprender mejor estas enmarañadas relaciones, una de las nuevas herramientas que está en el cinturón de herramientas de los politólogos es la del análisis de redes. Las redes son capaces de reconocer que todo está conectado con todo, y dar pistas sobre la lógica detrás de esas conexiones. No solo permiten visualizar de forma atractiva dichas conexiones, sino que también calcular distintas mediciones interesantes sobre los actores en cuestión y los vínculos que los unen. En este capítulo aprenderás las bases del análisis de redes con R, principalmente utilizando los paquetes `tidygraph` y `ggraph`, que se aproximan al análisis de redes desde los preceptos del `tidyverse`.

## Conceptos básicos de redes

### Nodos y enlaces

Dos conceptos son básicos para comenzar a expresar una situación como una red. En primer lugar, los *nodos* (a veces llamados sitios o actores) son las unidades de análisis principales: queremos entender cómo se relacionan entre sí. En el ejemplo de los legisladores, ellos serían los nodos de la red. Segundo, los enlaces (a veces llamadas conexiones o vínculos) muestran cómo los nodos están conectados unos con otros. Entre los legisladores, una forma de enlace posible es "haber propuesto una ley juntos", también llamado co-presentación (*co-sponsorship*).

Una red no es más que una serie de nodos conectados a través de enlaces, como se puede apreciar en la Figura X. En términos del ejemplo anterior, podemos imaginar que dicha red grafica cómo se conectan los legisladores A, B, C, D (los nodos) según su co-presentación w, x, y, z (los enlaces). Así, la red muestra que el legislador B ha presentado al menos un proyecto de ley con todos los demás legisladores de la red, mientras que el legislador D solo lo ha hecho con B. Por su lado, los legisladores A y C tienen dos enlaces de co-presentación cada uno, formando una tríada A-B-C.







<img src="redes_files/figure-html/unnamed-chunk-4-1.png" width="288" style="display: block; margin: auto;" />



### Matriz de adyacencia

Aparte de una descripción visual, como la de la Figura X, es también posible representar las redes como *matrices de adyacencia*. La Tabla 1 representa la misma red de la Figura 1, esta vez en formato matriz. Los 1 indican que existe un enlace entre ambos nodos (de co-presentación, en nuestro ejemplo), mientras que los 0 indican lo contrario. Nota cómo la diagonal de la matriz está llenada solo por unos: esta es una convención útil para distintos cálculos matemáticos. Adicionalmente, este tipo de matriz para una red básica es simétrica: si sabemos que el nodo A está enlazado con el nodo B, automáticamente sabemos que el nodo B está enlazado con el A.

$$
\begin{array}{rrrr}
 & \text{A} & \text{B} & \text{C} & \text{D}\\
\text{A} & 1 & 1 & 1 & 0 \\
\text{B} & 1 & 1 & 1 & 1 \\
\text{C} & 1 & 1 & 1 & 0 \\
\text{D} & 0 & 1 & 0 & 1
\end{array}
$$

<!-- ¿Valdrá la pena tener algo sobre matrices one-mode y two-mode? -->

### Pesos y dirección

Una red tan básica como la vista hasta ahora puede complejizarse bastante más, de acuerdo a la naturaleza de los datos. Dos complejizaciones típicas refieren a los enlaces: añadir pesos y dirección. Para comenzar con los pesos, en nuestro ejemplo los legisladores están conectados si es que *alguna vez* han presentado un proyecto de ley en conjunto. Sin embargo, a menudo es de interés no solo conocer la existencia de una conexión entre dos actores, sino que también la fuerza de esta: no es lo mismo que dos legisladores hayan aceptado con reticencia presentar un proyecto juntos en una ocasión, a que hayan presentado decenas de proyectos de ley en conjunto. Volvamos a la matriz de adyacencia, esta vez incluyendo pesos. En este pequeño ejemplo, los legisladores A y B han presentado 10 proyectos de ley juntos. Nota cómo, por convención, la diagonal de la matriz sigue llena de unos.

$$
\begin{array}{rrrr}
 & \text{A} & \text{B} & \text{C} & \text{D}\\
\text{A} & 1 & 10 & 1 & 0 \\
\text{B} & 10 & 1 & 1 & 6 \\
\text{C} & 1 & 1 & 1 & 0 \\
\text{D} & 0 & 6 & 0 & 1
\end{array}
$$

La segunda forma de añadir información adicional a los enlaces es registrando su dirección. En algunas legislaturas los proyectos de ley tienen un autor o autora principal (sponsor), a quien el resto de los legisladores se suman (co-sponsor). En estos casos, la red de co-sponsorship naturalmente tendrá dirección: un legislador "auspiciará" a otro firmando en su proyecto de ley, sin que esta relación sea necesariamente recíproca. Es posible incluir esta información en la red, tal como realiza Fowler (2006) para el Congreso de Estados Unidos. Una matriz de adyacencia con direcciones (y pesos) podría verse como la que sigue. Nota que ahora el matriz no es simétrica, pues existe más información sobre la relación de co-sponsorship entre los legisladores A y B: mientras que el legislador A auspició ocho proyectos del legislador B, este solo reciprocó en dos proyectos de ley.

$$
\begin{array}{rrrr}
 & \text{A} & \text{B} & \text{C} & \text{D}\\
\text{A} & 1 & 8 & 1 & 0 \\
\text{B} & 2 & 1 & 1 & 6 \\
\text{C} & 1 & 1 & 1 & 0 \\
\text{D} & 0 & 6 & 0 & 1
\end{array}
$$

## Generar una base de datos de redes

Siguiendo con el espíritu del ejemplo anterior, en este capítulo trabajaremos con datos de co-sponsorship de leyes en el Senado argentino. Utilizaremos los datos de Alemán et al. (2009), en específico para el año 2006. Comencemos cargando la base de datos:


```r
library(readr)
datos_cosp_arg <- read_rds("00-datos/cosponsorship_arg_sen2006.rds")
```


**PENDIENTE**

## Disposición de los puntos en el espacio

**PENDIENTE**

## Calcular medidas de centralidad básicas

**PENDIENTE**

## Detectar comunidades en las redes

**PENDIENTE**

## Referencias

- Alemán, E., Calvo, E., Jones, M. P., & Kaplan, N. (2009). Comparing Cosponsorship and Roll‐Call Ideal Points. *Legislative Studies Quarterly, 34*(1), 87-116.

- Fowler, J. H. (2006). Connecting the Congress: A study of cosponsorship networks. *Political Analysis, 14*(4), 456-487.
