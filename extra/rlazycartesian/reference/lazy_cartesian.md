# Create a `lazy_cartesian` object

This function creates a `lazy_cartesian` object, with possible
restrictions.

## Usage

``` r
lazy_cartesian(l, restrictions = NULL)
```

## Arguments

- l:

  A named list with the combinations of the Cartesian product.

- restrictions:

  A list of lists with restrictions. Defaults to NULL. See Examples
  below.

## Value

A `lazy_cartesian` object.

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

lc_without_restrictions <- lazy_cartesian(l)
lc_without_restrictions
#> `lazy_cartesian` object with 18 elements

lc_with_restrictions <- lazy_cartesian(l, r)
lc_with_restrictions
#> `lazy_cartesian` object with 9 elements (after restrictions)
#>   => 2 restrictions excluded 50% of the Cartesian Product 
#>      (which originally had 18 elements)
```
