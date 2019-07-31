context("keep_in_bounds")

test_that("keep_in_bounds", {
  expect_equal(keep_in_bounds(1:10, 1, 10), 1:10)
  expect_equal(keep_in_bounds(10:1, 1, 10), 10:1)

  expect_set_equal(keep_in_bounds(sample(100), 1, 10), 1:10)
  expect_equal(keep_in_bounds(NA, 1, 10), integer())
  expect_equal(keep_in_bounds(c(NA, 1L), 1, 10), 1L)
  expect_equal(keep_in_bounds(c(NA, 1L), 10, 10), integer())
  expect_equal(keep_in_bounds(11:20, 1, 10), integer())
  expect_equal(keep_in_bounds(1:10, 11, 1), integer())
  expect_equal(keep_in_bounds(-(1:10), -7, -5), -(5:7))
})
