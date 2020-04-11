context("rcbind")

test_that("rcbind", {
  x = data.table(a = 1:3)
  y = data.table(b = 3:1)
  x = rcbind(x, y)
  expect_data_table(x, nrows = 3, ncols = 2, any.missing = FALSE)
  expect_identical(x$a, 1:3)
  expect_identical(x$b, 3:1)
})

test_that("y as column name in x (#42)", {
  a = data.table(y = list(0), opt_x = list(list(z_1 = 100, z_2 = 200)))
  res = unnest(a, "opt_x")
  expect_equal(res, data.table(y = list(0), z_1 = 100, z_2 = 200))
})
