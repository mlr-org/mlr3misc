test_that("construction", {
  x = rowwise_table(~a, ~b, 1, "a", 2, "b")

  expect_data_table(x, nrows = 2, ncols = 2)
  expect_names(names(x), identical.to = c("a", "b"))
  expect_equal(x$a, c(1, 2))
  expect_equal(x$b, c("a", "b"))

  expect_error(rowwise_table(1, 2), "No column names")
  expect_error(rowwise_table(~a, ~b, 1), "rectangular")

  x = rowwise_table(~a, ~b, 1, "a", 2, "b", .key = "b")
  expect_data_table(x, nrows = 2, ncols = 2, key = "b")
})
