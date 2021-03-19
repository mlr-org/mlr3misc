test_that("reorder_vector", {
  x = c(letters[3:1], "a")
  y = letters
  res = reorder_vector(x, y)
  expect_character(res, sorted = TRUE, unique = TRUE, any.missing = FALSE)

  x = letters[3:1]
  y = c("a", "b", "a")
  res = reorder_vector(x, y)
  expect_character(res, sorted = TRUE, unique = TRUE, any.missing = FALSE)


  x = c("b", "a", "c", "d")
  y = letters[1:3]
  expect_character(reorder_vector(x, y), sorted = TRUE, unique = TRUE, any.missing = FALSE)
  expect_character(reorder_vector(x, y, na_last = TRUE), unique = TRUE, any.missing = FALSE)
  expect_character(reorder_vector(x, y, na_last = FALSE), unique = TRUE, any.missing = FALSE)

  x = factor(letters[3:1], levels = letters[3:1])
  y = factor(letters[1:5])
  res = reorder_vector(x, y)
  expect_factor(res, levels = letters[3:1], any.missing = FALSE)
  expect_equal(as.character(res), letters[1:3])

  x = factor(letters[3:1], levels = letters[3:1])
  y = factor(letters[1:2])
  res = reorder_vector(x, y)
  expect_factor(res, levels = letters[3:1], any.missing = FALSE)
  expect_equal(as.character(res), as.character(y))
})
