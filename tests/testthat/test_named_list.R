context("named_list")

test_that("named_list", {
  expect_equal(named_list(character()), setNames(vector("list", 0), nm = character()))
  expect_equal(named_list(), setNames(vector("list", 0), nm = character()))
  expect_equal(named_list("a"), list(a = NULL))
  expect_equal(named_list(c("a", "b")), list(a = NULL, b = NULL))
  expect_equal(named_list(c("a", "b"), 1), list(a = 1, b = 1))
})
