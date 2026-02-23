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
#>  int [1:626] 10403 15 1654269195 -1877109783 -961256264 1403523942 124639233 261424787 1836448066 1034917620 ...
```
