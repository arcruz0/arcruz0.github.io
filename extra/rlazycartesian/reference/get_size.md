# Lazily get the total number of elements in a Cartesian product

This function lazily retrieves the total number of elements in a
Cartesian product

## Usage

``` r
get_size(lc)
```

## Arguments

- lc:

  A \`lazy_cartesian\` object.

## Value

A number.

## Examples

``` r
l <- list(color  = c("Red", "Blue", "Yellow"),
          shape  = c("Square", "Circle"),
          number = 1:3)

r <- list(
  restriction1 = list(color = "Red", shape = "Circle"),
  restriction2 = list(shape = "Square", number = c(1, 3))
)

lc_without_restrictions <- lazy_cartesian(l)
get_size(lc_without_restrictions)
#> [1] 18

lc_with_restrictions <- lazy_cartesian(l, r)
get_size(lc_with_restrictions)
#> [1] 9
```
