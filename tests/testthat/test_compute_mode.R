test_that("compute_mode", {
  x = c(1, 1, 1, 2, 2, 2, 3)
  expect_identical(compute_mode(x, ties_method = "first"), 1)
  expect_identical(compute_mode(x, ties_method = "last"), 2)
  expect_subset(compute_mode(x, ties_method = "random"), c(1, 2))
  expect_identical(compute_mode(c(5L, 5L, 1L), ties_method = "first"), 5L)
  expect_identical(compute_mode(c("a", "b", "b")), "b")
  expect_identical(compute_mode(c("b", "a", "a", "b", "c"), ties_method = "first"), "b")
  expect_identical(compute_mode(c(TRUE, TRUE, FALSE), ties_method = "first"), TRUE)
  expect_identical(compute_mode(as.raw(c(1, 2, 2))), as.raw(2))
  expect_error(compute_mode(list(1, 2)), "atomic")

  expect_identical(
    compute_mode(factor(c("b", "a", "a"), levels = c("a", "b", "z")), ties_method = "first"),
    factor("a", levels = c("a", "b", "z"))
  )
})

test_that("compute_mode NA handling", {
  expect_identical(compute_mode(c(NA, NA, 1)), 1)
  expect_identical(compute_mode(c(NA, NA, 1), na_rm = FALSE), NA_real_)
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

test_that("compute_mode on long input", {
  x = rep(c("b", "a", "c"), c(5e4, 5e4, 1e4))
  expect_identical(compute_mode(x, ties_method = "first"), "b")
  expect_identical(compute_mode(x, ties_method = "last"), "a")
  f = factor(x, levels = c("c", "b", "a", "z"))
  expect_identical(compute_mode(f, ties_method = "first"), factor("b", levels = levels(f)))
  expect_identical(compute_mode(as.raw(rep(1:2, c(5e4, 6e4)))), as.raw(2))
})
