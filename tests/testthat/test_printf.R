test_that("messagef", {
  expect_message(messagef("xxx%ixxx", 123), "xxx123xxx")
})

test_that("catf", {
  expect_output(catf("xxx%ixxx", 123), "xxx123xxx")
})

test_that("catf into file", {
  fn = tempfile()
  catf("xxx%ixxx", 123, file = fn)
  s = readLines(fn)
  expect_equal(s, "xxx123xxx")
  file.remove(fn)
})


test_that("warningf", {
  expect_warning(warningf("xxx%ixxx", 123), "xxx123xxx")
  f = function(call. = TRUE) warningf("123", call. = call.)
  # "Warning: " not caught by gives_warning
  expect_warning(f(), "123")
  expect_warning(warningf("abc"), "abc")
  condition = tryCatch(f(), warning = identity)
  expect_equal(conditionCall(condition), quote(f()))
  condition = tryCatch(f(TRUE), warning = identity)
  expect_equal(conditionCall(condition), quote(f(TRUE)))
  condition = tryCatch(f(FALSE), warning = identity)
  expect_null(conditionCall(condition))
})

test_that("stopf", {
  expect_error(stopf("xxx%ixxx", 123), "xxx123xxx")
  f = function(call. = TRUE) stopf("123", call. = call.)
  expect_error(f(), "123")
  expect_error(stopf("abc"), "abc")
  condition = tryCatch(f(), error = identity)
  expect_equal(conditionCall(condition), quote(f()))
  condition = tryCatch(f(TRUE), error = identity)
  expect_equal(conditionCall(condition), quote(f(TRUE)))
  condition = tryCatch(f(FALSE), error = identity)
  expect_null(conditionCall(condition))
})

test_that("condition calls skip leanified methods", {
  Test = R6Class("Test", public = list(
    warn = function() warningf("test warning"),
    abort = function() stopf("test error")
  ))
  leanify_r6(Test)
  test = Test$new()

  condition = tryCatch(test$warn(), warning = identity)
  expect_equal(conditionCall(condition), quote(test$warn()))
  condition = tryCatch(test$abort(), error = identity)
  expect_equal(conditionCall(condition), quote(test$abort()))
})

test_that("condition calls support closure callers", {
  condition = tryCatch(do.call(function() stopf("test error"), list()), error = identity)
  expect_class(condition, "Mlr3Error")
  expect_equal(conditionMessage(condition), "test error")
})

test_that("formatting", {
  expect_snapshot(stopf("abc"), error = TRUE)
  expect_snapshot(stopf("s: %s", "b"), error = TRUE)
  expect_snapshot(warningf("abc"))
})
