# Logical Check Operators

Logical AND and OR operators for `check_*`-functions from
[`checkmate`](https://mllg.github.io/checkmate/reference/checkmate-package.html).

## Usage

``` r
lhs %check&&% rhs

lhs %check||% rhs
```

## Arguments

- lhs, rhs:

  (`function()`)  
  `check_*`-functions that return either `TRUE` or an error message as a
  `character(1)`.

## Value

Either `TRUE` or a `character(1)`.

## Examples

``` r
library(checkmate)

x = c(0, 1, 2, 3)
check_numeric(x) %check&&% check_names(names(x), "unnamed")  # is TRUE
#> [1] TRUE
check_numeric(x) %check&&% check_true(all(x < 0))  # fails
#> [1] "Must be TRUE"

check_numeric(x) %check||% check_character(x)  # is TRUE
#> [1] TRUE
check_number(x) %check||% check_flag(x)  # fails
#> [1] "Must have length 1, or Must be of type 'logical flag', not 'double'"
```
