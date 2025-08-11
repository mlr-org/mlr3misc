test_that("errors", {
  expect_error(error_config("test: %s", "a"), "test: a")
  expect_error(error_timeout(), "reached elapsed time limit")
})
