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
