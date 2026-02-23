# Index of the Minimum/Maximum Value, with Correction for Ties

Works similar to
[`base::which.min()`](https://rdrr.io/r/base/which.min.html)/[`base::which.max()`](https://rdrr.io/r/base/which.min.html),
but corrects for ties. Missing values are treated as `Inf` for
`which_min` and as `-Inf` for `which_max()`.

## Usage

``` r
which_min(x, ties_method = "random", na_rm = FALSE)

which_max(x, ties_method = "random", na_rm = FALSE)
```

## Arguments

- x:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html))  
  Numeric vector.

- ties_method:

  (`character(1)`)  
  Handling of ties. One of "first", "last" or "random" (default) to
  return the first index, the last index, or a random index of the
  minimum/maximum values.

- na_rm:

  (`logical(1)`)  
  Remove NAs before computation?

## Value

([`integer()`](https://rdrr.io/r/base/integer.html)): Index of the
minimum/maximum value. Returns an empty integer vector for empty input
vectors and vectors with no non-missing values (if `na_rm` is `TRUE`).
Returns `NA` if `na_rm` is `FALSE` and at least one `NA` is found in
`x`.

## Examples

``` r
x = c(2, 3, 1, 3, 5, 1, 1)
which_min(x, ties_method = "first")
#> [1] 3
which_min(x, ties_method = "last")
#> [1] 7
which_min(x, ties_method = "random")
#> [1] 3

which_max(x)
#> [1] 5
which_max(integer(0))
#> integer(0)
which_max(NA)
#> [1] NA
which_max(c(NA, 1))
#> [1] NA
```
