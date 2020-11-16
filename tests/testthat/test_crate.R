test_that("crate", {
  meta_f = function(z) {
    x = 1
    y = 2
    crate(function() {
      c(x, y, z)
    }, x, .parent = parent.frame())
  }
  x = 100
  y = 200
  z = 300
  f = meta_f(1)
  expect_equal(f(), c(1, 200, 300))
})
