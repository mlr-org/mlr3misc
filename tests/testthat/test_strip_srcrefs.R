test_that("remove srcref from function", {
  f = function(x) NULL
  attr(f, "srcref") = "mock_srcrefs"
  f_strip = strip_srcrefs(f)
  expect_null(attr(f_strip, "srcref"))
})

test_that("remove srcrefs from body and nested functions", {
  src = "function(x, f = function(y) y) {\n  g = function(z) z\n  g(x)\n}"
  f = eval(parse(text = src, keep.source = TRUE)[[1L]])
  g = eval(parse(text = src, keep.source = FALSE)[[1L]])
  expect_true(identical(strip_srcrefs(f), g, ignore.srcref = FALSE))
})
