test_that("count_missing", {
  expect_equal(count_missing(1), 0)
  expect_equal(count_missing(integer()), 0)
  expect_equal(count_missing(NA), 1)
  expect_equal(count_missing(c(1, NA)), 1)

  expect_equal(count_missing(NA), 1)
  expect_equal(count_missing(NA_integer_), 1)
  expect_equal(count_missing(NA_real_), 1)
  expect_equal(count_missing(NA_complex_), 1)
  expect_equal(count_missing(NA_character_), 1)
})
