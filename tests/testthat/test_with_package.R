test_that("with_package", {
  skip_if_not_installed("callr")

  before = .packages()
  expect_number(with_package("callr", { r(function() runif(1)) }), lower = 0, upper = 1)
  expect_equal(before, .packages())
})
