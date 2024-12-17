test_that("check operators", {
  # AND operator
  expect_true(TRUE %check&&% TRUE)
  expect_error(TRUE %check&&% "error", "error")
  expect_error("error" %check&&% TRUE, "error")
  expect_error("error1" %check&&% "error2", "error1 and error2")

  expect_true(TRUE %check||% TRUE)
  expect_true(TRUE %check||% "error")
  expect_true("error" %check||% TRUE)
  expect_error("error1" %check||% "error2", "error1 or error2")

})
