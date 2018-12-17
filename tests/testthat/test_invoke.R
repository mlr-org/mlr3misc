context("invoke")

test_that("invoke", {
  expect_equal(invoke(identity, .args = list(1L)), 1L)

  foo = function(x, y) x + y

  expect_equal(invoke(foo, .args = list(x = 1, y = 2)), 3)
  expect_equal(invoke(foo, .args = list(x = 1), y = 2), 3)
  expect_equal(invoke(foo, x = 1, y = 2), 3)
})
