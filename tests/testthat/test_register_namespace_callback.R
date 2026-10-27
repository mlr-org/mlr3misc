test_that("register_namespace_callback() removes only its own hooks", {
  load_event = packageEvent("mlr3misc.test.ns", "onLoad")
  unload_event = packageEvent("mlr3misc.test.pkg", "onUnload")
  on.exit({
    setHook(load_event, NULL, action = "replace")
    setHook(unload_event, NULL, action = "replace")
  })

  unrelated_hook = function(...) NULL
  setHook(load_event, unrelated_hook, action = "append")
  setHook(unload_event, unrelated_hook, action = "append")

  register_namespace_callback("mlr3misc.test.pkg", "mlr3misc.test.ns", function() NULL)
  expect_length(getHook(load_event), 2L)
  expect_length(getHook(unload_event), 2L)

  getHook(unload_event)[[2L]]()
  expect_identical(getHook(load_event), list(unrelated_hook))
  expect_identical(getHook(unload_event), list(unrelated_hook))
})

test_that("register_namespace_callback() calls callback on namespace load", {
  load_event = packageEvent("mlr3misc.test.ns", "onLoad")
  unload_event = packageEvent("mlr3misc.test.pkg", "onUnload")
  on.exit({
    setHook(load_event, NULL, action = "replace")
    setHook(unload_event, NULL, action = "replace")
  })

  env = new.env()
  env$called = 0L
  register_namespace_callback("mlr3misc.test.pkg", "mlr3misc.test.ns", function() env$called = env$called + 1L)
  expect_identical(env$called, 0L)

  getHook(load_event)[[1L]]("mlr3misc.test.ns", "path")
  expect_identical(env$called, 1L)
})
