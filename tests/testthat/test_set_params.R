skip_if_not_installed("paradox")

test_that("set_params checks inputs correctly", {
  .ps = paradox::ps(a = paradox::p_dbl(), b = paradox::p_dbl())
  expect_error(set_params(.ps, a = 2, .values = list(a = 1)))
  expect_error(set_params(.ps, 2))
  expect_error(set_params(.ps, .values = list(1)))
})

test_that("set_params works for ... with correct inputs", {
  .ps = paradox::ps(a = paradox::p_dbl(), b = paradox::p_dbl())
  .ps$values$a = 1
  set_params(.ps, b = 2, .insert = FALSE)
  expect_true(is.null(.ps$values$a))
  expect_true(.ps$values$b == 2)
  .ps$values = list(a = 1)
  set_params(.ps, b = 2, .insert = TRUE)
  expect_true(.ps$values$b == 2)
  expect_true(.ps$values$a == 1)
})

test_that("set_params works for .values with correct inputs", {
  .ps = paradox::ps(a = paradox::p_dbl(), b = paradox::p_dbl())
  .ps$values$a = 1
  set_params(.ps, .values = list(b = 2), .insert = FALSE)
  expect_true(is.null(.ps$values$a))
  expect_true(.ps$values$b == 2)
  .ps$values = list(a = 1)
  set_params(.ps, .values = list(b = 2), .insert = TRUE)
  expect_true(.ps$values$b == 2)
  expect_true(.ps$values$a == 1)
})

test_that("set_params works for .values and ... with correct inputs", {
  .ps = paradox::ps(a = paradox::p_dbl(), b = paradox::p_dbl(), c = paradox::p_dbl())
  .ps$values$a = 1
  set_params(.ps, b = 2, .values = list(c = 3), .insert = TRUE)
  expect_true(.ps$values$a == 1)
  expect_true(.ps$values$b == 2)
  expect_true(.ps$values$c == 3)

  .ps$values = list(a = 1)
  set_params(.ps, b = 2, .values = list(c = 3), .insert = FALSE)
  expect_true(is.null(.ps$values$a))
  expect_true(.ps$values$b == 2)
  expect_true(.ps$values$c == 3)
})
