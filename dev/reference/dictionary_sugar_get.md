# A Quick Way to Initialize Objects from Dictionaries

Given a
[Dictionary](https://mlr3misc.mlr-org.com/dev/reference/Dictionary.md),
retrieve objects with provided keys.

- `dictionary_sugar_get()` to retrieve a single object with key `.key`.

- `dictionary_sugar_mget()` to retrieve a list of objects with keys
  `.keys`.

- `dictionary_sugar()` is deprecated in favor of
  `dictionary_sugar_get()`.

- If `.key` or `.keys` is missing, the dictionary itself is returned.

Arguments in `...` must be named and are consumed in the following
order:

1.  All arguments whose names match the name of an argument of the
    constructor are passed to the `$get()` method of the
    [Dictionary](https://mlr3misc.mlr-org.com/dev/reference/Dictionary.md)
    for construction.

2.  All arguments whose names match the name of a parameter of the
    [paradox::ParamSet](https://paradox.mlr-org.com/reference/ParamSet.html)
    of the constructed object are set as parameters. If there is no
    [paradox::ParamSet](https://paradox.mlr-org.com/reference/ParamSet.html)
    in `obj$param_set`, this step is skipped.

3.  All remaining arguments are assumed to be regular fields of the
    constructed R6 instance, and are assigned via `<-`.

## Usage

``` r
dictionary_sugar_get(dict, .key, ..., .dicts_suggest = NULL)

dictionary_sugar(dict, .key, ..., .dicts_suggest = NULL)

dictionary_sugar_mget(dict, .keys, ..., .dicts_suggest = NULL)
```

## Arguments

- dict:

  ([Dictionary](https://mlr3misc.mlr-org.com/dev/reference/Dictionary.md)).

- .key:

  (`character(1)`)  
  Key of the object to construct.

- ...:

  (`any`)  
  See description.

- .dicts_suggest:

  (named [`list()`](https://rdrr.io/r/base/list.html)) Named list of
  [dictionaries](https://mlr3misc.mlr-org.com/dev/reference/Dictionary.md)
  used to look up suggestions for `.key` if `.key` does not exist in
  `dict`.

- .keys:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Keys of the objects to construct.

## Value

[`R6::R6Class()`](https://r6.r-lib.org/reference/R6Class.html)

## Examples

``` r
library(R6)
item = R6Class("Item", public = list(x = 0))
d = Dictionary$new()
d$add("key", item)
dictionary_sugar_get(d, "key", x = 2)
#> <Item>
#>   Public:
#>     clone: function (deep = FALSE) 
#>     x: 2
```
