test_that("hash_input() for functions keeps the names of arguments", {
  # `as.character()` on a call returns its top-level elements, which loses the argument names of a
  # body that is a single call
  f1 = function(x) c(a = 1, b = 2)
  f2 = function(x) c(b = 1, a = 2)

  expect_false(calculate_hash(f1) == calculate_hash(f2))
  expect_false(calculate_hash(function(x) f(x, a = 1)) == calculate_hash(function(x) f(x, b = 1)))
})

test_that("hash_input() for functions ignores the bytecode", {
  f = function(x, a = 1) x + a
  expect_equal(calculate_hash(f), calculate_hash(compiler::cmpfun(f)))
})

test_that("hash_input() for functions ignores the environment", {
  f = function(x) x + 1
  g = f
  environment(g) = new.env()

  expect_equal(calculate_hash(f), calculate_hash(g))
})

test_that("hash_input() for functions ignores source references", {
  parse_fn = function(text) eval(parse(text = text, keep.source = TRUE))
  f1 = parse_fn("function(x) {\n  x + 1\n}")
  f2 = parse_fn("\n\n# a comment\nfunction(x) {\n  x + 1\n}")

  expect_true(!is.null(attr(body(f2), "srcref")))
  expect_equal(calculate_hash(f1), calculate_hash(f2))
})

test_that("hash_input() for functions takes formals and body into account", {
  expect_equal(calculate_hash(function(x) x + 1), calculate_hash(function(x) x + 1))
  expect_false(calculate_hash(function(x) x + 1) == calculate_hash(function(x) x + 2))
  expect_false(calculate_hash(function(x) x) == calculate_hash(function(y) y))
  expect_false(calculate_hash(function(x, a = 1) x) == calculate_hash(function(x, a = 2) x))
})

test_that("hash_input() works for primitives", {
  expect_equal(calculate_hash(sum), calculate_hash(base::sum))
  expect_false(calculate_hash(sum) == calculate_hash(prod))
})

test_that("hash_input() for data.tables ignores keys and indices", {
  dt1 = data.table(a = 3:1, b = 1:3)
  dt2 = data.table(a = 3:1, b = 1:3)
  setkeyv(dt2, "b")

  expect_equal(calculate_hash(dt1), calculate_hash(dt2))
  expect_false(calculate_hash(dt1) == calculate_hash(data.table(a = 3:1, b = 3:1)))
})

test_that("calculate_hash() applies hash_input() to each object", {
  f1 = function(x) c(a = 1, b = 2)
  f2 = function(x) c(b = 1, a = 2)

  expect_string(calculate_hash(f1, 1, "a"))
  expect_equal(calculate_hash(f1, 1, "a"), calculate_hash(f1, 1, "a"))
  expect_false(calculate_hash(f1, 1, "a") == calculate_hash(f2, 1, "a"))
  expect_false(calculate_hash(f1, 1, "a") == calculate_hash(f1, 2, "a"))
})
