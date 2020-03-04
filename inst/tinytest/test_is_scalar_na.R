source("setup.R")
using("checkmate")


expect_true(is_scalar_na(NA))
expect_false(is_scalar_na(1))
expect_false(is_scalar_na(iris))
expect_false(is_scalar_na(NULL))
expect_false(is_scalar_na("NA"))
