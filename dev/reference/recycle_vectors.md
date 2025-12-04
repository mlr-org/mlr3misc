# Recycle List of Vectors to Common Length

Repeats all vectors of a list `.x` to the length of the longest vector
using [`rep()`](https://rdrr.io/r/base/rep.html) with argument
`length.out`. This operation will only work if the length of the longest
vectors is an integer multiple of all shorter vectors, and will throw an
exception otherwise.

## Usage

``` r
recycle_vectors(.x)
```

## Arguments

- .x:

  ([`list()`](https://rdrr.io/r/base/list.html)).

## Value

([`list()`](https://rdrr.io/r/base/list.html)) with vectors of same
size.

## Examples

``` r
recycle_vectors(list(a = 1:3, b = 2))
#> $a
#> [1] 1 2 3
#> 
#> $b
#> [1] 2 2 2
#> 
```
