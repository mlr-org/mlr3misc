# Get the Random Seed

Retrieves the current random seed (`.Random.seed` in the global
environment), and initializes the RNG first, if necessary.

## Usage

``` r
get_seed()
```

## Value

[`integer()`](https://rdrr.io/r/base/integer.html). Depends on the
[`base::RNGkind()`](https://rdrr.io/r/base/Random.html).

## Examples

``` r
str(get_seed())
#>  int [1:626] 10403 80 -2089519707 -1093835428 -1319683790 1392429101 -202324249 631843854 -539511320 1353072619 ...
```
