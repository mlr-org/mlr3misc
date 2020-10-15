test_that("extract_vars", {
  f = Species ~ Sepal.Width > 1 + Petal.Length
  x = extract_vars(f)

  expect_list(x, len = 2L)
  expect_names(names(x), identical.to = c("lhs", "rhs"))
  expect_set_equal(x$lhs, "Species")
  expect_set_equal(x$rhs, c("Sepal.Width", "Petal.Length"))
})
