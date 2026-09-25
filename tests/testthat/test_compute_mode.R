test_that("compute_mode", {
  expect_identical(compute_mode(c(1, 1, 1, 2, 2, 2, 3), ties_method = "first"), 1)
  expect_identical(compute_mode(c(1, 1, 1, 2, 2, 2, 3), ties_method = "last"), 2)
  expect_true(compute_mode(c(1, 1, 1, 2, 2, 2, 3), ties_method = "random") %in% c(1, 2))
  expect_identical(compute_mode(c(5L, 5L, 1L), ties_method = "first"), 5L)
  expect_identical(compute_mode(c("b", "a", "a", "b", "c"), ties_method = "first"), "b")
  expect_identical(compute_mode(c(TRUE, TRUE, FALSE), ties_method = "first"), TRUE)

  expect_identical(
    compute_mode(factor(c("b", "a", "a"), levels = c("a", "b", "z")), ties_method = "first"),
    factor("a", levels = c("a", "b", "z"))
  )
})

test_that("compute_mode NA handling", {
  expect_identical(compute_mode(c(NA, NA, 1), ties_method = "first"), 1)
  expect_identical(compute_mode(c(NA, NA, 1), ties_method = "first", na_rm = FALSE), NA_real_)
  expect_identical(compute_mode(c(NA, 1), ties_method = "first", na_rm = FALSE), NA_real_)
  expect_identical(compute_mode(c(NA, 1), ties_method = "last", na_rm = FALSE), 1)
})

test_that("compute_mode on empty input", {
  expect_identical(compute_mode(numeric(0), ties_method = "first"), numeric(0))
  expect_identical(compute_mode(character(0), ties_method = "first"), character(0))
  expect_identical(compute_mode(logical(0), ties_method = "random"), logical(0))
  expect_identical(compute_mode(c(NA_real_, NA_real_), ties_method = "first"), numeric(0))
  expect_identical(
    compute_mode(factor(character(0), levels = "a"), ties_method = "first"),
    factor(character(0), levels = "a")
  )
})
