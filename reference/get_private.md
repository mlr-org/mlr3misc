# Extract Private Fields of R6 Objects

Provides access to the private members of
[R6::R6Class](https://r6.r-lib.org/reference/R6Class.html) objects.

## Usage

``` r
get_private(x)
```

## Arguments

- x:

  (`any`)  
  Object to extract the private members from.

## Value

[`environment()`](https://rdrr.io/r/base/environment.html) of private
members, or `NULL` if `x` is not an R6 object.

## Examples

``` r
library(R6)
item = R6Class("Item", private = list(x = 1))$new()
get_private(item)$x
#> [1] 1
```
