#' @title Encapsulate Function Calls for Logging
#'
#' @description
#' Evaluates a function while both recording an output log and measuring the elapsed time.
#' There are currently three different methods implemented to encapsulate a function call:
#'
#' * `"none"`: This does not keep a log, just calls the function and measures the elapsed time.
#'   This encapsulation works well together with [traceback()].
#' * `"evaluate"`: Uses the package \CRANpkg{evaluate} to call the function and do the logging.
#' * `"callr"`: Uses the package \CRANpkg{callr} to call the function and do the logging.
#'   This encapsulation spawns a separate R session in which the function is called.
#'   While this comes with a considerable overhead, it also guards your session from being teared down by segfaults.
#'
#' @param method :: `character(1)`\cr
#'   One of `"none"`, `"evaluate"` or `"callr"`.
#' @param .f :: `function()`\cr
#'   Function to call.
#' @param .args :: `list()`\cr
#'   Arguments passed to `.f`.
#' @param .opts :: named `list()`\cr
#'   Options to set for the function call. Options get reset on exit.
#' @param .pkgs :: `character()`\cr
#'   Packages to load (not attach).
#' @param .seed :: `integer(1)`\cr
#'   Random seed to set before invoking the function call.
#'   Gets reset to the previous seed on exit.
#' @return (named `list()`) with three fields:
#'   * `"result"`: the return value of `.f`
#'   * `"elapsed"`: elapsed time in seconds. Measured as [proc.time()] difference before/after the function call.
#'   * `"log"`: `data.table()` with columns `"class"` (ordered factor with levels `"output"`, `"warning"` and `"error"`) and `"message"` (`character()`).
#' @export
#' @examples
#' f = function(n) {
#'   message("hi from f")
#'   if (n > 5)
#'     stop("n must be <= 5")
#'   runif(n)
#' }
#' encapsulate("none", f, list(n = 1), .seed = 1)
#' encapsulate("evaluate", f, list(n = 1), .seed = 1)
#' encapsulate("callr", f, list(n = 1), .seed = 1)
encapsulate = function(method, .f, .args = list(), .opts = list(), .pkgs = character(), .seed = NA_integer_) {
  assert_choice(method, c("none", "evaluate", "callr"))
  assert_list(.args, names = "unique")
  assert_list(.opts, names = "unique")
  assert_character(.pkgs, any.missing = FALSE)
  assert_count(.seed, na.ok = TRUE)
  log = NULL

  if (method == "none") {
    require_namespaces(.pkgs)

    now = proc.time()[[3L]]
    result = invoke(.f, .args = .args, .opts = .opts, .seed = .seed)
    elapsed = proc.time()[[3L]] - now
  } else if (method == "evaluate") {
    require_namespaces(c("evaluate", .pkgs))

    now = proc.time()[[3L]]
    result = NULL
    log = evaluate::evaluate(
      "result <- invoke(.f, .args = .args)",
      stop_on_error = 1L,
      new_device = FALSE,
      include_timing = FALSE
    )
    elapsed = proc.time()[[3L]] - now
    log = parse_evaluate(log)
  } else { # method == "callr"
    require_namespaces("callr")

    logfile = tempfile()
    now = proc.time()[3L]
    result = try(callr::r(callr_wrapper, list(.f = .f, .args = .args, .opts = .opts, .pkgs = .pkgs, .seed = .seed), stdout = logfile, stderr = logfile), silent = TRUE)
    elapsed = proc.time()[3L] - now

    if (file.exists(logfile)) {
      log = readLines(logfile, warn = FALSE)
      file.remove(logfile)
    } else {
      log = character(0L)
    }

    if (inherits(result, "try-error")) {
      status = attr(result, "condition")$status
      log = c(log, sprintf("[ERR] callr process exited with status %i", status))
      result = NULL
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
  if (length(log) == 0L)
    return(NULL)

  log = data.table(class = "output", msg = log)
  parse_line = function(x) trimws(gsub("<br>", "\n", substr(x, 7L, nchar(x)), fixed = TRUE))
  log[startsWith(get("msg"), "[WRN] "), c("class", "msg") := list("warning", parse_line(get("msg")))]
  log[startsWith(get("msg"), "[ERR] "), c("class", "msg") := list("error", parse_line(get("msg")))]
  log[]
}

callr_wrapper = function(.f, .args, .opts, .pkgs, .seed) {
  suppressPackageStartupMessages({
    lapply(.pkgs, requireNamespace)
  })
  options(warn = 1L)
  options(.opts)
  if (!is.na(.seed)) {
    set.seed(.seed)
  }

  withCallingHandlers(
    tryCatch(do.call(.f, .args),
      error = function(e) {
        cat("[ERR]", gsub("\r?\n|\r", "<br>", conditionMessage(e)), "\n")
        NULL
      }),
    warning = function(w) {
      cat("[WRN]", gsub("\r?\n|\r", "<br>", conditionMessage(w)), "\n")
      invokeRestart("muffleWarning")
    }
  )
}
