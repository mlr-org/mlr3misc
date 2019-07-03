context("Dictionary")

test_that("Dictionary registry", {
  Foo = R6::R6Class("Foo", public = list(x = 0, id = NULL, initialize = function(x) self$x = x), cloneable = TRUE)
  d = Dictionary$new()
  expect_identical(d$keys(), character(0L))

  f1 = Foo
  f2 = Foo

  expect_false(d$has("f1"))


  register_dictionary("test", "f1", f1)
  register_dictionary("test", "f2", f2)

  expect_list(environment()[[".registry_test"]])

  expect_false(d$has("f1"))

  publish_registered_dictionary("test", d$add, environment())

  expect_false(exists(".registry_test", environment()))

  expect_true(d$has("f1"))
  f1c = d$get("f1", x = 1)
  expect_list(d$mget("f1", x = 1), names = "unique", len = 1, types = "Foo")

  expect_set_equal(d$keys(), c("f1", "f2"))
  expect_list(d$mget(c("f1", "f2"), x = 1), names = "unique", len = 2, types = "Foo")
})

test_that("Dictionary required args", {
  x = Dictionary$new()
  x$add("a", 1)
  x$add("b", 2, required_args = "c")

  expect_equal(x$required_args("a"), character())
  expect_equal(x$required_args("b"), "c")
  expect_equal(x$required_args("c"), NULL)
})
