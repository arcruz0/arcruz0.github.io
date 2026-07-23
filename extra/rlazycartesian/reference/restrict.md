# Impose a restriction to a Cartesian product

An internal function that imposes a restriction to a Cartesian product

## Usage

``` r
restrict(l, restriction, v_each)
```

## Arguments

- l:

  A named list with the combinations for the Cartesian product.

- restriction:

  A named list that forms a restriction. The name of each element is a
  variable. The value of each element is a value or values in the
  variable. Multiple elements are joined via \`&\`.

- v_each:

  A vector with the times each variable's values should be repeated. See
  \`rlazycartesian:::restrict_multi()\`.
