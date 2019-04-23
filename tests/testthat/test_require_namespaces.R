context("require_namespaces")

test_that("require_namespaces", {
  expect_equal(require_namespaces("mlr3misc"), "mlr3misc")
  expect_equal(require_namespaces("checkmate"), "checkmate")
  expect_error(require_namespaces("this_is_not_a_package999"), "not be loaded", class = "packageNotFoundError")

  expect_true(tryCatch(require_namespaces("this_is_not_a_package999"),
    packageNotFoundError = function(e) TRUE))

  expect_equal(tryCatch(require_namespaces("this_is_not_a_package999"),
    packageNotFoundError = function(e) e$packages), "this_is_not_a_package999")
})
