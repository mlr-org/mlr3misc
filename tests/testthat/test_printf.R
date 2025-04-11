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
  f = function() warningf("123")
  # "Warning: " not caught by gives_warning
  expect_warning(f(), "123")
  expect_warning(warningf("abc"), "abc")
})

test_that("stopf", {
  expect_error(stopf("xxx%ixxx", 123), "xxx123xxx")
  f = function() stopf("123")
  expect_error(f(), "123")
  expect_error(stopf("abc"), "abc")
})

test_that("non-leanified call is printed", {
  A = R6Class("A", public = list(warn = function() warningf("test warning")))
  leanify_r6(A)
  a = A$new()

  tryCatch(a$warn(),
    warning = function(w) {
      expect_equal(w$call, quote(a$warn()))
    }
  )

  f = function() warningf("test warning")

  tryCatch(f(),
    warning = function(w) {
      expect_equal(w$call, quote(f()))
    }
  )
})
