context("shuffle")

test_that("shuffle", {
  x = shuffle(1:3)
  expect_true(setequal(x, 1:3))

  x = shuffle(10L)
  expect_identical(x, 10L)

  expect_error(shuffle(10L, 2L))
})
