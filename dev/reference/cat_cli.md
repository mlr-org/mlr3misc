# Function to transform message to output

Wrapper around
[`cli::cli_format_method()`](https://cli.r-lib.org/reference/cli_format_method.html).
Uses [`base::cat()`](https://rdrr.io/r/base/cat.html) to transform the
printout from a message to an output with a line break.

## Usage

``` r
cat_cli(expr)
```

## Arguments

- expr:

  (`any`)  
  Expression that calls `cli_*` methods,
  [`base::cat()`](https://rdrr.io/r/base/cat.html)
  or[`base::print()`](https://rdrr.io/r/base/print.html) to format an
  object's printout.

## Examples

``` r
cat_cli({
  cli::cli_h1("Heading")
  cli::cli_li(c("x", "y"))
})
#> 
#> ── Heading ─────────────────────────────────────────────────────────────────────
#> • x
#> • y
```
