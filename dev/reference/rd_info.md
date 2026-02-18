# Helpers to Create Manual Pages

`rd_info()` is an internal generic to generate Rd or markdown code to be
used in manual pages. `rd_format_string()` and `rd_format_range()` are
string functions to assist generating proper Rd code.

## Usage

``` r
rd_info(obj, ...)

rd_format_range(lower, upper)

rd_format_string(str, quote = c("\\dQuote{", "}"))

rd_format_packages(packages)
```

## Arguments

- obj:

  (`any`)  
  Object of the respective class.

- ...:

  (`any)`)  
  Additional arguments.

- lower:

  (`numeric(1)`)  
  Lower bound.

- upper:

  (`numeric(1)`)  
  Upper bound.

- str:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of strings.

- quote:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Quotes to use around each element of `x`.

  Will be replicated to length 2.

- packages:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of package names.

## Value

[`character()`](https://rdrr.io/r/base/character.html), possibly with
markdown code.
