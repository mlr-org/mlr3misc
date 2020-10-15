test_that("str_trunc", {
  expect_equal(str_trunc("abcdefghij", 7), "ab[...]")
  expect_equal(str_trunc("abcdef", 7), "abcdef")
  expect_equal(str_trunc("abcdef", 6), "abcdef")
  expect_equal(str_trunc("abcdef", 5), "[...]")
  expect_error(str_trunc("abcdef", 2))

  expect_equal(str_trunc(NA_character_, 5), NA_character_)
})
