context("chunk")

test_that("chunk", {
  x = 1:10
  n_chunks = 2
  expect_integer(chunk(x, n_chunks = n_chunks), len = length(x), lower = 1, upper = n_chunks, any.missing = FALSE)
  x = 1:10
  n_chunks = 1
  expect_integer(chunk(x, n_chunks = n_chunks), len = length(x), lower = 1, upper = n_chunks, any.missing = FALSE)
  x = 1:10
  n_chunks = 10
  expect_integer(chunk(x, n_chunks = n_chunks), len = length(x), lower = 1, upper = n_chunks, any.missing = FALSE)
  x = 1:10
  n_chunks = 20
  expect_integer(chunk(x, n_chunks = n_chunks), len = length(x), lower = 1, upper = n_chunks, any.missing = FALSE)
  x = integer(0)
  n_chunks = 20
  expect_integer(chunk(x, n_chunks = n_chunks), len = length(x), lower = 1, upper = n_chunks, any.missing = FALSE)

  x = 1:10
  chunk_size = 3
  res = chunk(x, chunk_size = chunk_size)
  expect_integer(res, len = length(x), lower = 1, upper = length(x), any.missing = FALSE)
  expect_integer(table(res), lower = 1, upper = chunk_size, any.missing = FALSE)

  x = 1:10
  chunk_size = 1
  res = chunk(x, chunk_size = chunk_size)
  expect_integer(res, len = length(x), lower = 1, upper = length(x), any.missing = FALSE)
  expect_integer(table(res), lower = 1, upper = chunk_size, any.missing = FALSE)

  expect_equal(chunk(numeric(0), chunk_size = 1), integer(0))
  expect_equal(chunk(numeric(0), n_chunks = 1), integer(0))

  x = 1:10
  n_chunks = 2
  res = c(rep(1, 5), rep(2, 5))
  expect_equal(chunk(x, n_chunks = n_chunks, shuffle = FALSE), res)
})
