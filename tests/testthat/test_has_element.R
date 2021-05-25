test_that("has_element", {
  xs = list()
  expect_false(has_element(xs, NULL))
  expect_false(has_element(xs, NA))
  expect_false(has_element(xs, list()))
  xs = list(1, iris, NULL)
  expect_true(has_element(xs, NULL))
  expect_false(has_element(xs, NA))
  expect_false(has_element(xs, list()))
  expect_true(has_element(xs, iris))
  x = iris
  expect_true(has_element(xs, x))
  x[1, 1] = 123
  expect_false(has_element(xs, x))
})

test_that("has_element with R6", {
  Foo = R6Class("Foo",
    public = list(
      bar = 123,
      initialize = function(b) {
        self$bar = b
      }
    )
  )
  f1 = Foo$new(1)
  f2 = Foo$new(2)
  f3 = Foo$new(3)
  xs = list(1, f1, f2)
  expect_true(has_element(xs, 1))
  expect_true(has_element(xs, f1))
  expect_false(has_element(xs, f1$clone()))
  expect_false(has_element(xs, f3))
})
