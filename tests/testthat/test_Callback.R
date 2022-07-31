test_that("Callback works", {
  test_callback = as_callback("mlr3misc.test",
    class = "CallbackTest",
    label = "Test Callback",
    on_stage = function(callback, context) {
        context$a = 1
    }
  )

  expect_class(test_callback, "CallbackTest")
  expect_equal(test_callback$id, "mlr3misc.test")
  expect_equal(test_callback$label, "Test Callback")

  ContextTest = R6::R6Class("ContextTest", inherit = Context, public = list(a = NULL))
  context = ContextTest$new(id = "test")
  test_callback$call("on_stage", context)
  expect_equal(context$a, 1)
  expect_null(test_callback$call("on_stage_2", context))
})

test_that("call_back() function works", {

  test_callback_1 = as_callback("mlr3misc.test",
    class = "CallbackTest",
    label = "Test Callback",
    on_stage_1 = function(callback, context) {
      context$a = 1
    },
    on_stage_2 = function(callback, context) {
      context$b = 2
    }
  )

  test_callback_2 = as_callback("mlr3misc.test",
    class = "CallbackTest",
    label = "Test Callback",
    on_stage_1 = function(callback, context) {
      context$c = 2
    }
  )

  test_callback_3 = as_callback("mlr3misc.test",
    class = "CallbackTest",
    label = "Test Callback",
    on_stage_3 = function(callback, context) {
      context$d = 1
    }
  )

  callbacks = list(test_callback_1, test_callback_2, test_callback_3)
  ContextTest = R6::R6Class("ContextTest", inherit = Context, public = list(a = NULL, b = NULL, c = NULL, d = NULL))
  context = ContextTest$new(id = "test")
  call_back("on_stage_1", callbacks, context)

  expect_equal(context$a, 1)
  expect_null(context$b)
  expect_equal(context$c, 2)
  expect_null(context$d)

  call_back("on_stage_2", callbacks, context)

  expect_equal(context$a, 1)
  expect_equal(context$b, 2)
  expect_equal(context$c, 2)
  expect_null(context$d)

  call_back("on_stage_3", callbacks, context)

  expect_equal(context$a, 1)
  expect_equal(context$b, 2)
  expect_equal(context$c, 2)
  expect_equal(context$d, 1)
})

test_that("as_callback function checks for callback and context argument", {
  expect_error(as_callback("mlr3misc.test", "CallbackTest", on_result = function(env) context), "identical")
})
