test_that("seq", {
  expect_identical(seq_row(iris), seq_len(nrow(iris)))
  expect_identical(seq_col(iris), seq_len(ncol(iris)))
  expect_identical(seq_len0(10), 0:9)
  expect_identical(seq_along0(1:10), 0:9)

  expect_identical(seq_len0(0), integer(0))
  expect_identical(seq_along0(integer(0)), integer(0))
  expect_identical(seq_len0(1), 0L)
  expect_identical(seq_along0(integer(1)), 0L)
})
