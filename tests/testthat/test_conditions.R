test_that("conditions", {
  check = function(cond, msg, class) {
    expect_class(cond, class)
    expect_class(cond, "condition")
    expect_class(cond, "error")
    expect_equal(cond$message, msg)
  }
  check(condition_mlr3("test: %s", "a"), "test: a", "mlr3Error")
  check(condition_config("test: %s", "a"), "test: a", "mlr3ErrorConfig")
  check(condition_timeout(), "reached elapsed time limit", "mlr3ErrorTimeout")
})

test_that("errors", {
  expect_error(error_mlr3("test: %s", "a"), "test: a")
  expect_error(error_config("test: %s", "a"), "test: a")
  expect_error(error_timeout(), "reached elapsed time limit")
})
