test_that("ids", {
  Foo = R6::R6Class("Foo", public = list(id = NULL, initialize = function(id) self$id = id), cloneable = TRUE)
  f1 = Foo$new("f1")
  f2 = Foo$new("f2")
  xs = list(f1, f2)
  expect_equal(ids(xs), c("f1", "f2"))
  expect_equal(ids(list()), character())
})
