context("load_data")

test_that("load_data", {
  expect_data_frame(load_dataset("iris", "datasets"))
})
