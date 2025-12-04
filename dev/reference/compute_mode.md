# Compute The Mode

Computes the mode (most frequent value) of an atomic vector.

## Usage

``` r
compute_mode(x, ties_method = "random", na_rm = TRUE)
```

## Arguments

- x:

  ([`vector()`](https://rdrr.io/r/base/vector.html)).

- ties_method:

  (`character(1)`)  
  Handling of ties. One of "first", "last" or "random" to return the
  first tied value, the last tied value, or a randomly selected tied
  value, respectively.

- na_rm:

  (`logical(1)`)  
  If `TRUE`, remove missing values prior to computing the mode.

## Value

(`vector(1)`): mode value.

## Examples

``` r
compute_mode(c(1, 1, 1, 2, 2, 2, 3))
#> [1] 1
compute_mode(c(1, 1, 1, 2, 2, 2, 3), ties_method = "last")
#> [1] 2
compute_mode(c(1, 1, 1, 2, 2, 2, 3), ties_method = "random")
#> [1] 1
```
