context("which_max")

test_that("which_max", {
  expect_identical(which_min(c(1, 9), ties_method = "first"), 1L)
  expect_identical(which_min(c(1, NA, 9), ties_method = "first", na_rm = TRUE), 1L)
  expect_identical(which_min(c(9, 1), ties_method = "first"), 2L)
  expect_identical(which_min(c(-9, -1), ties_method = "first"), 1L)
  expect_identical(which_min(c(-9, 1), ties_method = "first"), 1L)

  expect_identical(which_max(c(1, 9, 9), ties_method = "first"), 2L)
  expect_identical(which_max(c(1, 9, NA, 9), ties_method = "first", na_rm = TRUE), 2L)
  expect_identical(which_max(c(1, 9, 9), ties_method = "last"), 3L)
  expect_identical(which_max(3, ties_method = "first"), 1L)
  expect_identical(which_max(3, ties_method = "last"), 1L)
  expect_identical(which_max(c(9, 1, 9, 9), ties_method = "first"), 1L)
  expect_identical(which_max(c(9, 1, 9, 9), ties_method = "last"), 4L)

  expect_identical(which_min(integer(0)), integer(0))
  expect_identical(which_max(integer(0)), integer(0))

  expect_identical(which_min(logical()), integer(0))
  expect_identical(which_max(logical()), integer(0))

  expect_identical(which_min(NA, na_rm = TRUE), integer(0))
  expect_identical(which_max(NA, na_rm = TRUE), integer(0))
  expect_identical(which_min(c(NA, 1), na_rm = FALSE), NA_integer_)
  expect_identical(which_max(c(NA, 1), na_rm = FALSE), NA_integer_)

  expect_identical(which_min(NA_integer_), NA_integer_)
  expect_identical(which_max(NA_integer_), NA_integer_)
  expect_identical(which_min(NA_real_), NA_integer_)
  expect_identical(which_max(NA_real_), NA_integer_)
})

test_that("na_rm", {
  expect_equal(which_max(NA_integer_, na_rm = TRUE), integer())
  expect_equal(which_max(NA_integer_, na_rm = FALSE), NA_integer_)
  expect_equal(which_max(c(1L, NA_integer_), na_rm = FALSE), NA_integer_)
  expect_equal(which_max(c(1L, NA_integer_), na_rm = TRUE), 1L)
  expect_equal(which_max(NA_real_, na_rm = TRUE), integer())
  expect_equal(which_max(NA_real_, na_rm = FALSE), NA_integer_)
  expect_equal(which_max(c(1, NA_real_), na_rm = FALSE), NA_integer_)
  expect_equal(which_max(c(1, NA_real_), na_rm = TRUE), 1L)
})
