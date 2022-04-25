test_that("get_private<- works", {
  a = R6Class("A",
    private = list(
      y = 123
    )
  )$new()

  get_private(a, "y") = 314L
  expect_true(get_private(a)$y == 314L)
})

test_that("get_private<- checks for correct input", {
  a = R6Class("A",
    private = list(
      y = 123
    )
  )$new()

  expect_error({
    get_private(a, c("x", "y")) = 314L
  })
  expect_error({
    get_private(a, character(0)) = 314L
  })
  expect_error({
    get_private(a, NULL) = 314L
  })
})
