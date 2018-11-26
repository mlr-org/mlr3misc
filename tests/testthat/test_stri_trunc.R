context("stri_trunc")

test_that("stri_trunc", {
  expect_equal(stri_trunc("abcdefghij", 7), "ab[...]")
  expect_equal(stri_trunc("abcdef", 7), "abcdef")
  expect_equal(stri_trunc("abcdef", 6), "abcdef")
  expect_equal(stri_trunc("abcdef", 5), "[...]")
  expect_error(stri_trunc("abcdef", 2))

  expect_equal(stri_trunc(NA_character_, 5), NA_character_)
})
