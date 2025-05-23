#' @title Encapsulate Function Calls for Logging
#'
#' @description
#' Evaluates a function while both recording an output log and measuring the elapsed time.
#' There are currently three different modes implemented to encapsulate a function call:
#'
#' * `"none"`: Just runs the call in the current session and measures the elapsed time.
#'   Does not keep a log, output is printed directly to the console.
#'   Works well together with [traceback()].
#' * `"try"`: Similar to `"none"`, but catches error. Output is printed to the console and
#'   not logged.
#' * `"evaluate"`: Uses the package \CRANpkg{evaluate} to call the function, measure time and do the logging.
#' * `"callr"`: Uses the package \CRANpkg{callr} to call the function, measure time and do the logging.
#'   This encapsulation spawns a separate R session in which the function is called.
#'   While this comes with a considerable overhead, it also guards your session from being teared down by segfaults.
#' * `"mirai"`: Uses the package \CRANpkg{mirai} to call the function, measure time and do the logging.
#'   This encapsulation calls the function in a `mirai` on a `daemon`.
#'   The `daemon` can be pre-started via `daemons(1)`, otherwise a new R session will be created for each encapsulated call.
#'   If a `daemon` is already running, it will be used to execute all calls.
#'   Using mirai is similarly safe as callr but much faster if several function calls are encapsulated one after the other on the same daemon.
#'
#' @param method (`character(1)`)\cr
#'   One of `"none"`, `"try"`, `"evaluate"`, `"callr"`, or `"mirai"`.
#' @param .f (`function()`)\cr
#'   Function to call.
#' @param .args (`list()`)\cr
#'   Arguments passed to `.f`.
#' @param .opts (named `list()`)\cr
#'   Options to set for the function call. Options get reset on exit.
#' @param .pkgs (`character()`)\cr
#'   Packages to load (not attach).
#' @param .seed (`integer(1)`)\cr
#'   Random seed to set before invoking the function call.
#'   Gets reset to the previous seed on exit.
#' @param .timeout (`numeric(1)`)\cr
#'   Timeout in seconds. Uses [setTimeLimit()] for `"none"` and `"evaluate"` encapsulation.
#'   For `"callr"` encapsulation, the timeout is passed to `callr::r()`.
#'   For `"mirai"` encapsulation, the timeout is passed to `mirai::mirai()`.
#' @param .compute (`character(1)`)\cr
#'   If `method` is `"mirai"`, a daemon with the specified compute profile is used or started.
#' @return (named `list()`) with three fields:
#'   * `"result"`: the return value of `.f`
#'   * `"elapsed"`: elapsed time in seconds. Measured as [proc.time()] difference before/after the function call.
#'   * `"log"`: `data.table()` with columns `"class"` (ordered factor with levels `"output"`, `"warning"` and `"error"`) and `"message"` (`character()`).
#' @export
#' @examples
#' f = function(n) {
#'   message("hi from f")
#'   if (n > 5) {
#'     stop("n must be <= 5")
#'   }
#'   runif(n)
#' }
#'
#' encapsulate("none", f, list(n = 1), .seed = 1)
#'
#' if (requireNamespace("evaluate", quietly = TRUE)) {
#'   encapsulate("evaluate", f, list(n = 1), .seed = 1)
#' }
#'
#' if (requireNamespace("callr", quietly = TRUE)) {
#'   encapsulate("callr", f, list(n = 1), .seed = 1)
#' }
encapsulate = function(method, .f, .args = list(), .opts = list(), .pkgs = character(), .seed = NA_integer_, .timeout = Inf, .compute = "default") {

  assert_choice(method, c("none", "try", "evaluate", "mirai", "callr"))
  assert_list(.args, names = "unique")
  assert_list(.opts, names = "unique")
  assert_character(.pkgs, any.missing = FALSE)
  assert_count(.seed, na.ok = TRUE)
  assert_number(.timeout, lower = 0)
  log = NULL

  if (method %in% c("none", "try")) {
    require_namespaces(.pkgs)

    now = proc.time()[[3L]]
    if (method == "none") {
      result = invoke(.f, .args = .args, .opts = .opts, .seed = .seed, .timeout = .timeout)
    } else {
      result = try(invoke(.f, .args = .args, .opts = .opts, .seed = .seed, .timeout = .timeout))
      if (inherits(result, "try-error")) {
        result = NULL
      }
    }
    elapsed = proc.time()[[3L]] - now
  } else if (method == "evaluate") {
    require_namespaces(c("evaluate", .pkgs))

    now = proc.time()[[3L]]
    result = NULL
    log = evaluate::evaluate(
      "result <- invoke(.f, .args = .args, .timeout = .timeout)",
      stop_on_error = 1L,
      new_device = FALSE,
      include_timing = FALSE
    )
    elapsed = proc.time()[[3L]] - now
    log = parse_evaluate(log)
  } else if (method == "mirai") {
    require_namespaces("mirai")

    # mirai does not copy the RNG state, so we need to do it manually
    .rng_state = if (is.na(.seed)) .GlobalEnv$.Random.seed
    .timeout = if (is.finite(.timeout)) .timeout * 1000

    now = proc.time()[3L]
    result = mirai::collect_mirai(mirai::mirai({
      suppressPackageStartupMessages({
        lapply(.pkgs, requireNamespace)
      })

      # restore RNG state from parent R session
      if (!is.null(.rng_state)) assign(".Random.seed", .rng_state, envir = globalenv())

      result = mlr3misc::invoke(.f, .args = .args, .opts = .opts, .seed = .seed)

      # copy new RNG state back to parent R session
      list(result = result, rng_state = if (is.na(.seed)) .GlobalEnv$.Random.seed)
    }, .args = list(.f = .f, .args = .args, .opts = .opts, .pkgs = .pkgs, .seed = .seed, .rng_state = .rng_state), .timeout = .timeout, .compute = .compute))
    elapsed = proc.time()[3L] - now

    # read error messages and store them in log
    log = NULL
    if (mirai::is_error_value(result)) {
      if (unclass(result) == 5) result = "reached elapsed time limit"
      log = data.table(class = "error", msg = as.character(result))
      result = NULL
    } else {
      # restore RNG state from mirai session
      if (!is.null(result$rng_state)) assign(".Random.seed", result$rng_state, envir = globalenv())
      result = result$result
    }

    if (is.null(log)) {
      log = data.table(class = character(), msg = character())
    }

    log$class = factor(log$class, levels = c("output", "warning", "error"), ordered = TRUE)
    list(result = result, log = log, elapsed = elapsed)
  } else { # method == "callr"
    require_namespaces("callr")

    # callr does not copy the RNG state, so we need to do it manually
    .rng_state = .GlobalEnv$.Random.seed
    logfile = tempfile()
    now = proc.time()[3L]
    result = try(callr::r(callr_wrapper,
      list(.f = .f, .args = .args, .opts = .opts, .pkgs = .pkgs, .seed = .seed, .rng_state = .rng_state),
      stdout = logfile, stderr = logfile, timeout = .timeout), silent = TRUE)
    elapsed = proc.time()[3L] - now

    if (file.exists(logfile)) {
      log = readLines(logfile, warn = FALSE)
      file.remove(logfile)
    } else {
      log = character(0L)
    }

    if (inherits(result, "try-error")) {
      condition = attr(result, "condition")
      if (inherits(condition, "callr_timeout_error")) {
        log = c(log, "[ERR] reached elapsed time limit")
      } else {
        status = attr(result, "condition")$status
        log = c(log, sprintf("[ERR] callr process exited with status %i", status))
      }
      result = NULL
    } else {
      if (!is.null(result$rng_state)) assign(".Random.seed", result$rng_state, envir = globalenv())
      result = result$result
    }
    log = parse_callr(log)
  }

  if (is.null(log)) {
    log = data.table(class = character(), msg = character())
  }

  log$class = factor(log$class, levels = c("output", "warning", "error"), ordered = TRUE)
  list(result = result, log = log, elapsed = elapsed)
}


parse_evaluate = function(log) {
  extract = function(x) {
    if (inherits(x, "message")) {
      return(list(class = "output", msg = trimws(x$message)))
    }
    if (inherits(x, "warning")) {
      return(list(class = "warning", msg = trimws(x$message)))
    }
    if (inherits(x, "error")) {
      return(list(class = "error", msg = trimws(x$message)))
    }
    if (inherits(x, "recordedplot")) {
      return(NULL)
    }
    return(list(class = "output", msg = trimws(x)))
  }

  log = map_dtr(log[-1L], extract)
  if (ncol(log) == 0L) NULL else log
}

parse_callr = function(log) {
  if (length(log) == 0L) {
    return(NULL)
  }

  log = data.table(class = "output", msg = log)
  parse_line = function(x) trimws(gsub("<br>", "\n", substr(x, 7L, nchar(x)), fixed = TRUE))
  log[startsWith(get("msg"), "[WRN] "), c("class", "msg") := list("warning", parse_line(get("msg")))]
  log[startsWith(get("msg"), "[ERR] "), c("class", "msg") := list("error", parse_line(get("msg")))]
  log[]
}

callr_wrapper = function(.f, .args, .opts, .pkgs, .seed, .rng_state) {
  suppressPackageStartupMessages({
    lapply(.pkgs, requireNamespace)
  })
  options(warn = 1L)
  options(.opts)
  if (!is.na(.seed)) {
    set.seed(.seed)
  }

  # restore RNG state from parent R session
  if (!is.null(.rng_state) && is.na(.seed)) assign(".Random.seed", .rng_state, envir = globalenv())

  result = withCallingHandlers(
    tryCatch(do.call(.f, .args),
      error = function(e) {
        cat("[ERR]", gsub("\r?\n|\r", "<br>", conditionMessage(e)), "\n")
        NULL
      }
    ),
    warning = function(w) {
      cat("[WRN]", gsub("\r?\n|\r", "<br>", conditionMessage(w)), "\n")
      invokeRestart("muffleWarning")
    }
  )

  # copy new RNG state back to parent R session
  list(result = result, rng_state = .GlobalEnv$.Random.seed)
}
