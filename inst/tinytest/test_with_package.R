source("setup.R")
using("checkmate")


if (requireNamespace("callr", quietly = TRUE)) {
  before = .packages()
  expect_number(with_package("callr", { r(function() runif(1)) }), lower = 0, upper = 1)
  expect_equal(before, .packages())
}
