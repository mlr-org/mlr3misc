context("Dictionary")

test_that("Dictionary", {
  Foo = R6::R6Class("Foo", public = list(x = 0, id = NULL, initialize = function(x) self$x = x), cloneable = TRUE)
  d = Dictionary$new()
  expect_identical(d$keys(), character(0L))

  f1 = Foo
  f2 = Foo

  expect_false(d$has("f1"))
  d$add("f1", f1)
  expect_identical(d$keys(), "f1")
  expect_true(d$has("f1"))
  f1c = d$get("f1", x = 1)
  expect_list(d$mget("f1", x = 1), names = "unique", len = 1, types = "Foo")

  d$add("f2", f2)
  expect_set_equal(d$keys(), c("f1", "f2"))
  expect_list(d$mget(c("f1", "f2"), x = 1), names = "unique", len = 2, types = "Foo")

  d$remove("f2")
  expect_set_equal(d$keys(), "f1")
  expect_false(d$has("f2"))

  expect_data_table(as.data.table(d), nrows = 1L)
})

test_that("Dictionary required args", {
  foo = R6Class("Foo", public = list(x = 0))
  x = Dictionary$new()
  x$add("a", foo)
  x$add("b", foo, required_args = "c")

  expect_equal(x$required_args("a"), character())
  expect_equal(x$required_args("b"), "c")
  expect_equal(x$required_args("c"), NULL)
})

test_that("Dictionary throws exception on unnamed args", {
  foo = R6Class("Foo", public = list(x = 0))
  x = Dictionary$new()
  x$add("a", foo)
  x$add("b", foo)

  expect_error(x$get("a", 1), "names")
  expect_error(x$mget("a", "b"), "names")
})

test_that("dictionary_sugar_get", {
  Foo = R6::R6Class("Foo", public = list(x = 0, y = 0, key = 0, initialize = function(y, key = -1) { self$y = y ; self$key = key }), cloneable = TRUE)
  d = Dictionary$new()
  d$add("f1", Foo)
  x = dictionary_sugar_get(d, "f1", y = 99, x = 1)
  expect_equal(x$x, 1)
  expect_equal(x$y, 99)
  expect_equal(x$key, -1)
  x2 = dictionary_sugar_get(d, "f1", 99, x = 1)
  expect_equal(x, x2)
  x2 = dictionary_sugar_get(d, "f1", x = 1, 99)
  expect_equal(x, x2)

  x = dictionary_sugar_get(d, "f1", 1, 99)
  expect_equal(x$x, 0)
  expect_equal(x$y, 1)
  expect_equal(x$key, 99)
  x2 = dictionary_sugar_get(d, "f1", key = 99, y = 1)
  expect_equal(x, x2)
})

test_that("mget", {
  Foo = R6::R6Class("Foo", public = list(id = "foo", x = 0, y = 0, key = 0, initialize = function(y, key = -1) { self$y = y ; self$key = key }), cloneable = TRUE)
  d = Dictionary$new()
  d$add("f1", Foo)
  d$add("f2", Foo)
  x = dictionary_sugar_mget(d, "f1", y = 99, x = 1)
  expect_list(x, len = 1, types = "Foo")
  x = dictionary_sugar_mget(d, c("f1", "f2"), y = 99)
  expect_list(x, len = 2, types = "Foo")
  expect_equal(ids(x), c("foo", "foo"))

  x = dictionary_sugar_mget(d, c(a = "f1", b = "f2"), y = 99)
  expect_list(x, len = 2, types = "Foo")
  expect_equal(ids(x), c("a", "b"))
})
