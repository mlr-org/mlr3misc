source("setup.R")
using("checkmate")


expect_equal(require_namespaces("mlr3misc"), "mlr3misc")
expect_equal(require_namespaces("checkmate"), "checkmate")

expect_true(tryCatch(require_namespaces("this_is_not_a_package999"),
    packageNotFoundError = function(e) TRUE))

expect_equal(tryCatch(require_namespaces("this_is_not_a_package999"),
    packageNotFoundError = function(e) e$packages), "this_is_not_a_package999")
