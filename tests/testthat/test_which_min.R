context("which_min")

test_that("which_min", {
  expect_equal(which_min(c(1, 9), ties_method = "first"), 1L)
  expect_equal(which_min(c(1, NA, 9), ties_method = "first"), 1L)
  expect_equal(which_min(c(9, 1), ties_method = "first"), 2L)
  expect_equal(which_min(c(-9, -1), ties_method = "first"), 1L)
  expect_equal(which_min(c(-9, 1), ties_method = "first"), 1L)

  expect_equal(which_max(c(1, 9, 9), ties_method = "first"), 2L)
  expect_equal(which_max(c(1, 9, NA, 9), ties_method = "first"), 2L)
  expect_equal(which_max(c(1, 9, 9), ties_method = "last"), 3L)
  expect_equal(which_max(3, ties_method = "first"), 1L)
  expect_equal(which_max(3, ties_method = "last"), 1L)
  expect_equal(which_max(c(9, 1, 9, 9), ties_method = "first"), 1L)
  expect_equal(which_max(c(9, 1, 9, 9), ties_method = "last"), 4L)

  expect_equal(which_min(integer(0)), integer(0))
  expect_equal(which_max(integer(0)), integer(0))
})
