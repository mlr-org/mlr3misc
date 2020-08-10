context("compose")

test_that("compose", {
  f = compose(function(x) x + 1, function(x) x / 2)
  expect_equal(f(10), 6)

  f = compose(sqrt)
  expect_equal(f(4), 2)
  expect_error(compose(), "length")
})
