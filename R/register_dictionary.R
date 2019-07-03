
register_dictionary = function(dict_name, ...) {

  m = match.call()
  m[["dict_name"]] = NULL

  targetenv = parent.frame()

  registry_name = sprintf(".registry_%s", dict_name)

  registry = get0(registry_name, targetenv, inherits = FALSE)

  registry = c(registry, list(m))
  
  assign(registry_name, registry, targetenv)
}

publish_registered_dictionary = function(dict_name, dict_call, targetenv = parent.env(parent.frame())) {
  registry_name = sprintf(".registry_%s", dict_name)

  registry = get0(registry_name, targetenv, inherits = FALSE)

  protocall = substitute(dict_call)

  for (regcall in registry) {
    regcall[[1]] = protocall
    eval(regcall, envir = parent.frame())
  }
  rm(list = registry_name, envir = targetenv)
}
