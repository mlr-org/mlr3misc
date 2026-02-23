# Extract Variables from a Formula

Given a [`formula()`](https://rdrr.io/r/stats/formula.html) `f`, returns
all variables used on the left-hand side and right-hand side of the
formula.

## Usage

``` r
extract_vars(f)
```

## Arguments

- f:

  ([`formula()`](https://rdrr.io/r/stats/formula.html)).

## Value

([`list()`](https://rdrr.io/r/base/list.html)) with elements `"lhs"` and
`"rhs"`, both [`character()`](https://rdrr.io/r/base/character.html).

## Examples

``` r
extract_vars(Species ~ Sepal.Width + Sepal.Length)
#> $lhs
#> [1] "Species"
#> 
#> $rhs
#> [1] "Sepal.Width"  "Sepal.Length"
#> 
extract_vars(Species ~ .)
#> $lhs
#> [1] "Species"
#> 
#> $rhs
#> [1] "."
#> 
```
