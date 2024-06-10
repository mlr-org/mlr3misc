test_that("remove srcref from function", {
  f = function(x) NULL
  attr(f, "srcref") = "mock_srcrefs"
  f_strip = strip_srcrefs(f)
  expect_null(attr(f_strip, "srcref"))
})
