test_that("Callback works", {
  MyCallback = R6Class("MyCallback",
    inherit = Callback,
    lock_objects = FALSE,
    public = list(
      initialize = function(id = "mycallback", a, b) {
        self$id = assert_character(id, len = 1L)
      },
      step1 = function(context) {
        context$a = 1
      },
      step2 = function(context) {
        context$b = 2
      }
    )
  )

  mycb = MyCallback$new()
  callbacks = list(mycb)
  context = new.env()
  f = function(context, callbacks) {
    call_back("step1", callbacks, context)
    call_back("step2", callbacks, context)
  }
  f(context, callbacks)
  expect_true(context$a == 1)
  expect_true(context$b == 2)
})


