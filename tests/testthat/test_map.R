test_that("map (lapply)", {
  x = 1:2
  names(x) = letters[1:2]
  expect_identical(map(x, identity), list(a = 1L, b = 2L))

  x = c(TRUE, FALSE)
  names(x) = letters[1:2]
  expect_identical(map_lgl(x, identity), x)

  x = 1:2
  names(x) = letters[1:2]
  expect_identical(map_int(x, identity), x)

  x = 1:2 + 0.5
  names(x) = letters[1:2]
  expect_identical(map_dbl(x, identity), x)

  x = letters[1:2]
  names(x) = letters[1:2]
  expect_identical(map_chr(x, identity), x)
})

test_that("map (extract)", {
  x = list(list(a = 1L, b = 1L), list(a = 2L))
  expect_identical(map(x, "a"), list(1L, 2L))
  expect_identical(map(x, 1L), list(1L, 2L))
  expect_identical(map(x, "b"), list(1L, NULL))
  expect_error(map(x, 2L))

  expect_identical(map_int(x, "a"), 1:2)
  expect_identical(map_int(x, 1L), 1:2)
  expect_error(map_int(x, "b"))
})

test_that("imap", {
  x = list(a = 1, b = 2)
  fun = function(x, y) sprintf("%s:%i", y, x)
  res = imap(x, fun)
  expect_list(res, len = 2, names = "unique")
  expect_equal(res$a, "a:1")
  expect_equal(res$b, "b:2")

  res = imap_chr(x, fun)
  expect_character(res, len = 2)
  expect_named(res, c("a", "b"))
  expect_equal(unname(res), c("a:1", "b:2"))

  x = list(1L, 2L)
  fun = function(x, y) x + y
  res = imap(x, fun)
  expect_list(res, len = 2, names = "unnamed")
  expect_identical(res[[1]], 2L)
  expect_identical(res[[2]], 4L)

  res = imap_int(x, fun)
  expect_identical(res, c(2L, 4L))
})

test_that("pmap", {
  x = list(a = 1:2, b = 2:1)
  fun = function(a, b) c(a, b)
  res = pmap(x, fun)
  expect_list(res, len = 2, names = "unnamed")
  expect_equal(res[[1]], 1:2)
  expect_equal(res[[2]], 2:1)

  fun = function(a, b) a + b
  res = pmap(x, fun)
  expect_identical(res, list(3L, 3L))

  res = pmap_int(x, fun)
  expect_identical(res, c(3L, 3L))
})

test_that("map_dtr", {
  x = list(list(a = 1L), list(a = 2L))
  expect_data_table(map_dtr(x, identity), nrows = 2, ncols = 1)

  x = list(data.table(a = 1L), data.table(a = 2L))
  expect_data_table(map_dtr(x, identity), nrows = 2, ncols = 1)

  x = list(x = data.table(a = 1L), y = data.table(b = 2L))
  res = map_dtr(x, identity, .fill = TRUE)
  expect_data_table(res, nrows = 2L, ncols = 2L)
  expect_names(names(res), identical.to = c("a", "b"))

  x = list(data.table(a = 1L), data.table(a = 2L))
  res = map_dtr(x, identity, .idcol = "id")
  expect_data_table(res, nrows = 2L, ncols = 2L)
  expect_names(names(res), identical.to = c("id", "a"))
  expect_equal(res$id, 1:2)
})

test_that("map_dtc", {
  x = list(a = 1L, b = 2L)
  res = map_dtc(x, identity)
  expect_data_table(res, nrows = 1, ncols = 2)
  expect_names(names(res), identical.to = names(x))

  x = list(data.table(a = 1L, b = 1L), data.table(c = 2L))
  res = map_dtc(x, identity)
  expect_data_table(res, nrows = 1, ncols = 3)
  expect_names(names(res), identical.to = c("a", "b", "c"))

  x = list(data.table(a = 1L, b = 1L), data.table(b = 2L))
  res = map_dtc(x, identity)
  expect_data_table(res, nrows = 1, ncols = 3)
  expect_names(names(res), identical.to = c("a", "b", "b.1"))

  # check that map_dtc doesnt prefix colnames in result
  x = list(a = list(1, 2), b = list(3, 4))
  expect_data_table(map_dtc(x, identity), nrows = 2, ncols = 2)

  # check that map_dtc doesn't prefix colnames in result
  x = list(foo = data.table(a = 1L, b = 1L), bar = data.table(c = 2L))
  res = map_dtc(x, identity)
  expect_data_table(res, nrows = 1, ncols = 3)
  expect_names(names(res), identical.to = c("a", "b", "c"))

  x = list(foo = data.frame(a = 1L, b = 1L), c = 2)
  res = map_dtc(x, identity)
  expect_data_table(res, nrows = 1, ncols = 3)
  expect_names(names(res), identical.to = c("a", "b", "c"))
})

test_that("map_if", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = map_if(x, is.numeric, length)
  expect_equal(out, set_names(list(3L, c("a", "b"), 3L), names(x)))

  x = iris
  out = map_if(x, is.numeric, sqrt)
  expect_equal(out$Sepal.Length, sqrt(x$Sepal.Length))

  x = as.data.table(iris)
  out = map_if(x, is.numeric, sqrt)
  expect_equal(out$Sepal.Length, sqrt(x$Sepal.Length))
})

test_that("map_at", {
  x = iris
  x = map_at(x, c("Sepal.Length", "Sepal.Width"), as.integer)
  expect_data_frame(x, nrows = 150, ncols = 5)
  expect_equal(unname(map_chr(x, class)), c("integer", "integer", "numeric", "numeric", "factor"))

  x = as.data.table(iris)
  x = map_at(x, c("Sepal.Length", "Sepal.Width"), as.integer)
  expect_data_table(x, nrows = 150, ncols = 5)
  expect_equal(unname(map_chr(x, class)), c("integer", "integer", "numeric", "numeric", "factor"))
})

test_that("keep", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = keep(x, is.numeric)
  expect_list(out, len = 2L)
  expect_named(out, c("a", "c"))

  x = iris
  out = keep(x, is.numeric)
  expect_data_frame(out, types = "numeric")

  x = as.data.table(iris)
  out = keep(x, is.numeric)
  expect_data_table(out, types = "numeric")
})

test_that("discard", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = discard(x, is.numeric)
  expect_list(out, len = 1L)
  expect_named(out, "b")

  x = iris
  out = discard(x, is.numeric)
  expect_data_frame(out, types = "factor")

  x = as.data.table(iris)
  out = discard(x, is.numeric)
  expect_data_table(out, types = "factor")
})

test_that("some/every", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  expect_true(some(x, is.numeric))
  expect_false(every(x, is.numeric))
  expect_false(some(x, is.complex))
  expect_false(every(x, is.complex))

  x = list(list(p = TRUE, x = 1), list(p = FALSE, x = 2))
  expect_true(some(x, "p"))
  expect_false(every(x, "p"))
})

test_that("detect", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = detect(x, is.numeric)
  expect_equal(out, 1:3)
  out = detect(x, is.character)
  expect_equal(out, c("a", "b"))
  out = detect(x, is.logical)
  expect_null(out)
})

test_that("compact", {
  x = list(a = 1:3, b = c("a", "b"), c = NULL, d = NULL)
  out = compact(x)
  expect_identical(out, x[1:2])
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = compact(x)
  expect_identical(out, x)
})

test_that("pmap does not segfault (#56)", {
  expect_error(pmap(1:4, function(x) x), "list")
})

test_that("walk", {
  .x = list(a = 1, b = 2)
  sq = function(x) x^2
  expect_equal(walk(.x, sq), .x)
})

test_that("iwalk", {
  .x = list(a = 1, b = 2)
  sq = function(x, name) x^2
  expect_equal(iwalk(.x, sq), .x)
})

test_that("pwalk", {
  .x = list(a = 1:3, b = 2)
  f = function(a, b) a + b
  expect_equal(pwalk(.x, f), .x)
})

test_that("map_br / map_bc", {
  .x = list(1:3, 4:6, 7:9)

  expect_equal(
    map_bc(.x, identity),
    matrix(1:9, nrow = 3, byrow = FALSE)
  )

  expect_equal(
    map_br(.x, identity),
    matrix(1:9, nrow = 3, byrow = TRUE)
  )
})
