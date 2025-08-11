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
#' @return (named `list()`) with four fields:
#'   * `"result"`: the return value of `.f`
#'   * `"elapsed"`: elapsed time in seconds. Measured as [proc.time()] difference before/after the function call.
#'   * `"log"`: `data.table()` with columns `"class"` (ordered factor with levels `"output"`, `"warning"` and `"error"`) and `"message"` (`character()`).
#'   * `"condition"`: the condition object if an error occurred, otherwise `NULL`.
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
        condition = if (grepl("reached elapsed time limit", result)) {
          error_timeout(silent = TRUE)
        } else {
          x = attr(result, "condition")
          attr(x, "call") = NULL
          x
        }
        # try only catches error, warnings and messages are output
        log = data.table(class = "error", msg = condition_to_msg(condition), condition = list(condition))
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


      conditions = NULL
      result = withCallingHandlers(
        tryCatch(mlr3misc::invoke(.f, .args = .args, .opts = .opts, .seed = .seed),
          error = function(e) {
            conditions <<- c(conditions, list(e))
            NULL
          }
        ),
        warning = function(w) {
          conditions <<- c(conditions, list(w))
          invokeRestart("muffleWarning")
        },
        message = function(m) {
          conditions <<- c(conditions, list(m))
          invokeRestart("muffleMessage")
        }
      )

      # copy new RNG state back to parent R session
      list(result = result, rng_state = if (is.na(.seed)) .GlobalEnv$.Random.seed, conditions = conditions)
    }, .args = list(.f = .f, .args = .args, .opts = .opts, .pkgs = .pkgs, .seed = .seed, .rng_state = .rng_state), .timeout = .timeout, .compute = .compute))
    elapsed = proc.time()[3L] - now

    # read error messages and store them in log
    log = NULL
    if (mirai::is_error_value(result)) {
      conditions = if (unclass(result) == 5) {
        list(error_timeout(silent = TRUE))
      } else {
        # This is not really a condition object: https://github.com/r-lib/mirai/issues/400
        list(result)
      }
      result = NULL
    } else {
      # restore RNG state from mirai session
      if (!is.null(result$rng_state)) assign(".Random.seed", result$rng_state, envir = globalenv())
      conditions = result$conditions
      result = result$result
    }
    log = conditions_to_log(conditions)

  } else { # method == "callr"
    require_namespaces("callr")

    # callr does not copy the RNG state, so we need to do it manually
    .rng_state = .GlobalEnv$.Random.seed
    now = proc.time()[3L]
    result = try(callr::r(callr_wrapper,
      list(.f = .f, .args = .args, .opts = .opts, .pkgs = .pkgs, .seed = .seed, .rng_state = .rng_state),
      timeout = .timeout), silent = TRUE)
    elapsed = proc.time()[3L] - now

    log = NULL

    if (inherits(result, "try-error")) {
      condition = attr(result, "condition")
      if (inherits(condition, "callr_timeout_error")) {
        condition = error_timeout(silent = TRUE)
      }
      log = rbind(log, data.table(class = "error", msg = condition_to_msg(condition), condition = list(condition)))
      result = NULL
    } else {
      if (!is.null(result$rng_state)) assign(".Random.seed", result$rng_state, envir = globalenv())
      log = conditions_to_log(result$conditions)
      result = result$result
    }
  }

  if (is.null(log)) {
    log = data.table(class = character(), msg = character(), condition = list())
  }

  log$class = factor(log$class, levels = c("output", "warning", "error"), ordered = TRUE)
  list(result = result, log = log, elapsed = elapsed)
}


parse_evaluate = function(log) {
  extract = function(x) {
    if (inherits(x, "message")) {
      return(list(class = "output", msg = trimws(x$message), condition = list(x)))
    }
    if (inherits(x, "warning")) {
      return(list(class = "warning", msg = trimws(x$message), condition = list(x)))
    }
    if (inherits(x, "error")) {
      if (grepl("reached elapsed time limit", x$message)) {
        x = error_timeout(silent = TRUE)
      }
      return(list(class = "error", msg = trimws(x$message), condition = list(x)))
    }
    if (inherits(x, "recordedplot")) {
      return(NULL)
    }
    return(list(class = "output", msg = trimws(x), condition = NULL))
  }

  log = map_dtr(log[-1L], extract)
  if (ncol(log) == 0L) NULL else log
}

parse_callr = function(log) {
  if (length(log) == 0L) {
    return(NULL)
  }

  log = data.table(class = "output", msg = log, condition = list(NULL))
  parse_line = function(x) trimws(gsub("<br>", "\n", substr(x, 7L, nchar(x)), fixed = TRUE))
  log[startsWith(get("msg"), "[WRN] "), c("class", "msg") := list("warning", parse_line(get("msg")))]
  log[startsWith(get("msg"), "[ERR] "), c("class", "msg") := list("error", parse_line(get("msg")))]
  log[]
}

conditions_to_log = function(conditions) {
  if (is.null(conditions)) {
    return(data.table(class = character(), msg = character(), condition = list()))
  }
  cls <- function(x) {
    if (inherits(x, "error")) {
      "error"
    } else if (inherits(x, "warning")) {
      "warning"
    } else if (inherits(x, "errorValue")) {
      "error"
    } else {
      "output"
    }
  }
  log = map_dtr(conditions, function(x) {
    list(class = cls(x), msg = condition_to_msg(x), condition = list(x))
  })
  log
}

condition_to_msg <- function(x) {
  if (inherits(x, "errorValue")) {
    return(paste0("[ERR] ", capture.output(x)))
  }
  msg = trimws(conditionMessage(x))
  if (inherits(x, "conditionError")) {
    return(paste0("[ERR] ", msg))
  }
  if (inherits(x, "conditionWarning")) {
    return(paste0("[WRN] ", msg))
  }
  return(msg)
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

  # we use cat() to log conditions because this will even be captured in case of a
  # segfault
  # This means that we have to reconstruct the condition objects from the log for the warnings
  # For the errors we don't have to do this, because errors are only possible if there is no segfault
  conditions = NULL
  result = withCallingHandlers(
    tryCatch(do.call(.f, .args),
      error = function(e) {
        conditions <<- c(conditions, list(e))
        NULL
      }
    ),
    warning = function(w) {
      conditions <<- c(conditions, list(w))
      invokeRestart("muffleWarning")
    },
    message = function(m) {
      conditions <<- c(conditions, list(m))
      invokeRestart("muffleMessage")
    }
  )
  # copy new RNG state back to parent R session
  list(result = result, rng_state = .GlobalEnv$.Random.seed, conditions = conditions)
}
