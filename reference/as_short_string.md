# Convert R Object to a Descriptive String

This function is intended to convert any R object to a short descriptive
string, e.g. in [`base::print()`](https://rdrr.io/r/base/print.html)
functions.

The following rules apply:

- if `x` is `atomic()` with length 0 or 1: printed as-is.

- if `x` is `atomic()` with length greater than 1, `x` is collapsed with
  `","`, and the resulting string is truncated to `trunc_width`
  characters.

- if `x` is an expression: converted to character.

- Otherwise: the class is printed.

If `x` is a list, the above rules are applied (non-recursively) to its
elements.

## Usage

``` r
as_short_string(x, width = 30L, num_format = "%.4g")
```

## Arguments

- x:

  (`any`)  
  Arbitrary object.

- width:

  (`integer(1)`)  
  Truncate strings to width `width`.

- num_format:

  (`character(1)`)  
  Used to format numerical scalars via
  [`base::sprintf()`](https://rdrr.io/r/base/sprintf.html).

## Value

(`character(1)`).

## Examples

``` r
as_short_string(list(a = 1, b = NULL, "foo", c = 1:10))
#> [1] "a=1, b=<NULL>, <unnamed>=foo, c=1,2,3,4,5,6,7,8,9,10"
```
