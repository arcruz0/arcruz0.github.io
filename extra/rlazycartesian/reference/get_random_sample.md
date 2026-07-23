# Lazily get random sample from a Cartesian product

This function lazily retrieves a random sample from a Cartesian product,
respecting restrictions.

## Usage

``` r
get_random_sample(lc, n_sample, index_colname = ".element")
```

## Arguments

- lc:

  A `lazy_cartesian` object, created with
  [`rlazycartesian::lazy_cartesian()`](lazy_cartesian.md).

- n_sample:

  An integer with the number of elements to be sampled.

- index_colname:

  A string with the column name for the indices in the output data
  frame. By default, ".element".

## Value

A data frame in which each row is an element from the (potentially
restricted) Cartesian product. Indices are in the first column and
correspond to the unrestricted Cartesian product (i.e., they go from 1
to n_ur).

## References

Burdsall, T. (2018). `lazy-cartesian-product`: .hpp library to
efficiently generate combinations using the Lazy Cartesian Product
algorithm. <https://github.com/tylerburdsall/lazy-cartesian-product>

## Examples

``` r
l <- list(color  = c("Red", "Blue", "Yellow"),
          shape  = c("Square", "Circle"),
          number = 1:3)
          
lc <- lazy_cartesian(l)

get_random_sample(lc, 3L)
#>   .element  color  shape number
#> 1       13 Yellow Square      1
#> 2       12   Blue Circle      3
#> 3       15 Yellow Square      3
```
