test_that("warn_deprecated warns once", {
  rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db)
  on.exit(rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db))

  expect_warning(warn_deprecated("TestClass$foo()"), "TestClass\\$foo\\(\\) is deprecated")
  expect_silent(warn_deprecated("TestClass$foo()"))
})

test_that("warn_deprecated has correct class", {
  rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db)
  on.exit(rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db))

  w = tryCatch(warn_deprecated("TestClass$bar()"), warning = identity)
  expect_class(w, "Mlr3WarningDeprecated")
})

test_that("warn_deprecated respects option", {
  rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db)
  on.exit(rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db))

  expect_silent(invoke(warn_deprecated, "TestClass$baz()", .opts = list(mlr3.warn_deprecated = FALSE)))
})

test_that("deprecated_binding works in R6 class", {
  rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db)
  on.exit(rm(list = ls(deprecated_warning_given_db), envir = deprecated_warning_given_db))

  MyClass = R6::R6Class("MyClass", public = list(),
    active = list(
      foo = deprecated_binding("MyClass$foo", "bar")
    )
  )

  mco = MyClass$new()
  expect_warning(val <- mco$foo, "MyClass\\$foo is deprecated")
  expect_equal(val, "bar")

  # second access should not warn
  expect_silent(mco$foo)

  # write access should error
  expect_error(mco$foo <- "baz", "MyClass\\$foo read-only")
})
