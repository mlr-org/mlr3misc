# A Quick Way to Initialize Objects from Dictionaries with Incremented ID

Convenience wrapper around
[dictionary_sugar_get](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md)
and
[dictionary_sugar_mget](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md)
to allow easier avoidance of ID clashes which is useful when the same
object is used multiple times and the ids have to be unique. Let `<key>`
be the key of the object to retrieve. When passing the `<key>_<n>` to
this function, where `<n>` is any natural number, the object with key
`<key>` is retrieved and the suffix `_<n>` is appended to the id after
the object is constructed.

## Usage

``` r
dictionary_sugar_inc_get(dict, .key, ..., .dicts_suggest = NULL)

dictionary_sugar_inc_mget(dict, .keys, ..., .dicts_suggest = NULL)
```

## Arguments

- dict:

  ([Dictionary](https://mlr3misc.mlr-org.com/dev/reference/Dictionary.md))  
  Dictionary from which to retrieve an element.

- .key:

  (`character(1)`)  
  Key of the object to construct - possibly with a suffix of the form
  `_<n>` which will be appended to the id.

- ...:

  (`any`)  
  See description of
  [dictionary_sugar](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md).

- .dicts_suggest:

  (named [`list()`](https://rdrr.io/r/base/list.html)) Named list of
  [dictionaries](https://mlr3misc.mlr-org.com/dev/reference/Dictionary.md)
  used to look up suggestions for `.key` if `.key` does not exist in
  `dict`.

- .keys:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Keys of the objects to construct - possibly with suffixes of the form
  `_<n>` which will be appended to the ids.

## Value

An element from the dictionary.

## Examples

``` r
d = Dictionary$new()
d$add("a", R6::R6Class("A", public = list(id = "a")))
d$add("b", R6::R6Class("B", public = list(id = "c")))
obj1 = dictionary_sugar_inc_get(d, "a_1")
obj1$id
#> [1] "a_1"

obj2 = dictionary_sugar_inc_get(d, "b_1")
obj2$id
#> [1] "c_1"

objs = dictionary_sugar_inc_mget(d, c("a_10", "b_2"))
map(objs, "id")
#> $a_10
#> [1] "a_10"
#> 
#> $c_2
#> [1] "c_2"
#> 
```
