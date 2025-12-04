# Encapsulate Function Calls for Logging

Evaluates a function while both recording an output log and measuring
the elapsed time. There are currently three different modes implemented
to encapsulate a function call:

- `"none"`: Just runs the call in the current session and measures the
  elapsed time. Does not keep a log, output is printed directly to the
  console. Works well together with
  [`traceback()`](https://rdrr.io/r/base/traceback.html).

- `"try"`: Similar to `"none"`, but catches error. Output is printed to
  the console and not logged.

- `"evaluate"`: Uses the package
  [evaluate](https://CRAN.R-project.org/package=evaluate) to call the
  function, measure time and do the logging.

- `"callr"`: Uses the package
  [callr](https://CRAN.R-project.org/package=callr) to call the
  function, measure time and do the logging. This encapsulation spawns a
  separate R session in which the function is called. While this comes
  with a considerable overhead, it also guards your session from being
  teared down by segfaults.

- `"mirai"`: Uses the package
  [mirai](https://CRAN.R-project.org/package=mirai) to call the
  function, measure time and do the logging. This encapsulation calls
  the function in a `mirai` on a `daemon`. The `daemon` can be
  pre-started via `daemons(1)`, otherwise a new R session will be
  created for each encapsulated call. If a `daemon` is already running,
  it will be used to execute all calls. Using mirai is similarly safe as
  callr but much faster if several function calls are encapsulated one
  after the other on the same daemon.

## Usage

``` r
encapsulate(
  method,
  .f,
  .args = list(),
  .opts = list(),
  .pkgs = character(),
  .seed = NA_integer_,
  .timeout = Inf,
  .compute = "default"
)
```

## Arguments

- method:

  (`character(1)`)  
  One of `"none"`, `"try"`, `"evaluate"`, `"callr"`, or `"mirai"`.

- .f:

  (`function()`)  
  Function to call.

- .args:

  ([`list()`](https://rdrr.io/r/base/list.html))  
  Arguments passed to `.f`.

- .opts:

  (named [`list()`](https://rdrr.io/r/base/list.html))  
  Options to set for the function call. Options get reset on exit.

- .pkgs:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Packages to load (not attach).

- .seed:

  (`integer(1)`)  
  Random seed to set before invoking the function call. Gets reset to
  the previous seed on exit.

- .timeout:

  (`numeric(1)`)  
  Timeout in seconds. Uses
  [`setTimeLimit()`](https://rdrr.io/r/base/setTimeLimit.html) for
  `"none"` and `"evaluate"` encapsulation. For `"callr"` encapsulation,
  the timeout is passed to
  [`callr::r()`](https://callr.r-lib.org/reference/r.html). For
  `"mirai"` encapsulation, the timeout is passed to
  [`mirai::mirai()`](https://mirai.r-lib.org/reference/mirai.html).

- .compute:

  (`character(1)`)  
  If `method` is `"mirai"`, a daemon with the specified compute profile
  is used or started.

## Value

(named [`list()`](https://rdrr.io/r/base/list.html)) with four fields:

- `"result"`: the return value of `.f`

- `"elapsed"`: elapsed time in seconds. Measured as
  [`proc.time()`](https://rdrr.io/r/base/proc.time.html) difference
  before/after the function call.

- `"log"`:
  [`data.table()`](https://rdatatable.gitlab.io/data.table/reference/data.table.html)
  with columns `"class"` (ordered factor with levels `"output"`,
  `"warning"` and `"error"`) and `"message"`
  ([`character()`](https://rdrr.io/r/base/character.html)).

- `"condition"`: the condition object if an error occurred, otherwise
  `NULL`.

## Examples

``` r
f = function(n) {
  message("hi from f")
  if (n > 5) {
    stop("n must be <= 5")
  }
  runif(n)
}

encapsulate("none", f, list(n = 1), .seed = 1)
#> hi from f
#> $result
#> [1] 0.2655087
#> 
#> $log
#> Empty data.table (0 rows and 3 cols): class,msg,condition
#> 
#> $elapsed
#> [1] 0.001
#> 

if (requireNamespace("evaluate", quietly = TRUE)) {
  encapsulate("evaluate", f, list(n = 1), .seed = 1)
}
#> $result
#> [1] 0.5668943
#> 
#> $log
#>     class       msg condition
#>     <ord>    <char>    <list>
#> 1: output hi from f hi from f
#> 
#> $elapsed
#> [1] 0.003
#> 

if (requireNamespace("callr", quietly = TRUE)) {
  encapsulate("callr", f, list(n = 1), .seed = 1)
}
#> $result
#> [1] 0.2655087
#> 
#> $log
#>     class       msg condition
#>     <ord>    <char>    <list>
#> 1: output hi from f hi from f
#> 
#> $elapsed
#> elapsed 
#>   0.697 
#> 
```
