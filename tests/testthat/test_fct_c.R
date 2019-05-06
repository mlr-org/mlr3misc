context("fct_c")

test_that("fct_c", {
  x = factor(c("a", "b", "a"))
  y = factor(c("b", "a", "a"))
  z = factor(c("a", "b", "c"))

  expect_equal(fct_c(x, y), factor(c("a", "b", "a", "b", "a", "a"), levels = c("a", "b")))
  expect_equal(fct_c(x, z), factor(c("a", "b", "a", "a", "b", "c"), levels = c("a", "b", "c")))
  expect_equal(fct_c("a", "b", "b"), factor(c("a", "b", "b"), levels = c("a", "b")))
  expect_equal(fct_c("a", "c", "b"), factor(c("a", "c", "b"), levels = c("a", "c", "b")))
})
