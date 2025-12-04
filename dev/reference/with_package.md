# Execture code with a modified search path

Attaches a package to the search path (if not already attached),
executes code and eventually removes the package from the search path
again, restoring the previous state.

Note that this function is deprecated in favor of the (now fixed)
version in [withr](https://CRAN.R-project.org/package=withr).

## Usage

``` r
with_package(package, code, ...)
```

## Arguments

- package:

  (`character(1)`)  
  Name of the package to attach.

- code:

  (`expression`)  
  Code to run.

- ...:

  (`any`)  
  Additional arguments passed to
  [`library()`](https://rdrr.io/r/base/library.html).

## Value

Result of the evaluation of `code`.

## See also

[withr](https://CRAN.R-project.org/package=withr) package.
