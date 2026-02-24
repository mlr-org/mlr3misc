#' @title Encapsulate Function Calls
#'
#' @description
#' Evaluates a function, capturing conditions and measuring elapsed time.
#' There are currently five modes:
#'
#' * `"none"`: Runs the call in the current session.
#'   Conditions are signaled normally; no log is kept.
#'   Works well together with [traceback()].
#' * `"try"`: Like `"none"`, but catches errors and writes them to the log.
#'   Warnings and messages are still signaled.
#' * `"evaluate"`: Uses \CRANpkg{evaluate} to capture errors, warnings, and messages into the log.
#'   Printed output is lost.
#' * `"callr"`: Uses \CRANpkg{callr} to run the function in a fresh R session.
#'   Errors, warnings, and messages are captured into the log; printed output is lost.
#'   Protects the calling session from segfaults at the cost of session startup overhead.
#'   The RNG state is propagated back to the calling session after evaluation.
#' * `"mirai"`: Uses \CRANpkg{mirai} to run the function on a daemon.
#'   Errors, warnings, and messages are captured into the log; printed output is lost.
#'   The daemon can be pre-started via `daemons(1)`; if none is running, a new session is started per call.
#'   Offers similar safety to `"callr"` with lower overhead when a daemon is reused across calls.
#'   The RNG state is propagated back to the calling session after evaluation.
#'
#' @param method (`character(1)`)\cr
#'   One of `"none"`, `"try"`, `"evaluate"`, `"callr"`, or `"mirai"`.
#' @param .f (`function()`)\cr
#'   Function to call.
#' @param .args (`list()`)\cr
#'   Named list of arguments passed to `.f`.
#' @param .opts (named `list()`)\cr
#'   Options to set via [options()] before calling `.f`. Restored on exit.
#' @param .pkgs (`character()`)\cr
#'   Packages to load via [requireNamespace()] before calling `.f`.
#' @param .seed (`integer(1)`)\cr
#'   Random seed set via [set.seed()] before calling `.f`.
#'   If `NA` (default), the seed is not changed; for `"callr"` and `"mirai"` modes the current RNG state is forwarded instead.
#' @param .timeout (`numeric(1)`)\cr
#'   Timeout in seconds (`Inf` for no limit).
#'   Uses [setTimeLimit()] for `"none"` and `"evaluate"`; passed natively to `callr::r()` and `mirai::mirai()` for the other modes.
#' @param .compute (`character(1)`)\cr
#'   Compute profile for `"mirai"` mode. Passed to `mirai::mirai()` as `.compute`.
#' @return Named `list()` with three elements:
#'   * `"result"`: return value of `.f`, or `NULL` if an error was caught.
#'   * `"elapsed"`: elapsed time in seconds, measured via [proc.time()].
#'   * `"log"`: `data.table()` with columns `"class"` (ordered factor with levels
#'     `"output"`, `"warning"`, `"error"`) and `"condition"` (list of condition objects).
#'     Messages are classified as `"output"` for historical reasons.
#'     Empty when no conditions were captured.
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

    now = proc.time()[3L]
    if (method == "none") {
      result = invoke(.f, .args = .args, .opts = .opts, .seed = .seed, .timeout = .timeout)
    } else {
      result = try(invoke(.f, .args = .args, .opts = .opts, .seed = .seed, .timeout = .timeout))
      if (inherits(result, "try-error")) {
        condition = if (grepl("reached elapsed time limit", result, fixed = TRUE)) {
          error_timeout(signal = FALSE)
        } else {
          x = attr(result, "condition")
          attr(x, "call") = NULL
          x
        }
        # try only catches errors; warnings and messages are signaled
        log = data.table(class = "error", condition = list(condition))
        result = NULL
      }
    }
    elapsed = proc.time()[3L] - now
  } else if (method == "evaluate") {
    require_namespaces(c("evaluate", .pkgs))

    now = proc.time()[3L]
    result = NULL
    log = evaluate::evaluate(
      "result <- invoke(.f, .args = .args, .opts = .opts, .seed = .seed, .timeout = .timeout)",
      stop_on_error = 1L,
      new_device = FALSE,
      include_timing = FALSE
    )
    elapsed = proc.time()[3L] - now
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

    log = NULL
    if (mirai::is_error_value(result)) {
      conditions = if (unclass(result) == 5) {
        list(error_timeout(signal = FALSE))
      } else {
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
    result = try(callr::r(
      callr_wrapper,
      args = list(.f = .f, .args = .args, .opts = .opts, .pkgs = .pkgs, .seed = .seed, .rng_state = .rng_state),
      timeout = .timeout), silent = TRUE)
    elapsed = proc.time()[3L] - now

    log = NULL
    if (inherits(result, "try-error")) {
      condition = attr(result, "condition")
      if (inherits(condition, "callr_timeout_error")) {
        condition = error_timeout(signal = FALSE)
      }
      log = data.table(class = "error", condition = list(condition))
      result = NULL
    } else {
      if (!is.null(result$rng_state)) assign(".Random.seed", result$rng_state, envir = globalenv())
      log = conditions_to_log(result$conditions)
      result = result$result
    }
  }

  if (is.null(log)) {
    log = data.table(class = character(), condition = list())
  }
  if (nrow(log)) {
    log$condition = if (length(log$condition) == 1L) list(log$condition) else log$condition
  }

  log$class = factor(log$class, levels = c("output", "warning", "error"), ordered = TRUE)
  list(result = result, log = log, elapsed = elapsed)
}

parse_evaluate = function(log) {
  extract = function(x) {
    if (inherits(x, "message")) {
      return(list(class = "output", condition = list(x)))
    }
    if (inherits(x, "warning")) {
      return(list(class = "warning", condition = list(x)))
    }
    if (inherits(x, "error")) {
      if (grepl("reached elapsed time limit", x$message, fixed = TRUE)) {
        x = error_timeout(signal = FALSE)
      }
      return(list(class = "error", condition = list(x)))
    }
    NULL
  }

  log = map_dtr(log[-1L], extract)
  if (ncol(log) == 0L) NULL else log
}


conditions_to_log = function(conditions) {
  if (is.null(conditions)) {
    return(data.table(class = character(), condition = list()))
  }
  cls = function(x) {
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
    list(class = cls(x), condition = list(x))
  })
  log
}

callr_wrapper = function(.f, .args, .opts, .pkgs, .seed, .rng_state) {
  suppressPackageStartupMessages({
    lapply(.pkgs, requireNamespace)
  })
  options(.opts)
  if (!is.na(.seed)) {
    set.seed(.seed)
  }

  # restore RNG state from parent R session
  if (!is.null(.rng_state) && is.na(.seed)) assign(".Random.seed", .rng_state, envir = globalenv())

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
