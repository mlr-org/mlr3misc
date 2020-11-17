test_that("formulate", {
  f = formulate("Species", c("Sepal.Width", "Petal.Length"))
  expect_formula(f)
  expect_null(environment(f))

  x = extract_vars(f)
  expect_set_equal(x$lhs, "Species")
  expect_set_equal(x$rhs, c("Sepal.Width", "Petal.Length"))
})

test_that("formulate_multioutput", {
  f = formulate(c("Pepal.Width", "Petal.Length"), c("Sepal.Width", "Sepal.Length"))
  expect_formula(f)
  expect_null(environment(f))

  x = extract_vars(f)
  expect_set_equal(x$lhs, c("Pepal.Width", "Petal.Length"))
  expect_set_equal(x$rhs, c("Sepal.Width", "Sepal.Length"))
})
