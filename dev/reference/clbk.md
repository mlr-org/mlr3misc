# Syntactic Sugar for Callback Construction

Functions to retrieve callbacks from
[mlr_callbacks](https://mlr3misc.mlr-org.com/dev/reference/mlr_callbacks.md)
and set parameters in one go.

## Usage

``` r
clbk(.key, ...)

clbks(.keys)
```

## Arguments

- .key:

  (`character(1)`)  
  Key of the object to construct.

- ...:

  (named [`list()`](https://rdrr.io/r/base/list.html))  
  Named arguments passed to the state of the callback.

- .keys:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Keys of the objects to construct.

## See also

Callback call_back
