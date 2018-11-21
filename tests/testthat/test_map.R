context("map")

test_that("map (lapply)", {
  x = 1:2
  names(x) = letters[1:2]
  expect_identical(map(x, identity), list(a = 1L, b = 2L))

  x = c(TRUE, FALSE)
  names(x) = letters[1:2]
  expect_identical(map_lgl(x, identity), x)

  x = 1:2
  names(x) = letters[1:2]
  expect_identical(map_int(x, identity), x)

  x = 1:2+0.5
  names(x) = letters[1:2]
  expect_identical(map_dbl(x, identity), x)

  x = letters[1:2]
  names(x) = letters[1:2]
  expect_identical(map_chr(x, identity), x)

  x = list(list(a = 1L), list(a = 2L))
  expect_data_table(map_dtr(x, identity), nrow = 2, ncol = 1)

  x = list(a = 1L, b = 2L)
  expect_data_table(map_dtc(x, identity), nrow = 1, ncol = 2)
})

test_that("map (extract)", {
  x = list(list(a = 1L, b = 1L), list(a = 2L))
  expect_identical(map(x, "a"), list(1L, 2L))
  expect_identical(map(x, 1L), list(1L, 2L))
  expect_identical(map(x, "b"), list(1L, NULL))
  expect_error(map(x, 2L))

  expect_identical(map_int(x, "a"), 1:2)
  expect_identical(map_int(x, 1L), 1:2)
  expect_error(map_int(x, "b"))
})
