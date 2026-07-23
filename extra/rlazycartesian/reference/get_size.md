# Lazily get the total number of elements in a Cartesian product

This function lazily retrieves the total number of elements in a
Cartesian product

## Usage

``` r
get_size(l)
```

## Arguments

- l:

  A named list with the combinations of the Cartesian product.

## Value

A number.

## Examples

``` r
l <- list(color = c("Red", "Blue", "Yellow"),
          shape = c("Square", "Circle"))

get_size(l)
#> [1] 6
```
