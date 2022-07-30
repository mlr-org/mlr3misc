test_that("Callback works", {

  test_callback = as_callback("test",
    step = function(callback, context) {
        context$a = 1
    }
  )

  expect_class(test_callback, "CallbackTest")
  expect_string(test_callback$id, "test")

  ContextTest = R6::R6Class("ContextTest", inherit = Context, public = list(a = NULL))
  context = ContextTest$new(id = "test")
  test_callback$call("step", context)
  expect_equal(context$a, 1)
})

test_that("call_back works", {

  test_callback_1 = as_callback("test",
    step_1 = function(callback, context) {
      context$a = 1
    },
    step_2 = function(callback, context) {
      context$b = 2
    }
  )

  test_callback_2 = as_callback("test",
    step_1 = function(callback, context) {
      context$c = 2
    }
  )

  test_callback_3 = as_callback("test",
    step_3 = function(callback, context) {
      context$d = 1
    }
  )

  callbacks = list(test_callback_1, test_callback_2, test_callback_3)
  ContextTest = R6::R6Class("ContextTest", inherit = Context, public = list(a = NULL, b = NULL, c = NULL, d = NULL))
  context = ContextTest$new(id = "test")
  call_back("step_1", callbacks, context)

  expect_equal(context$a, 1)
  expect_null(context$b)
  expect_equal(context$c, 2)
  expect_null(context$d)

  call_back("step_2", callbacks, context)

  expect_equal(context$a, 1)
  expect_equal(context$b, 2)
  expect_equal(context$c, 2)
  expect_null(context$d)

  call_back("step_3", callbacks, context)

  expect_equal(context$a, 1)
  expect_equal(context$b, 2)
  expect_equal(context$c, 2)
  expect_equal(context$d, 1)
})

test_that("as_callback function checks for context argument", {
  expect_error(as_callback("test", on_result = function(env) context), "identical")
})
