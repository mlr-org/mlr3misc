# Assertion for Active Bindings in R6 Classes

This assertion is intended to be called in active bindings of an
[R6::R6Class](https://r6.r-lib.org/reference/R6Class.html) which does
not allow assignment. If `rhs` is not missing, an exception is raised.

## Usage

``` r
assert_ro_binding(rhs)
```

## Arguments

- rhs:

  (`any`)  
  If not missing, an exception is raised.

## Value

Nothing.
