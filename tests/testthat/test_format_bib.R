test_that("format_bib", {
  bibentries = list(checkmate = citation("checkmate"), R = citation())

  expect_string(format_bib("checkmate", "R"))
  expect_string(cite_bib("checkmate", "R"))
})
