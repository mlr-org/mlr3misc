context("cross_join")

test_that("cross_join", {
  tab = cross_join(list(a = 1:3, b = 1:2))
  expect_equal(tab, CJ(a = 1:3, b = 1:2))

  tab = cross_join(list(sorted = 1:3, b = 1:2))
  expect_equal(tab, setnames(CJ(a = 1:3, b = 1:2), "a", "sorted"))

  tab = cross_join(list(unique = 1:3, b = 1:2))
  expect_equal(tab, setnames(CJ(a = 1:3, b = 1:2), "a", "unique"))
})
