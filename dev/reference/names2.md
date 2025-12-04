# A Type-Stable names() Replacement

A simple wrapper around
[`base::names()`](https://rdrr.io/r/base/names.html). Returns a
character vector even if no names attribute is set. Values `NA` and `""`
are treated as missing and replaced with the value provided in
`missing_val`.

## Usage

``` r
names2(x, missing_val = NA_character_)
```

## Arguments

- x:

  (`any`)  
  Object.

- missing_val:

  (`atomic(1)`)  
  Value to set for missing names. Default is `NA_character_`.

## Value

(`character(length(x))`).

## Examples

``` r
x = 1:3
names(x)
#> NULL
names2(x)
#> [1] NA NA NA

names(x)[1:2] = letters[1:2]
names(x)
#> [1] "a" "b" NA 
names2(x, missing_val = "")
#> [1] "a" "b" "" 
```
