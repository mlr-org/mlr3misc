context("distinct_values")

test_that("distinct_values", {
   x = factor(c(letters[1:2], NA), levels = letters[1:3])
   expect_character(distinct_values(x), len = 2, any.missing = FALSE)
   expect_character(distinct_values(x, na_rm = FALSE), len = 3, any.missing = TRUE)
   expect_character(distinct_values(x, drop = FALSE), len = 3, any.missing = FALSE)
   expect_character(distinct_values(x, drop = FALSE, na_rm = FALSE), len = 4, any.missing = TRUE)

   x = c(TRUE, NA)
   expect_logical(distinct_values(x), len = 1, any.missing = FALSE)
   expect_logical(distinct_values(x, na_rm = FALSE), len = 2)
   expect_logical(distinct_values(x, drop = FALSE, na_rm = TRUE), len = 2, any.missing = FALSE)
   expect_logical(distinct_values(x, drop = FALSE, na_rm = FALSE), len = 3)


   x = c(1:3, NA)
   expect_integer(distinct_values(x, na_rm = TRUE, drop = TRUE), len = 3, any.missing = FALSE)
   expect_integer(distinct_values(x, na_rm = FALSE, drop = TRUE), len = 4, any.missing = TRUE)
   expect_integer(distinct_values(x, na_rm = TRUE, drop = FALSE), len = 3, any.missing = FALSE)
   expect_integer(distinct_values(x, na_rm = FALSE, drop = FALSE), len = 4, any.missing = TRUE)
})
