# Modify Values of a Parameter Set

Convenience function to modify (or overwrite) the values of a
[paradox::ParamSet](https://paradox.mlr-org.com/reference/ParamSet.html).

## Usage

``` r
set_params(.ps, ..., .values = list(), .insert = TRUE)
```

## Arguments

- .ps:

  ([paradox::ParamSet](https://paradox.mlr-org.com/reference/ParamSet.html))  
  The parameter set whose values are changed.

- ...:

  (`any`) Named parameter values.

- .values:

  ([`list()`](https://rdrr.io/r/base/list.html)) Named list with
  parameter values.

- .insert:

  (`logical(1)`)  
  Whether to insert the values (old values are being kept, if not
  overwritten), or to discard the old values. Is TRUE by default.

## Examples

``` r
if (requireNamespace("paradox")) {
  param_set = paradox::ps(a = paradox::p_dbl(), b = paradox::p_dbl())
  param_set$values$a = 0
  set_params(param_set, a = 1, .values = list(b = 2), .insert = TRUE)
  set_params(param_set, a = 3, .insert = FALSE)
  set_params(param_set, b = 4, .insert = TRUE)
}
#> <ParamSet(2)>
#>        id    class lower upper nlevels        default  value
#>    <char>   <char> <num> <num>   <num>         <list> <list>
#> 1:      a ParamDbl  -Inf   Inf     Inf <NoDefault[0]>      3
#> 2:      b ParamDbl  -Inf   Inf     Inf <NoDefault[0]>      4
```
