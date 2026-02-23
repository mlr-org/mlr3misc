# Assign Value to Private Field

Convenience function to assign a value to a private field of an
[R6::R6Class](https://r6.r-lib.org/reference/R6Class.html) instance.

## Usage

``` r
get_private(x, which) <- value
```

## Arguments

- x:

  (`any`)  
  Object whose private field should be modified.

- which:

  (character(1))  
  Private field that is being modified.

- value:

  (`any`)  
  Value to assign to the private field.

## Value

The R6 instance x, modified in-place. If it is not an R6 instance, NULL
is returned.

## Examples

``` r
library(R6)
item = R6Class("Item", private = list(x = 1))$new()
get_private(item)$x
#> [1] 1
get_private(item, "x") = 2L
get_private(item)$x
#> [1] 2
```
