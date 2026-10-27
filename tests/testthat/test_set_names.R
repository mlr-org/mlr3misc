test_that("set_names", {
  x = 1:3
  expect_names(names(x), "unnamed")

  x = set_names(x, letters[1:3])
  expect_set_equal(names(x), letters[1:3])

  x = set_names(x, toupper)
  expect_set_equal(names(x), LETTERS[1:3])

  x = letters[1:3]
  x = set_names(x)
  expect_equal(unname(x), names(x))
})

test_that("set_col_names", {
  x = iris[, 1:3]

  x = set_col_names(x, letters[1:3])
  expect_set_equal(names(x), letters[1:3])

  x = set_col_names(x, toupper)
  expect_set_equal(names(x), LETTERS[1:3])
})

test_that("set_names and set_col_names pass ... to nm", {
  x = set_names(c(a = 1, b = 2), paste0, "_x")
  expect_equal(names(x), c("a_x", "b_x"))

  x = set_col_names(data.frame(a = 1, b = 2), paste0, "_x")
  expect_equal(names(x), c("a_x", "b_x"))
})
