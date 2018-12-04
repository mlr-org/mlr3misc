context("map")

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

  x = 1:2+0.5
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
  res = imap(x, function(x, y) sprintf("%s:%i", y, x))
  expect_list(res, len = 2, names = "unique")
  expect_equal(res$a, "a:1")
  expect_equal(res$b, "b:2")

  x = list(1, 2)
  res = imap(x, function(x, y) sprintf("%s:%i", y, x))
  expect_list(res, len = 2, names = "unnamed")
  expect_equal(res[[1]], "1:1")
  expect_equal(res[[2]], "2:2")
})

test_that("pmap", {
  x = list(a = 1:2, b = 2:1)
  res = pmap(x, function(a, b) c(a, b))
  expect_list(res, len = 2, names = "unnamed")
  expect_equal(res[[1]], 1:2)
  expect_equal(res[[2]], 2:1)
})

test_that("map_dtr", {
  x = list(list(a = 1L), list(a = 2L))
  expect_data_table(map_dtr(x, identity), nrow = 2, ncol = 1)

  x = list(data.table(a = 1L), data.table(a = 2L))
  expect_data_table(map_dtr(x, identity), nrow = 2, ncol = 1)
})

test_that("map_dtc", {
  x = list(a = 1L, b = 2L)
  res = map_dtc(x, identity)
  expect_data_table(res, nrow = 1, ncol = 2)
  expect_names(names(res), identical.to = names(x))

  x = list(data.table(a = 1L), data.table(b = 2L))
  res = map_dtc(x, identity)
  expect_data_table(res, nrow = 1, ncol = 2)
  expect_names(names(res), identical.to = names(x))
})

test_that("map_if", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = map_if(x, is.numeric, length)
  expect_equal(out, set_names(list(3L, c("a", "b"), 3L), names(x)))
})

test_that("keep", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = keep(x, is.numeric)
  expect_list(out, len = 2L)
  expect_equal(names(out), c("a", "c"))
})

test_that("discard", {
  x = list(a = 1:3, b = c("a", "b"), c = runif(3))
  out = discard(x, is.numeric)
  expect_list(out, len = 1L)
  expect_equal(names(out), c("b"))
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
