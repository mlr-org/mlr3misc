# Invoke a Function Call

An alternative interface for
[`do.call()`](https://rdrr.io/r/base/do.call.html), similar to the
deprecated function in purrr. This function tries hard to not evaluate
the passed arguments too eagerly which is important when working with
large R objects.

It is recommended to pass all arguments named in order to not rely on
positional argument matching.

## Usage

``` r
invoke(
  .f,
  ...,
  .args = list(),
  .opts = list(),
  .seed = NA_integer_,
  .timeout = Inf
)
```

## Arguments

- .f:

  (`function()`)  
  Function to call.

- ...:

  (`any`)  
  Additional function arguments passed to `.f`.

- .args:

  ([`list()`](https://rdrr.io/r/base/list.html))  
  Additional function arguments passed to `.f`, as (named)
  [`list()`](https://rdrr.io/r/base/list.html). These arguments will be
  concatenated to the arguments provided via `...`.

- .opts:

  (named [`list()`](https://rdrr.io/r/base/list.html))  
  List of options which are set before the `.f` is called. Options are
  reset to their previous state afterwards.

- .seed:

  (`integer(1)`)  
  Random seed to set before invoking the function call. Gets reset to
  the previous seed on exit.

- .timeout:

  (`numeric(1)`)  
  Timeout in seconds. Uses
  [`setTimeLimit()`](https://rdrr.io/r/base/setTimeLimit.html). Note
  that timeouts are only triggered on a user interrupt, not in compiled
  code.

## Examples

``` r
invoke(mean, .args = list(x = 1:10))
#> [1] 5.5
invoke(mean, na.rm = TRUE, .args = list(1:10))
#> [1] 5.5
```
