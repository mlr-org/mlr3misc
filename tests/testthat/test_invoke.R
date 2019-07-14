context("invoke")

test_that("invoke", {
  expect_equal(invoke(identity, .args = list(1L)), 1L)

  foo = function(x, y) x + y

  expect_equal(invoke(foo, .args = list(x = 1, y = 2)), 3)
  expect_equal(invoke(foo, .args = list(x = 1), y = 2), 3)
  expect_equal(invoke(foo, x = 1, y = 2), 3)

  f = function(x) warning("foo")
  prev_warn = getOption("warn")
  expect_warning(f(1))
  expect_warning(invoke(f, 1))
  expect_error(invoke(f, 1, .opts = list(warn = 2)))
  expect_equal(getOption("warn"), prev_warn)
})
