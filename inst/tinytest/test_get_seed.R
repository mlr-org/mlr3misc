source("setup.R")
using("checkmate")


expect_integer(get_seed(), any.missing = FALSE, min.len = 1L)
