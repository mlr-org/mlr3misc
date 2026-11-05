# Collapse Strings

Collapse multiple strings into a single string.

## Usage

``` r
str_collapse(str, sep = ", ", quote = character(), n = Inf, ellipsis = "[...]")
```

## Arguments

- str:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of strings.

- sep:

  (`character(1)`)  
  String used to collapse the elements of `str`.

- quote:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Quotes to use around each element of `str`.

  Will be replicated to length 2.

- n:

  (`integer(1)`)  
  Number of elements to keep from `str`. See
  [`utils::head()`](https://rdrr.io/r/utils/head.html).

- ellipsis:

  (`character(1)`)  
  If the string has to be shortened, this is signaled by appending
  `ellipsis` to `str`. Default is `"[...]"`.

## Value

(`character(1)`).

## Examples

``` r
str_collapse(letters, quote = "'", n = 5)
#> [1] "'a', 'b', 'c', 'd', 'e', [...]"
```
