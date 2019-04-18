context("get_seed")

test_that("get_seed", {
  expect_integer(get_seed(), any.missing = FALSE, min.len = 1L)
})
