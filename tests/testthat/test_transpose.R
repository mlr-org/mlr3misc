context("transpose_list")

test_that("transpose_list", {
  x = list(list(a = 2, b = 3), list(a = 5, b = 10))
  expect_equal(transpose_list(x), list(a = list(2, 5), b = list(3, 10)))

  x = list(a = list())
  expect_equal(transpose_list(x), list())
})
