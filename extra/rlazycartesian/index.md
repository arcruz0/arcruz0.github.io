# `rlazycartesian`

[\[**Documentation**\]](https://arcruz0.github.io/extra/rlazycartesian/)

An R interface for Lazy Cartesian Products. Provides memory-efficient
ways to obtain elements (including random samples) from Cartesian
Products. Partial wrapper of the
[`lazy-cartesian-product`](https://github.com/tylerburdsall/lazy-cartesian-product)
C++ library (Burdsall, 2018).

## Installation

``` r

install.packages("remotes") # if not installed
remotes::install_github("arcruz0/rlazycartesian")
```

## Example

Suppose you need a random sample of 1,000 elements from a Cartesian
Product of 125M elements. `rlazycartesian` can do this without
generating all elements in advance (as
[`expand.grid()`](https://rdrr.io/r/base/expand.grid.html) would do).
This makes it so that the operation is fast and consumes very little
RAM—see [Benchmarks](#benchmarks) below.

``` r

library(rlazycartesian)

l <- list(x = paste0("x", 1:500, sep = ""),
          y = paste0("y", 1:500, sep = ""),
          z = paste0("z", 1:500, sep = ""))

lc <- lazy_cartesian(l)
lc
#> `lazy_cartesian` object with 1.25e+08 elements
```

``` r

set.seed(1)
head(get_random_sample(lc, 1000))
#>   .element    x    y    z
#> 1 66608964 x267 y218 z464
#> 2 44492929 x178 y486 z429
#> 3 60941821 x244 y384 z321
#> 4 30845227 x124 y191 z227
#> 5 17633234  x71 y267 z234
#> 6 79310131 x318 y121 z131
```

## A note on element indices and `expand.grid()`

Element indices from `rlazycartesian` are equivalent to indices from a
sorted [`expand.grid()`](https://rdrr.io/r/base/expand.grid.html):

``` r

get_elements(lc, c(12345, 98765))
#>   .element  x    y    z
#> 1    12345 x1  y25 z345
#> 2    98765 x1 y198 z265

eg <- expand.grid(l)
eg <- eg[order(eg$x, eg$y, eg$z),]
rownames(eg) <- NULL
eg[c(12345, 98765),]
#>        x    y    z
#> 12345 x1  y25 z345
#> 98765 x1 y198 z265
```

## Benchmarks

For the random sample example above, compare performance
(`Elapsed_Time_sec`) and peak RAM usage (`Peak_RAM_Used_MiB`):

``` r

peakRAM::peakRAM(
  {lc <- lazy_cartesian(l); get_random_sample(lc, 1000)},
  {eg <- expand.grid(l); eg[sample(1:nrow(eg), 1000),]}
)
#>                                       Function_Call Elapsed_Time_sec
#> 1 {lc<-lazy_cartesian(l)get_random_sample(lc,1000)}            0.002
#> 2  {eg<-expand.grid(l)eg[sample(1:nrow(eg),1000),]}            4.332
#>   Total_RAM_Used_MiB Peak_RAM_Used_MiB
#> 1                  0               0.2
#> 2                  0            2862.1
```

## Restrictions to the Cartesian product

Starting in v0.2, `rlazycartesian` supports simple restrictions to the
Cartesian product. For example, suppose that in the following Cartesian
product we want to exclude any elements with “Red” and “Circle,” as well
as any elements with “Square” and the numbers 1 or 3:

``` r

l <- list(color  = c("Red", "Blue", "Yellow"),
          shape  = c("Square", "Circle"),
          number = 1:3)

r <- list(
  restriction1 = list(color = "Red", shape = "Circle"),
  restriction2 = list(shape = "Square", number = c(1, 3))
)

lc <- lazy_cartesian(l, restrictions = r)
lc
#> `lazy_cartesian` object with 9 elements (after restrictions)
#>   => 2 restrictions excluded 50% of the Cartesian Product 
#>      (which originally had 18 elements)
```

``` r

get_random_sample(lc, 9) # (note element indices still go up to 18)
#>   .element  color  shape number
#> 1       17 Yellow Circle      2
#> 2       16 Yellow Circle      1
#> 3        8   Blue Square      2
#> 4       18 Yellow Circle      3
#> 5       10   Blue Circle      1
#> 6       12   Blue Circle      3
#> 7       14 Yellow Square      2
#> 8       11   Blue Circle      2
#> 9        2    Red Square      2
```

## References

Burdsall, T. (2018). `lazy-cartesian-product`: .hpp library to
efficiently generate combinations using the Lazy Cartesian Product
algorithm. <https://github.com/tylerburdsall/lazy-cartesian-product>
