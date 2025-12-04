# Check if an Object is Element of a List

Simply checks if a list contains a given object.

- NB1: Objects are compared with identity.

- NB2: Only use this on lists with complex objects, for simpler
  structures there are faster operations.

- NB3: Clones of R6 objects are not detected.

## Usage

``` r
has_element(.x, .y)
```

## Arguments

- .x:

  ([`list()`](https://rdrr.io/r/base/list.html) \| atomic
  [`vector()`](https://rdrr.io/r/base/vector.html)).

- .y:

  (`any`)  
  Object to test for.

## Examples

``` r
has_element(list(1, 2, 3), 1)
#> [1] TRUE
```
