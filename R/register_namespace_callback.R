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
#'
#' @return `NULL`.
#' @export
register_namespace_callback = function(pkgname, namespace, callback) {
  assert_string(pkgname)
  assert_string(namespace)
  assert_function(callback)

  if (isNamespaceLoaded(namespace)) {
    callback()
  }

  remove_hook = function() {
    event = packageEvent(namespace, "onLoad")
    hooks = getHook(event)
    pkgnames = vapply(hooks, function(x) {
      ee = environment(x)
      if (isNamespace(ee)) environmentName(ee) else environment(x)$pkgname
    }, NA_character_)
    setHook(event, hooks[pkgnames != pkgname], action = "replace")
  }

  setHook(packageEvent(namespace, "onLoad"), callback, action = "append")
  setHook(packageEvent(pkgname, "onUnload"), remove_hook, action = "replace")
}
