context("ref_cbind")

test_that("ref_cbind", {
  x = data.table(a = 1:3)
  y = data.table(b = 3:1)
  x = ref_cbind(x, y)
  expect_data_table(x, nrow = 3, ncol = 2, any.missing = FALSE)
  expect_identical(x$a, 1:3)
  expect_identical(x$b, 3:1)
})
