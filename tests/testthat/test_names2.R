test_that("names2", {
  x = 1:3
  expect_identical(names2(x), rep.int(NA_character_, 3))

  names(x)[1] = letters[1]
  expect_identical(names2(x), c("a", rep.int(NA_character_, 2)))
  expect_identical(names2(x, ""), c("a", rep.int("", 2)))

  names(x) = letters[1:3]
  expect_identical(names(x), names2(x))
})
