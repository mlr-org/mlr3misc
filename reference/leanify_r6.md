# Move all methods of an R6 Class to an environment

`leanify_r6` moves the content of an
[`R6::R6Class`](https://r6.r-lib.org/reference/R6Class.html)'s functions
to an environment, usually the package's namespace, to save space during
serialization of R6 objects. `leanify_package` move all methods of *all*
R6 Classes to an environment.

The function in the class (i.e. the object generator) is replaced by a
stump function that does nothing except calling the original function
that now resides somewhere else.

It is possible to call this function after the definition of an
[R6::R6](https://r6.r-lib.org/reference/R6Class.html) class inside a
package, but it is preferred to use `leanify_package()` to just leanify
all [R6::R6](https://r6.r-lib.org/reference/R6Class.html) classes inside
a package.

## Usage

``` r
leanify_r6(cls, env = cls$parent_env)

leanify_package(pkg_env = parent.frame(), skip_if = function(x) FALSE)
```

## Arguments

- cls:

  ([R6::R6Class](https://r6.r-lib.org/reference/R6Class.html))  
  Class generator to modify.

- env:

  (`environment`)  
  The target environment where the function should be stored. This
  should be either `cls$parent_env` (default) or one of its parent
  environments, otherwise the stump function will not find the moved
  (original code) function.

- pkg_env:

  :: `environment`  
  The namespace from which to leanify all R6 classes. Does not have to
  be a package namespace, but this is the intended usecase.

- skip_if:

  :: `function`  
  Function with one argument: Is called for each individual
  [`R6::R6Class`](https://r6.r-lib.org/reference/R6Class.html). If it
  returns `TRUE`, the class is skipped. Default function evaluating to
  `FALSE` always (i.e. skipping no classes).

## Value

`NULL`.
