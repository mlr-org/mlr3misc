# Count Missing Values in a Vector

Same as `sum(is.na(x))`, but without the allocation.

## Usage

``` r
count_missing(x)
```

## Arguments

- x:

  [`vector()`](https://rdrr.io/r/base/vector.html)  
  Supported are logical, integer, double, complex and string vectors.

## Value

(`integer(1)`) number of missing values.

## Examples

``` r
count_missing(c(1, 2, NA, 4, NA))
#> [1] 2
```
