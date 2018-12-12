context("invoke")

test_that("invoke", {
  expect_equal(invoke(identity, list(1L)), 1L)

  foo = function(x, y) x + y

  expect_equal(invoke(foo, list(x = 1, y = 2)), 3)
  expect_equal(invoke(foo, list(x = 1), y = 2), 3)
  expect_equal(invoke(foo, x = 1, y = 2), 3)
})
