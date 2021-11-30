test_that("recycle_vectors", {
  x = list(a = 1:3, b = 2L)
  res = recycle_vectors(x)

  expect_equal(
    res,
    list(a = 1:3, b = c(2L, 2L, 2L))
  )

  x = list(a = 1:3, b = 2L, c = integer())
  expect_error(
    recycle_vectors(x),
    "common length"
  )

  x = list(a = 1:3, b = 1:2)
  expect_error(
    recycle_vectors(x),
    "common length"
  )

  x = list(a = 1:4, b = 1:2, c = 1L, d = letters[1:20])
  res = recycle_vectors(x)
  expect_list(res, len = length(x))
  expect_true(all(lengths(res) == 20))
})
