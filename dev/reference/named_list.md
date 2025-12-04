# Create a Named List

Create a Named List

## Usage

``` r
named_list(nn = character(0L), init = NULL)
```

## Arguments

- nn:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Names of new list.

- init:

  (`any`)  
  All list elements are initialized to this value.

## Value

(named [`list()`](https://rdrr.io/r/base/list.html)).

## Examples

``` r
named_list(c("a", "b"))
#> $a
#> NULL
#> 
#> $b
#> NULL
#> 
named_list(c("a", "b"), init = 1)
#> $a
#> [1] 1
#> 
#> $b
#> [1] 1
#> 
```
