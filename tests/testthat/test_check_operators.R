test_that("check operators", {
  # AND operator
  expect_true(TRUE %check&&% TRUE)
  expect_equal(TRUE %check&&% "error", "error")
  expect_equal("error" %check&&% TRUE, "error")
  expect_equal("error1" %check&&% "error2", "error1, and error2")

  # OR operator
  expect_true(TRUE %check||% TRUE)
  expect_true(TRUE %check||% "error")
  expect_true("error" %check||% TRUE)
  expect_equal("error1" %check||% "error2", "error1, or error2")
})
