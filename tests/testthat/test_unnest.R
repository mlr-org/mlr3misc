context("unnest")

test_that("unnest", {
  x = data.table(id = 1:2, x = list(list(a = 1L), list(a = 2L, b = 2L)))
  expect_data_table(x, ncols = 2, nrows = 2)
  x = unnest(x, "x")
  expect_data_table(x, ncols = 3, nrows = 2)
  expect_null(x$x)
  expect_equal(x$a, 1:2)
  expect_equal(x$b, c(NA, 2L))

  x = data.table(id = 1:2, x = list(list(a = 1L), list(a = 2L, b = 2L)))
  x = unnest(x, "x", prefix = "par.")
  expect_data_table(x, ncols = 3, nrows = 2)
  expect_null(x$x)
  expect_equal(x$par.a, 1:2)
  expect_equal(x$par.b, c(NA, 2L))
})

test_that("unnest with empty rows", {
  x = data.table(id = 1:2, x = list(list(a = 1), list()))
  col = "x"
  expect_data_table(x, ncols = 2, nrows = 2)
  x = unnest(x, "x")
  expect_data_table(x, ncols = 2, nrows = 2)
})

test_that("unnest with nested lists", {
  x = data.table(
    id = 1:2,
    p1 = list(list(mtry = 1L, ctrl = list(eps = 0.1)), list(mtry = 2L, ctrl = list(eps = 0.2))),
    p2 = list(list(mtry = 1L, aggr = mean), list(mtry = 2L, aggr = median))
  )

  tab = unnest(copy(x), "p1")
  expect_data_table(tab, nrows = 2L)
  expect_names(names(tab), permutation.of = c("id", "p2", "mtry", "ctrl"))
  expect_integer(tab$mtry, any.missing = FALSE)
  expect_list(tab$ctrl, any.missing = FALSE)
  expect_list(tab$p2, any.missing = FALSE)

  unnest(tab, "ctrl")
  expect_data_table(tab, nrows = 2L)
  expect_names(names(tab), permutation.of = c("id", "p2", "mtry", "eps"))
  expect_double(tab$eps, any.missing = FALSE)

  tab = unnest(copy(x), "p2")
  expect_data_table(tab, nrows = 2L)
  expect_names(names(tab), permutation.of = c("id", "p1", "mtry", "aggr"))
  expect_integer(tab$mtry, any.missing = FALSE)
  expect_list(tab$aggr, "function", any.missing = FALSE)
})

test_that("prefix with placeholder", {
  x = data.table(
    id = 1:2,
    p1 = list(list(mtry = 1L, ctrl = list(eps = 0.1)), list(mtry = 2L, ctrl = list(eps = 0.2))),
    p2 = list(list(mtry = 1L, aggr = mean), list(mtry = 2L, aggr = median))
  )

  expect_data_table(unnest(x, c("p1", "p2"), prefix = "{col}."))
})
