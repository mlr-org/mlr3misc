# Require Multiple Namespaces

Packages are loaded (not attached) via
[`base::requireNamespace()`](https://rdrr.io/r/base/ns-load.html). If at
least on package can not be loaded, an exception of class
"packageNotFoundError" is raised. The character vector of missing
packages is stored in the condition as `packages`.

## Usage

``` r
require_namespaces(
  pkgs,
  msg = "The following packages could not be loaded: %s",
  quietly = FALSE
)
```

## Arguments

- pkgs:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Packages to load.

- msg:

  (`character(1)`)  
  Message to print on error. Use `"%s"` as placeholder for the list of
  packages.

- quietly:

  (`logical(1)`)  
  If `TRUE` then returns `TRUE` if all packages are loaded, otherwise
  `FALSE`.

## Value

([`character()`](https://rdrr.io/r/base/character.html)) of loaded
packages (invisibly).

## Examples

``` r
require_namespaces("mlr3misc")

# catch condition, return missing packages
tryCatch(require_namespaces(c("mlr3misc", "foobaaar")),
  packageNotFoundError = function(e) e$packages)
#> [1] "foobaaar"
```
