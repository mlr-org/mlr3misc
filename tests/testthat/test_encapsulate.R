test_that("encapsulate", {
  fun1 = function(...) {
    message("foo")
    warning("bar\nfoobar")
    return(99L)
  }

  fun2 = function(...) {
    1L
  }

  for (method in c("none", "evaluate", "callr")) {
    if (method != "none" && !requireNamespace(method, quietly = TRUE)) {
      next
    }
    res = encapsulate(method, fun2)
    log = res$log
    expect_identical(res$result, 1L)
    expect_number(res$elapsed, lower = 0)
    expect_data_table(res$log, ncols = 2)
  }

  for (method in c("evaluate", "callr")) {
    if (!requireNamespace(method, quietly = TRUE)) {
      next
    }
    res = encapsulate(method, fun1)
    log = res$log
    expect_identical(res$result, 99L)
    expect_number(res$elapsed, lower = 0)
    expect_data_table(log, ncols = 2)
    expect_set_equal(as.character(log$class), c("output", "warning"))
    expect_true(log[class == "warning", grepl("\n", msg, fixed = TRUE)])
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
  expect_true(any(grepl("time limit", res$log$msg)))

  res = encapsulate("callr", .f = f, .args = list(x = 1), .timeout = 1)
  expect_null(res$result)
  expect_true("error" %in% res$log$class)
  expect_true(any(grepl("time limit", res$log$msg)))
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
