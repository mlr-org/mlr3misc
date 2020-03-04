source("setup.R")
using("checkmate")


expect_data_frame(load_dataset("iris", "datasets"))
