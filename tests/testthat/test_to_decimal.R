test_that("to_decimal()", {
  expect_identical(
    to_decimal(c(1, 0)),
    2L
  )
  expect_identical(
    to_decimal(c(1, 1)),
    3L
  )

  expect_error(
    to_decimal(c(NA, 1)),
    "missing"
  )

  expect_equal(
    to_decimal(logical()),
    0L
  )

  expect_error(
    to_decimal(rep(TRUE, 31)),
    "for vectors with"
  )
})
