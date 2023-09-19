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

test_that("Dictionary clones R6", {
  foo = R6Class("Foo")$new()
  d = Dictionary$new()
  d$add("f", foo)
  expect_false(data.table::address(foo) == data.table::address(d$get("f")))
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

test_that("dictionary_sugar_get_safe", {
  Foo = R6::R6Class("Foo", public = list(x = 0, y = 0, key = 0, initialize = function(y, key = -1) {
    self$y = y
    self$key = key
  }), cloneable = TRUE)
  d = Dictionary$new()
  d$add("f1", Foo)
  x = dictionary_sugar_get_safe(d, "f1", y = 99, x = 1)
  expect_equal(x$x, 1)
  expect_equal(x$y, 99)
  expect_equal(x$key, -1)
  x2 = dictionary_sugar_get_safe(d, "f1", 99, x = 1)
  expect_equal(x, x2)
  x2 = dictionary_sugar_get_safe(d, "f1", x = 1, 99)
  expect_equal(x, x2)

  x = dictionary_sugar_get_safe(d, "f1", 1, 99)
  expect_equal(x$x, 0)
  expect_equal(x$y, 1)
  expect_equal(x$key, 99)
  x2 = dictionary_sugar_get_safe(d, "f1", key = 99, y = 1)
  expect_equal(x, x2)
})

test_that("mget", {
  Foo = R6::R6Class("Foo", public = list(id = "foo", x = 0, y = 0, key = 0, initialize = function(y, key = -1) {
    self$y = y
    self$key = key
  }), cloneable = TRUE)
  d = Dictionary$new()
  d$add("f1", Foo)
  d$add("f2", Foo)
  x = dictionary_sugar_mget_safe(d, "f1", y = 99, x = 1)
  expect_list(x, len = 1, types = "Foo")
  x = dictionary_sugar_mget_safe(d, c("f1", "f2"), y = 99)
  expect_list(x, len = 2, types = "Foo")
  expect_equal(ids(x), c("foo", "foo"))

  x = dictionary_sugar_mget_safe(d, c(a = "f1", b = "f2"), y = 99)
  expect_list(x, len = 2, types = "Foo")
  expect_equal(ids(x), c("a", "b"))
})

test_that("incrementing ids works", {
  d = Dictionary$new()
  d$add("a", R6Class("A", public = list(id = "a")))
  d$add("b", R6Class("B", public = list(id = "c")))
  obj1 = dictionary_sugar_inc_get_safe(d, "a_1")
  expect_r6(obj1, "A")
  expect_true(obj1$id == "a_1")

  obj2 = dictionary_sugar_inc_get_safe(d, "b_1")
  expect_r6(obj2, "B")
  expect_true(obj2$id == "c_1")

  objs = dictionary_sugar_inc_mget_safe(d, c("a_10", "b_2"))
  expect_r6(objs$a_10, "A")
  expect_true(objs$a_10$id == "a_10")
  expect_r6(objs$c_2, "B")
  expect_true(objs$c_2$id == "c_2")

  objs = dictionary_sugar_inc_mget(d, c("a", "b_1"))
  expect_identical(ids(objs), c("a", "c_1"))

  obj = dictionary_sugar_inc_get(d, "a")
  expect_class(obj, "A")
})

test_that("avoid unintended partial argument matching", {
  d = Dictionary$new()
  A = R6Class("A", public = list(d = NULL))
  d$add("a", function() A$new())
  a = dictionary_sugar_get_safe(d, "a", d = 1)
  expect_r6(a, "A")
  expect_equal(a$d, 1)
})
