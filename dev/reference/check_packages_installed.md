# Check that packages are installed, without loading them

Calls [`find.package()`](https://rdrr.io/r/base/find.package.html) to
check if the all packages are installed.

## Usage

``` r
check_packages_installed(
  pkgs,
  warn = TRUE,
  msg = "The following packages are required but not installed: %s"
)
```

## Arguments

- pkgs:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Packages to check.

- warn:

  (`logical(1)`)  
  If `TRUE`, signals a warning of class `"packageNotFoundWarning"` about
  the missing packages.

- msg:

  (`character(1)`)  
  Format of the warning message. Use `"%s"` as placeholder for the list
  of packages.

## Value

([`logical()`](https://rdrr.io/r/base/logical.html)) named with package
names. `TRUE` if the respective package is installed, `FALSE` otherwise.

## Examples

``` r
check_packages_installed(c("mlr3misc", "foobar"), warn = FALSE)
#> mlr3misc   foobar 
#>     TRUE    FALSE 

# catch warning
tryCatch(check_packages_installed(c("mlr3misc", "foobaaar")),
  packageNotFoundWarning = function(w) as.character(w))
#> [1] "packageNotFoundWarning: The following packages are required but not installed: foobaaar\n"
```
