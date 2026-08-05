test_that("hash_input is applied to list elements", {
  f = function(x) x + 1
  attr(f, "srcref") = NULL

  expect_equal(hash_input(list(a = 1, b = f)), list(a = 1, b = hash_input(f)))

  # the environment and bytecode of the function must not influence the hash
  g = local(function(x) x + 1)
  expect_equal(calculate_hash(list(f)), calculate_hash(list(g)))
  expect_true(calculate_hash(list(f)) != calculate_hash(list(function(x) x + 2)))
})

test_that("hash_input works recursively", {
  expect_equal(
    hash_input(list(list(f = function(x) x))),
    list(list(f = hash_input(function(x) x)))
  )
})

test_that("hash_input recurses into list columns of a data.table", {
  dt = data.table(a = 1:2, b = list(function(x) x + 1, function(x) x + 1))
  dt2 = data.table(a = 1:2, b = list(function(x) x + 1, function(x) x + 2))

  expect_equal(hash_input(dt)$b, list(hash_input(function(x) x + 1), hash_input(function(x) x + 1)))
  expect_true(calculate_hash(dt) != calculate_hash(dt2))
})

test_that("hash_input.list leaves atomic elements as is", {
  x = list(a = 1L, b = "a", c = TRUE)
  expect_equal(hash_input(x), x)
})
