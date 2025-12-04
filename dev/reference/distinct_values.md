# Get Distinct Values

Extracts the distinct values of an atomic vector, with the possibility
to drop levels and remove missing values.

## Usage

``` r
distinct_values(x, drop = TRUE, na_rm = TRUE)
```

## Arguments

- x:

  (atomic [`vector()`](https://rdrr.io/r/base/vector.html)).

- drop:

  :: `logical(1)`  
  If `TRUE`, only returns values which are present in `x`. If `FALSE`,
  returns all levels for
  [`factor()`](https://rdrr.io/r/base/factor.html) and
  [`ordered()`](https://rdrr.io/r/base/factor.html), as well as `TRUE`
  and `FALSE` for [`logical()`](https://rdrr.io/r/base/logical.html)s.

- na_rm:

  :: `logical(1)`  
  If `TRUE`, missing values are removed from the vector of distinct
  values.

## Value

(atomic [`vector()`](https://rdrr.io/r/base/vector.html)) with distinct
values in no particular order.

## Examples

``` r
# for factors:
x = factor(c(letters[1:2], NA), levels = letters[1:3])
distinct_values(x)
#> [1] "a" "b"
distinct_values(x, na_rm = FALSE)
#> [1] "a" "b" NA 
distinct_values(x, drop = FALSE)
#> [1] "a" "b" "c"
distinct_values(x, drop = FALSE, na_rm = FALSE)
#> [1] "a" "b" "c" NA 

# for logicals:
distinct_values(TRUE, drop = FALSE)
#> [1]  TRUE FALSE

# for numerics:
distinct_values(sample(1:3, 10, replace = TRUE))
#> [1] 1 3 2
```
