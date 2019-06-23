context("as_factor")

test_that("as_factor", {
  x = as_factor(c("a", "b"), c("a", "b"))
  y = as_factor(c("a", "b"), c("b", "a"))
  expect_factor(x, levels = c("a", "b"))
  expect_factor(y, levels = c("b", "a"))

  expect_equal(levels(x), c("a", "b"))
  expect_equal(levels(y), c("b", "a"))

  z = as_factor(x, levels(y))
  expect_factor(z, levels = c("a", "b"))
  expect_equal(levels(z), levels(y))
})
