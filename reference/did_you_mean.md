# Suggest Alternatives

Helps to suggest alternatives from a list of strings, based on the
string similarity in
[`utils::adist()`](https://rdrr.io/r/utils/adist.html).

## Usage

``` r
did_you_mean(str, candidates)
```

## Arguments

- str:

  (`character(1)`)  
  String.

- candidates:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Candidate strings.

## Value

(`character(1)`). Either a phrase suggesting one or more candidates from
`candidates`, or an empty string if no close match is found.

## Examples

``` r
did_you_mean("yep", c("yes", "no"))
#> [1] " Did you mean 'yes'?"
```
