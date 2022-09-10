test_that("Callback works", {
  CallbackTest  = R6Class("CallbackTest",
    inherit = Callback,
    public = list(
      on_stage = function(callback, context) {
        context$a = 1
      },
      info = "Test"
    )
  )
  test_callback = CallbackTest$new(id = "mlr3misc.test", label = "Test Callback", man = "mlr3misc::Callback")

  expect_equal(test_callback$id, "mlr3misc.test")
  expect_equal(test_callback$label, "Test Callback")
  expect_equal(test_callback$info, "Test")
  expect_man_exists(test_callback$man)

  ContextTest = R6::R6Class("ContextTest", inherit = Context, public = list(a = NULL))
  context = ContextTest$new(id = "test")
  test_callback$call("on_stage", context)
  expect_equal(context$a, 1)
  expect_null(test_callback$call("on_stage_2", context))

  expect_list(test_callback$state)
  test_callback$state$b = 1
  expect_equal(test_callback$state$b, 1)
})

test_that("call_back() function works", {

  CallbackTest1 = R6Class("CallbackTest1",
    inherit = Callback,
    public = list(
      on_stage_1 = function(callback, context) {
        context$a = 1
      },
      on_stage_2 = function(callback, context) {
        context$b = 2
      }
    )
  )

  test_callback_1 = CallbackTest1$new(id = "mlr3misc.test", label = "Test Callback")

  CallbackTest2 = R6Class("CallbackTest1",
    inherit = Callback,
    public = list(
      on_stage_1 = function(callback, context) {
        context$c = 2
      }
    )
  )

  test_callback_2 = CallbackTest2$new(id = "mlr3misc.test", label = "Test Callback")

  CallbackTest3 = R6Class("CallbackTest1",
    inherit = Callback,
    public = list(
      on_stage_3 = function(callback, context) {
        context$d = 1
      }
    )
  )

  test_callback_3 = CallbackTest3$new(id = "mlr3misc.test", label = "Test Callback")

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



test_that("as_callbacks.Callback works", {
  CallbackTest  = R6Class("CallbackTest",
    inherit = Callback,
    public = list(
      on_stage = function(callback, context) {
        context$a = 1
      },
      info = "Test"
    )
  )
  test_callback = CallbackTest$new(id = "mlr3misc.test", label = "Test Callback", man = "mlr3misc::Callback")

  expect_list(as_callbacks(test_callback))
})
