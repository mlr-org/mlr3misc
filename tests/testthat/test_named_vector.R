context("named_vector")

test_that("named_vector", {
  expect_equal(named_vector(character()), setNames(vector("logical", 0), nm = character()))
  expect_equal(named_vector(), setNames(vector("logical", 0), nm = character()))
  expect_equal(named_vector("a"), c(a = NA))
  expect_equal(named_vector(c("a", "b")), c(a = NA, b = NA))
  expect_equal(named_vector(c("a", "b"), 1), c(a = 1, b = 1))
  expect_error(named_vector("a", iris))
})
