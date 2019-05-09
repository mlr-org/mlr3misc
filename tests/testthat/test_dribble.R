context("rowwise_table")

test_that("construction", {
  x = rowwise_table(~a, ~b, 1, "a", 2, "b")

  expect_data_table(x, nrow = 2, ncol = 2)
  expect_names(names(x), identical.to = c("a", "b"))
  expect_equal(x$a, c(1, 2))
  expect_equal(x$b, c("a", "b"))

  expect_error(rowwise_table(1, 2), "No column names")
  expect_error(rowwise_table(~a, ~b, 1), "rectangular")
})
