test_that("register_namespace_callback wraps callback so pkgload-style hook signature works", {
  pkgname = "mlr3misc"
  namespace = "checkmate"

  unload_event = packageEvent(pkgname, "onUnload")
  load_event = packageEvent(namespace, "onLoad")
  on.exit({
    setHook(load_event, NULL, action = "replace")
    setHook(unload_event, NULL, action = "replace")
  }, add = TRUE)

  called = 0L
  callback = function() called <<- called + 1L

  # callback fires immediately because the namespace is already loaded
  register_namespace_callback(pkgname, namespace, callback)
  expect_equal(called, 1L)

  # simulate a pkgload-style invocation with positional args
  hooks = getHook(load_event)
  expect_length(hooks, 1L)
  hooks[[1L]](namespace, "/some/lib/path")
  expect_equal(called, 2L)

  # the unload hook should still be able to identify and remove our load hook
  unload_hooks = getHook(unload_event)
  expect_length(unload_hooks, 1L)
  unload_hooks[[1L]]()
  expect_length(getHook(load_event), 0L)
  expect_length(getHook(unload_event), 0L)
})
