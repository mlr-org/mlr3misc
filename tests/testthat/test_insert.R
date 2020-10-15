test_that("insert_named.list", {
  x = named_list(letters[1:3], 1)
  x = insert_named(x, list(d = 1))
  expect_list(x, len = 4L)
  expect_set_equal(names(x), letters[1:4])
  expect_equal(x$d, 1)

  x = remove_named(x, c("d", "e"))
  expect_list(x, len = 3L)
  expect_set_equal(names(x), letters[1:3])
  expect_equal(x$d, NULL)

  x = insert_named(list(), list(a = 1))
  expect_list(x, len = 1L)
  expect_equal(x$a, 1)

  x = insert_named(c(a = 1), c(b = 2))
  expect_numeric(x, len = 2L)
  expect_equal(x[["a"]], 1)
  expect_equal(x[["b"]], 2)

  x = remove_named(x, "a")
  expect_numeric(x, len = 1L)
  expect_equal(x[["b"]], 2)
})

test_that("insert_named.environment", {
  x = list2env(named_list(letters[1:3], 1))
  x = insert_named(x, list(d = 1))
  expect_environment(x, contains = letters[1:4])
  expect_equal(x$d, 1)

  x = remove_named(x, c("d", "e"))
  expect_environment(x, contains = letters[1:3])
  expect_equal(x$d, NULL)

  x = insert_named(new.env(), list(a = 1))
  expect_environment(x, contains = "a")
  expect_equal(x$a, 1)
})

test_that("insert_named.data.frame", {
  x = as.data.frame(named_list(letters[1:3], 1))
  x = insert_named(x, list(d = 1))
  expect_data_frame(x, nrows = 1, ncols = 4)
  expect_set_equal(names(x), letters[1:4])
  expect_equal(x$d, 1)

  x = remove_named(x, c("d", "e"))
  expect_data_frame(x, nrows = 1, ncols = 3)
  expect_set_equal(names(x), letters[1:3])
  expect_equal(x$d, NULL)

  x = insert_named(data.frame(), list(a = 1))
  expect_data_frame(x, nrows = 1, ncols = 1)
  expect_equal(x$a, 1)
})

test_that("insert_named.data.table", {
  x = as.data.table(named_list(letters[1:3], 1))
  x = insert_named(x, list(d = 1))
  expect_data_table(x, nrows = 1, ncols = 4)
  expect_set_equal(names(x), letters[1:4])
  expect_equal(x$d, 1)

  x = remove_named(x, c("d", "e"))
  expect_data_table(x, nrows = 1, ncols = 3)
  expect_set_equal(names(x), letters[1:3])
  expect_equal(x$d, NULL)

  x = insert_named(data.table(), list(a = 1))
  expect_data_table(x, nrows = 1, ncols = 1)
  expect_equal(x$a, 1)
})
