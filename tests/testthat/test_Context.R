test_that("Context", {
  ContextTest = R6::R6Class("ContextTest",
    inherit = Context,
    public = list(

      table = NULL,

      initialize = function(table) {
        super$initialize(id = "test", label = "Context Test")
        self$table = table
      }
    ),

    active = list(
      data = function(rhs) {
        if (missing(rhs)) {
          self$table
        } else {
          self$table = rhs
        }
      }
    )
  )
  table = data.table::data.table(x1 = runif(10))
  test = ContextTest$new(table)

  expect_output(print(test), "data")
  expect_string(test$label, "Context Test")
  expect_string(test$id, "test")
  expect_data_table(test$data)
})
