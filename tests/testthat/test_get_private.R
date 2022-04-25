test_that("get_private<- works", {
  a = R6Class("A",
    private = list(
      y = 123
    )
  )$new()

  get_private(a, "y") = 314L
  expect_true(get_private(a)$y == 314L)
})
