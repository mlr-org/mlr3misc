# Function for Formatted Output

Wrapper around [`base::cat()`](https://rdrr.io/r/base/cat.html) with a
line break. Elements are converted to character and concatenated with
[`base::paste0()`](https://rdrr.io/r/base/paste.html). If a vector is
passed, elements are collapsed with line breaks.

## Usage

``` r
catn(..., file = "")
```

## Arguments

- ...:

  (`any`)  
  Arguments passed down to
  [`base::paste0()`](https://rdrr.io/r/base/paste.html).

- file:

  (`character(1)`)  
  Passed to [`base::cat()`](https://rdrr.io/r/base/cat.html).

## Examples

``` r
catn(c("Line 1", "Line 2"))
#> Line 1
#> Line 2
```
