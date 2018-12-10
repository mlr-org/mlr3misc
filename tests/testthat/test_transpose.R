context("transpose")

test_that("transpose", {
  x = list(list(a = 2, b = 3), list(a = 5, b = 10))
  expect_equal(transpose(x), list(a = list(2, 5), b = list(3, 10)))
})
