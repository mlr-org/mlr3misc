# Create a Named Vector

Creates a simple atomic vector with `init` as values.

## Usage

``` r
named_vector(nn = character(0L), init = NA)
```

## Arguments

- nn:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Names of new vector

- init:

  (`atomic`)  
  All vector elements are initialized to this value.

## Value

(named [`vector()`](https://rdrr.io/r/base/vector.html)).

## Examples

``` r
named_vector(c("a", "b"), NA)
#>  a  b 
#> NA NA 
named_vector(character())
#> named logical(0)
```
