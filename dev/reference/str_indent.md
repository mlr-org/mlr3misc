# Indent Strings

Formats a text block for printing.

## Usage

``` r
str_indent(initial, str, width = 0.9 * getOption("width"), exdent = 2L, ...)
```

## Arguments

- initial:

  (`character(1)`)  
  Initial string, passed to
  [`strwrap()`](https://rdrr.io/r/base/strwrap.html).

- str:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of strings.

- width:

  (`integer(1)`)  
  Width of the output.

- exdent:

  (`integer(1)`)  
  Indentation of subsequent lines in paragraph.

- ...:

  (`any`)  
  Additional parameters passed to
  [`str_collapse()`](https://mlr3misc.mlr-org.com/dev/reference/str_collapse.md).

## Value

([`character()`](https://rdrr.io/r/base/character.html)).

## Examples

``` r
cat(str_indent("Letters:", str_collapse(letters), width = 25), sep = "\n")
#> Letters: a, b, c, d, e,
#>   f, g, h, i, j, k, l,
#>   m, n, o, p, q, r, s,
#>   t, u, v, w, x, y, z
```
