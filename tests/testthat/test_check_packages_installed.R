test_that("check_packages_installed", {
  expect_equal(check_packages_installed("mlr3misc"), setNames(TRUE, "mlr3misc"))
  expect_warning(check_packages_installed("this_is_not_a_package999"), "required but not installed")
  expect_warning(check_packages_installed("this_is_not_a_package999", msg = "foobar %s"), "foobar")
  expect_logical(check_packages_installed("this_is_not_a_package999", warn = FALSE))

  expect_true(tryCatch(check_packages_installed("this_is_not_a_package999"),
    packageNotFoundWarning = function(e) TRUE))
})
