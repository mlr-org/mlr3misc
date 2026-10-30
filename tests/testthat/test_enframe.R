test_that("enframe", {
  expect_identical(enframe(1:3), data.table(name = 1:3, value = 1:3))
  expect_identical(
    enframe(set_names(1:3, letters[1:3]), name = "id", value = "val"),
    data.table(id = letters[1:3], val = 1:3)
  )

  dt = enframe(list2env(list(a = 1)))
  expect_identical(dt$name, "a")
  expect_identical(dt$value, list(1))
})

test_that("deframe", {
  expect_identical(deframe(data.frame(x = 1:3)), 1:3)
  expect_identical(deframe(data.frame(name = letters[1:3], value = 1:3)), set_names(1:3, letters[1:3]))
  expect_error(deframe(data.frame(a = 1, b = 2, c = 3)), "1 or 2 columns")
  expect_error(deframe(1:3), "data.frame")
})
