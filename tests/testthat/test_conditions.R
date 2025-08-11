test_that("errors", {
  expect_error(error_config("a: %s", "b"), "a: b")
  expect_snapshot_error(error_config("abc"))
  expect_error(error_timeout(), "reached elapsed time limit")
  expect_snapshot_error(error_timeout())
})

test_that("warnings", {
  expect_snapshot_warning(warning_config("%s & %s", "a", "b"))
  expect_warning(warning_config("abc"))
})
