# Truncate Strings

`str_trunc()` truncates a string to a given width.

## Usage

``` r
str_trunc(str, width = 0.9 * getOption("width"), ellipsis = "[...]")
```

## Arguments

- str:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of strings.

- width:

  (`integer(1)`)  
  Width of the output.

- ellipsis:

  (`character(1)`)  
  If the string has to be shortened, this is signaled by appending
  `ellipsis` to `str`. Default is `"[...]"`.

## Value

([`character()`](https://rdrr.io/r/base/character.html)).

## Examples

``` r
str_trunc("This is a quite long string", 20)
#> [1] "This is a quite[...]"
```
