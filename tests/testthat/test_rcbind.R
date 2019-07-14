context("rcbind")

test_that("rcbind", {
  x = data.table(a = 1:3)
  y = data.table(b = 3:1)
  x = rcbind(x, y)
  expect_data_table(x, nrows = 3, ncols = 2, any.missing = FALSE)
  expect_identical(x$a, 1:3)
  expect_identical(x$b, 3:1)
})
