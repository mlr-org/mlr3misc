# Set the Class

Simple wrapper for `class(x) = classes`.

## Usage

``` r
set_class(x, classes)
```

## Arguments

- x:

  (`any`).

- classes:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of new class names.

## Value

Object `x`, with updated class attribute.

## Examples

``` r
set_class(list(), c("foo1", "foo2"))
#> list()
#> attr(,"class")
#> [1] "foo1" "foo2"
```
