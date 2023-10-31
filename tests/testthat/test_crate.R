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

test_that("compilation works", {
  expect_error(compiler::disassemble(crate(function() NULL, .compile = FALSE)), regexp = "function is not compiled")
  expect_error(compiler::disassemble(crate(function() NULL, .compile = TRUE)), regexp = NA)

  f = function() NULL
  fc = compiler::cmpfun(f)

  expect_true(is_compiled(fc))
})
