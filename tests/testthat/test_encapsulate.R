test_that("encapsulation works", {
  fun = function() {
    1L
  }

  for (method in c("none", "evaluate", "callr", "mirai")) {
    if (method != "none" && !requireNamespace(method, quietly = TRUE)) {
      next
    }
    res = encapsulate(method, fun)
    log = res$log
    expect_identical(res$result, 1L)
    expect_number(res$elapsed, lower = 0)
    expect_data_table(res$log, ncols = 2)
  }
})

test_that("messages and warnings are logged", {
  fun = function() {
    message("foo")
    warning("bar\nfoobar")
    return(99L)
  }

  for (method in c("evaluate", "callr")) {
    if (method != "none" && !requireNamespace(method, quietly = TRUE)) {
      next
    }

    res = encapsulate(method, fun)
    log = res$log
    expect_identical(res$result, 99L)
    expect_number(res$elapsed, lower = 0)
    expect_data_table(log, ncols = 2)
    expect_set_equal(as.character(log$class), c("output", "warning"))
    expect_true(log[class == "warning", grepl("\n", msg, fixed = TRUE)])
  }
})

test_that("errors are logged", {
  fun = function() {
    stop("foo")
  }

  for (method in c("evaluate", "callr", "mirai")) {
    if (!requireNamespace(method, quietly = TRUE)) {
      next
    }

    res = encapsulate(method, fun)
    expect_null(res$result)
    expect_equal(as.character(res$log$class), "error")
    expect_match(res$log$msg, "foo")
  }
})

test_that("segfaults are logged", {
  fun = function() {
   tools::pskill(Sys.getpid())
   1L
  }

  for (method in c("callr", "mirai")) {
    if (!requireNamespace(method, quietly = TRUE)) {
      next
    }

    res = encapsulate(method, fun)
    expect_null(res$result)
    expect_equal(as.character(res$log$class), "error")
  }
})

test_that("timeout", {
  f = function(x) {
    for (i in 1:10) {
      Sys.sleep(x)
    }
    return(1)
  }

  expect_error(encapsulate("none", .f = f, .args = list(x = 1), .timeout = 1), "time limit")

  res = encapsulate("evaluate", .f = f, .args = list(x = 1), .timeout = 1)
  expect_null(res$result)
  expect_true("error" %in% res$log$class)
  expect_match(res$log$msg, "time limit", fixed = TRUE)

  res = encapsulate("callr", .f = f, .args = list(x = 1), .timeout = 1)
  expect_null(res$result)
  expect_true("error" %in% res$log$class)
  expect_match(res$log$msg, "time limit", fixed = TRUE)

  res = encapsulate("mirai", .f = f, .args = list(x = 1), .timeout = 1)
  expect_null(res$result)
  expect_true("error" %in% res$log$class)
  expect_match(res$log$msg, "time limit", fixed = TRUE)
})

test_that("try", {
  fun1 = function(...) {
    message("foo")
  }

  fun2 = function(...) {
    message("foo")
  }

  expect_message(encapsulate("try", function(...) message("foo")))
  expect_warning(encapsulate("try", function(...) warning("foo")))
})

test_that("rng state is transferred", {

  rng_state = .GlobalEnv$.Random.seed
  on.exit({.GlobalEnv$.Random.seed = rng_state})

  fun = function() {
    sample(seq(1000), 1)
  }

  for (method in c("callr", "mirai")) {
    if (!requireNamespace(method, quietly = TRUE)) {
      next
    }

    # no seed
    res = encapsulate(method, fun)
    expect_number(res$result)

    set.seed(1, kind = "Mersenne-Twister")
    res = encapsulate(method, fun)
    expect_equal(res$result, 836)
    expect_equal(sample(seq(1000), 1), 679)

    set.seed(1, kind = "Mersenne-Twister")
    expect_equal(fun(), 836)
    expect_equal(sample(seq(1000), 1), 679)

    set.seed(1, kind = "Wichmann-Hill")
    res = encapsulate(method, fun)
    expect_equal(res$result, 309)
    expect_equal(sample(seq(1000), 1), 885)

    set.seed(1, kind = "Wichmann-Hill")
    expect_equal(fun(), 309)
    expect_equal(sample(seq(1000), 1), 885)

    set.seed(1, kind = "L'Ecuyer-CMRG")
    res = encapsulate(method, fun)
    expect_equal(res$result, 371)
    expect_equal(sample(seq(1000), 1), 359)

    set.seed(1, kind = "L'Ecuyer-CMRG")
    expect_equal(fun(), 371)
    expect_equal(sample(seq(1000), 1), 359)
  }
})

test_that("seeds are applied", {
  fun = function() {
    sample(seq(1000), 1)
  }

  value = invoke(fun, .seed = 1)

  for (method in c("callr", "mirai")) { # "evaluate"
    if (!requireNamespace(method, quietly = TRUE)) {
      next
    }

    res = encapsulate(method, fun, .seed = 1)
    expect_equal(res$result, value)
  }
})

test_that("mirai daemons can be pre-started", {
  skip_if_not_installed("mirai")

  fun = function() {
    1L
  }

  mirai::daemons(1, .compute = "local")
  expect_equal(mirai::status(.compute = "local")$connections, 1)

  on.exit({
    mirai::daemons(0, .compute = "local")
  })

  res = encapsulate("mirai", fun, .compute = "local")
  expect_equal(res$result, 1L)

  expect_equal(mirai::status(.compute = "local")$connections, 1)
  expect_equal(unname(mirai::status(.compute = "local")$mirai["completed"]), 1)
})

test_that("mirai daemon is started if not running", {
  skip_if_not_installed("mirai")

  fun = function() {
    1L
  }

  expect_equal(mirai::status()$connections, 0)

  res = encapsulate("mirai", fun)
  expect_equal(res$result, 1L)
  expect_equal(mirai::status()$connections, 0)
})

