# Extract ids from a List of Objects

None.

## Usage

``` r
ids(xs)
```

## Arguments

- xs:

  ([`list()`](https://rdrr.io/r/base/list.html))  
  Every element must have a slot 'id'.

## Value

([`character()`](https://rdrr.io/r/base/character.html)).

## Examples

``` r
xs = list(a = list(id = "foo", a = 1), bar = list(id = "bar", a = 2))
ids(xs)
#> [1] "foo" "bar"
```
