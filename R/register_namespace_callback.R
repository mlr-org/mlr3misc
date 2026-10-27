#' @title Registers a Callback on Namespace load/unLoad Events
#'
#' @description
#' Register a function `callback` to be called after a namespace is loaded.
#' Calls `callback` once if the namespace has already been loaded before and
#' also adds an unload-hook that removes the load hook.
#'
#' @param pkgname (`character(1)`)\cr
#'   Name of the package which registers the callback.
#' @param namespace (`character(1)`)\cr
#'   Namespace to react on.
#' @param callback (`function()`)\cr
#'   Function to call on namespace load.
#'   The callback is invoked without arguments, so it can be defined as `function()` or `function(...)`.
#'   Any arguments passed by the hook caller (e.g. `package` and `lib_path` from `pkgload`) are discarded.
#'
#' @return `NULL`.
#' @export
register_namespace_callback = function(pkgname, namespace, callback) {
  assert_string(pkgname)
  assert_string(namespace)
  assert_function(callback)

  load_hook = function(...) callback()

  # remove hooks by identity so that hooks registered by others are never inspected
  remove_hook = function(event, hook) {
    hooks = discard(getHook(event), function(x) identical(x, hook))
    setHook(event, hooks, action = "replace")
  }

  remove_hooks = function(...) {
    remove_hook(packageEvent(namespace, "onLoad"), load_hook)
    remove_hook(packageEvent(pkgname, "onUnload"), remove_hooks)
  }

  if (isNamespaceLoaded(namespace)) {
    callback()
  }

  setHook(packageEvent(namespace, "onLoad"), load_hook, action = "append")
  setHook(packageEvent(pkgname, "onUnload"), remove_hooks, action = "append")
}
