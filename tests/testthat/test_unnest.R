context("unnest")

test_that("unnest", {
  x = data.table(id = 1:2, x = list(list(a = 1L), list(a = 2L, b = 2L)))
  expect_data_table(x, ncols = 2, nrows = 2)
  unnest(x, "x")
  expect_data_table(x, ncols = 3, nrows = 2)
  expect_null(x$x)
  expect_equal(x$a, 1:2)
  expect_equal(x$b, c(NA, 2L))

  x = data.table(id = 1:2, x = list(list(a = 1L), list(a = 2L, b = 2L)))
  unnest(x, "x", prefix = "par.")
  expect_data_table(x, ncols = 3, nrows = 2)
  expect_null(x$x)
  expect_equal(x$par.a, 1:2)
  expect_equal(x$par.b, c(NA, 2L))
})

test_that("unnest with empty rows", {
  x = data.table(id = 1:2, x = list(list(a = 1), list()))
  col = "x"
  expect_data_table(x, ncols = 2, nrows = 2)
  x = unnest(x, "x")
  expect_data_table(x, ncols = 2, nrows = 2)
})
