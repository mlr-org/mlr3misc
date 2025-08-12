test_that("errors", {
  expect_snapshot(error_input("a: %s", "b"), error = TRUE)
  expect_snapshot(error_config("abc"), error = TRUE)
  expect_snapshot(error_timeout(), error = TRUE)
  expect_snapshot(error_mlr3("abc"), error = TRUE)

  expect_class(error_input("a", signal = FALSE), "Mlr3ErrorInput")
  expect_class(error_config("a", signal = FALSE), "Mlr3ErrorConfig")
  expect_class(error_timeout(signal = FALSE), "Mlr3ErrorTimeout")
  expect_class(error_mlr3("a", signal = FALSE), "Mlr3Error")
})

test_that("warnings", {
  expect_warning(warning_config("%s & %s", "a", "b"))
  expect_snapshot(warning_config("%s & %s", "a", "b"))
  expect_class(warning_config("abc", signal = FALSE), "Mlr3WarningConfig")

  expect_class(warning_input("a", signal = FALSE), "Mlr3WarningInput")
  expect_class(warning_config("a", signal = FALSE), "Mlr3WarningConfig")
  expect_class(warning_mlr3("a", signal = FALSE), "Mlr3Warning")

  expect_warning(warning_mlr3("a"))
  expect_snapshot(warning_mlr3("a"))
  expect_class(warning_mlr3("a", signal = FALSE), "Mlr3Warning")
})

test_that("class is as expected", {
  x = try(suppressMessages(suppressWarnings(error_mlr3("a"))), silent = TRUE)
  cond = attr(x, "condition")
  expect_class(cond, "Mlr3Error")
})

test_that("bullets", {
  expect_snapshot(error_mlr3(c(i = "abc", i = "def")), error = TRUE)
})
