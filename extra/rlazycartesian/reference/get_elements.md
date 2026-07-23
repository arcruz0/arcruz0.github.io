# Lazily retrieve elements from a Cartesian product

This function lazily retrieves elements from a Cartesian product, given
a vector of indices.

## Usage

``` r
get_elements(lc, indices, index_colname = ".element")
```

## Arguments

- lc:

  A `lazy_cartesian` object, created with
  [`rlazycartesian::lazy_cartesian()`](lazy_cartesian.md).

- indices:

  A numeric vector with indices of the elements to retrieve.

- index_colname:

  A string with the column name for the indices in the output data
  frame. By default, ".element".

## Value

A data frame in which each row is an element from the Cartesian product.

## References

Burdsall, T. (2018). `lazy-cartesian-product`: .hpp library to
efficiently generate combinations using the Lazy Cartesian Product
algorithm. <https://github.com/tylerburdsall/lazy-cartesian-product>

## Examples

``` r
l <- list(color  = c("Red", "Blue", "Yellow"),
          shape  = c("Square", "Circle"),
          number = 1:3)

r <- list(
  restriction1 = list(color = "Red", shape = "Circle"),
  restriction2 = list(shape = "Square", number = c(1, 3))
)

lc <- lazy_cartesian(l, r)
get_elements(lc, c(2, 8))
#>   .element color  shape number
#> 1        2   Red Square      2
#> 2        8  Blue Square      2
```
