# Encapsulate Function Calls

Evaluates a function, capturing conditions and measuring elapsed time.
There are currently five modes:

- `"none"`: Runs the call in the current session. Conditions are
  signaled normally; no log is kept. Works well together with
  [`traceback()`](https://rdrr.io/r/base/traceback.html).

- `"try"`: Like `"none"`, but catches errors and writes them to the log.
  Warnings and messages are still signaled.

- `"evaluate"`: Uses
  [evaluate](https://CRAN.R-project.org/package=evaluate) to capture
  errors, warnings, and messages into the log. Printed output is lost.

- `"callr"`: Uses [callr](https://CRAN.R-project.org/package=callr) to
  run the function in a fresh R session. Errors, warnings, and messages
  are captured into the log; printed output is lost. Protects the
  calling session from segfaults at the cost of session startup
  overhead. The RNG state is propagated back to the calling session
  after evaluation.

- `"mirai"`: Uses [mirai](https://CRAN.R-project.org/package=mirai) to
  run the function on a daemon. Errors, warnings, and messages are
  captured into the log; printed output is lost. The daemon can be
  pre-started via `daemons(1)`; if none is running, a new session is
  started per call. Offers similar safety to `"callr"` with lower
  overhead when a daemon is reused across calls. The RNG state is
  propagated back to the calling session after evaluation.

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
  Named list of arguments passed to `.f`.

- .opts:

  (named [`list()`](https://rdrr.io/r/base/list.html))  
  Options to set via [`options()`](https://rdrr.io/r/base/options.html)
  before calling `.f`. Restored on exit.

- .pkgs:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Packages to load via
  [`requireNamespace()`](https://rdrr.io/r/base/ns-load.html) before
  calling `.f`.

- .seed:

  (`integer(1)`)  
  Random seed set via [`set.seed()`](https://rdrr.io/r/base/Random.html)
  before calling `.f`. If `NA` (default), the seed is not changed; for
  `"callr"` and `"mirai"` modes the current RNG state is forwarded
  instead.

- .timeout:

  (`numeric(1)`)  
  Timeout in seconds (`Inf` for no limit). Uses
  [`setTimeLimit()`](https://rdrr.io/r/base/setTimeLimit.html) for
  `"none"` and `"evaluate"`; passed natively to
  [`callr::r()`](https://callr.r-lib.org/reference/r.html) and
  [`mirai::mirai()`](https://mirai.r-lib.org/reference/mirai.html) for
  the other modes.

- .compute:

  (`character(1)`)  
  Compute profile for `"mirai"` mode. Passed to
  [`mirai::mirai()`](https://mirai.r-lib.org/reference/mirai.html) as
  `.compute`.

## Value

Named [`list()`](https://rdrr.io/r/base/list.html) with three elements:

- `"result"`: return value of `.f`, or `NULL` if an error was caught.

- `"elapsed"`: elapsed time in seconds, measured via
  [`proc.time()`](https://rdrr.io/r/base/proc.time.html).

- `"log"`:
  [`data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  with columns `"class"` (ordered factor with levels `"output"`,
  `"warning"`, `"error"`) and `"condition"` (list of condition objects).
  Messages are classified as `"output"` for historical reasons. Empty
  when no conditions were captured.

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
#> Empty data.table (0 rows and 2 cols): class,condition
#> 
#> $elapsed
#> elapsed 
#>       0 
#> 

if (requireNamespace("evaluate", quietly = TRUE)) {
  encapsulate("evaluate", f, list(n = 1), .seed = 1)
}
#> $result
#> [1] 0.2655087
#> 
#> $log
#>     class          condition
#>     <ord>             <list>
#> 1: output <simpleMessage[2]>
#> 
#> $elapsed
#> elapsed 
#>   0.003 
#> 

if (requireNamespace("callr", quietly = TRUE)) {
  encapsulate("callr", f, list(n = 1), .seed = 1)
}
#> $result
#> [1] 0.2655087
#> 
#> $log
#>     class          condition
#>     <ord>             <list>
#> 1: output <simpleMessage[2]>
#> 
#> $elapsed
#> elapsed 
#>   0.621 
#> 
```
