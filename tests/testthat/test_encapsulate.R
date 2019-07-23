context("encapsulate")

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
    res = encapsulate(method, fun2)
    log = res$log
    expect_identical(res$result, 1L)
    expect_number(res$elapsed, lower = 0)
    expect_data_table(res$log, ncols = 2)
  }

  for (method in c("evaluate", "callr")) {
    res = encapsulate(method, fun1)
    log = res$log
    expect_identical(res$result, 99L)
    expect_number(res$elapsed, lower = 0)
    expect_data_table(log, ncols = 2)
    expect_set_equal(as.character(log$class), c("output", "warning"))
    expect_true(log[class == "warning", grepl("\n", msg, fixed = TRUE)])
  }
})
