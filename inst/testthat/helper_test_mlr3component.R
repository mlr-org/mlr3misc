#' @title Mlr3Component Autotest Suite
#'
#' @description
#' Autotests for [`Mlr3Component`] subclasses.
#'
#' @details
#' Run `expect_mlr3component_subclass()` that verify various assumptions that subclasses of [`Mlr3Component`] should
#' fulfill.
#'
#' @param compclass (`character(1)`)
#'   The class of the component to test.
#' @param constargs (`list`)
#'   A list of construction arguments to pass to the component.
#' @param expect_congruent_man (`logical(1)`)
#'   Whether to expect the `man` field to be of the form `package::<dictname>_<dictentry>`.
#' @param check_package_export (`logical(1)`)
#'   Whether to check that the component is exported from the package.
#' @param dict_package (`character(1)` | `environment`)
#'   The package that contains the dictionary.
#'   If `NULL`, the package of the component is used.
#'   An `environment` can also be passed, which will then be used directly.
#'
#' @export
expect_mlr3component_subclass = function(compclass, constargs, check_congruent_man = TRUE, check_package_export = TRUE,
  dict_package = NULL
) {

  checkmate::assert_list(constargs, names = "named")
  checkmate::assert_flag(check_congruent_man)
  checkmate::assert_flag(check_package_export)
  checkmate::assert(
    checkmate::check_string(dict_package, null.ok = TRUE),
    checkmate::check_environment(dict_package, null.ok = TRUE)
  )

  old_options = options(mlr3.on_deprecated_mlr3component = "error")
  on.exit(options(old_options))

  checkmate::expect_class(compclass, "R6ClassGenerator")

  object = do.call(compclass$new, constargs)

  checkmate::expect_r6(object, "Mlr3Component", cloneable = TRUE,
    public = c("id", "label", "param_set", "packages", "properties", "hash", "phash",
      "format", "print", "help", "configure", "override_info", "man", "initialize"
    ),
    private = c(".additional_phash_input", "deep_clone", ".additional_configuration", ".dict_entry", ".representable")
  )


  checkmate::expect_string(object$id, min.chars = 1L)
  checkmate::expect_string(object$label, min.chars = 1L)
  checkmate::expect_class(object$param_set, "ParamSet", null.ok = TRUE)
  checkmate::expect_character(object$packages, any.missing = FALSE, min.chars = 1L)
  checkmate::expect_character(object$properties, any.missing = FALSE, min.chars = 1L)
  checkmate::expect_string(object$hash, min.chars = 1L)
  checkmate::expect_string(object$phash, min.chars = 1L)
  checkmate::expect_string(object$man, pattern = "^[^:]+::[^:]+$")

  checkmate::expect_flag(mlr3misc::get_private(object)$.has_id)
  checkmate::expect_string(mlr3misc::get_private(object)$.dict_entry, min.chars = 1L)
  checkmate::expect_string(mlr3misc::get_private(object)$.dict_shortaccess, min.chars = 1L)
  checkmate::expect_character(mlr3misc::get_private(object)$.additional_configuration,
    any.missing = FALSE, min.chars = 1L, unique = TRUE)
  checkmate::expect_flag(mlr3misc::get_private(object)$.representable)

  dict_entry = mlr3misc::get_private(object)$.dict_entry
  dict_shortaccess = mlr3misc::get_private(object)$.dict_shortaccess
  additional_configuration = mlr3misc::get_private(object)$.additional_configuration
  construction_arguments = as.character(names(formals(object$initialize)))

  all_fields_list = list()
  recurse_class = compclass
  while (!is.null(recurse_class)) {
    all_fields_list[[length(all_fields_list) + 1]] = c(names(recurse_class$public_fields), names(recurse_class$active))
    recurse_class = recurse_class$get_inherit()
  }
  all_fields = unique(unlist(all_fields_list))
  # the following fields are part of the base class and can therefore not be part of the additional configuration
  all_fields = setdiff(all_fields, c("man", "properties", "packages", "hash", "phash", "id", "label", "param_set"))
  checkmate::expect_subset(additional_configuration, all_fields,
    info = "additional_configuration is a subset of all valid fields")
  checkmate::expect_subset(construction_arguments, all_fields,
    info = "construction arguments are accessible as fields")
  checkmate::expect_disjunct(construction_arguments, additional_configuration,
    info = "construction arguments and additional_configuration should be disjoint")
  if (!is.null(object$param_set)) {
    checkmate::expect_disjunct(construction_arguments, object$param_set$ids(),
      info = "construction arguments and param_set IDs should be disjoint")
    checkmate::expect_disjunct(additional_configuration, object$param_set$ids(),
      info = "additional_configuration and param_set IDs should be disjoint")
  }

  testthat::expect_output(print(object), object$id, fixed = TRUE, info = "print output contains id")

  checkmate::expect_string(object$format(), pattern = "^<[^>]+>$")

  testthat::expect_true(isTRUE(mlr3misc::get_private(object)$.has_id) || identical(dict_entry, object$id))

  oldhash = object$hash
  oldphash = object$phash

  if (isTRUE(mlr3misc::get_private(object)$.has_id)) {
    oldid = object$id
    object$id = "newid"
    testthat::expect_equal(object$id, "newid", info = "id can be set")
    testthat::expect_true(object$hash != oldhash, info = "hash changes with id")
    testthat::expect_true(object$phash != oldphash, info = "phash changes with id")
    object$id = oldid
    testthat::expect_equal(object$id, oldid, info = "id can be reset")
    testthat::expect_equal(object$hash, oldhash, info = "hash is reset by id reset")
    testthat::expect_equal(object$phash, oldphash, info = "phash is reset by id reset")
    object$configure(id = "newid2")
    testthat::expect_equal(object$id, "newid2", info = "id can be set via configure")
    object$configure(id = oldid)
    testthat::expect_equal(object$id, oldid, info = "id can be reset via configure")

  }

  object2 = do.call(compclass$new, constargs)
  object_clone = object$clone(deep = TRUE)

  expect_deep_clone(object, object2)
  expect_deep_clone(object, object_clone)

  eligibleparams = NULL



  if (!is.null(object$param_set) || length(object$param_set$ids()) > 0L) {
    # we now check if configuration parameters can be changed directly and through configure and whether that affects
    # hash but not phash. We do this by automatically generating a parameter value that deviates from the automatically
    # constructed one. However, for ParamUty we can't do that, so if there are only 'ParamUty' parameters we skip this
    # part.
    tops = object$param_set
    eligibleparams = which(
      tops$class != "ParamUty" &
        # filter out discrete params with only one level, or the numeric parameters with $lower == $upper
        # Note that numeric parameters have 0 levels, and discrete parameters have $lower == $upper (== NA)
        (
          (!is.na(tops$lower) & tops$lower != tops$upper) |
            (is.finite(tops$nlevels) & tops$nlevels > 1)
        ) &
        !mlr3misc::map_lgl(tops$values[tops$ids()], is.null)
    )
  }
  if (length(eligibleparams)) {
    testingparam = tops$ids()[[eligibleparams[[1]]]]
    origval = object$param_set$values[[testingparam]]
    if (!is.atomic(origval)) origval = NULL
    if (tops$class[[testingparam]] %in% c("ParamLgl", "ParamFct")) {
      candidates = tops$levels[[testingparam]]
    } else {
      candidates = Filter(function(x) is.finite(x) && !is.na(x),
        c(tops$lower[[testingparam]], tops$upper[[testingparam]], tops$lower[[testingparam]] + 1, 0, origval + 1))
    }
    val = setdiff(candidates, origval)[1]
    parvals = list(val)
    names(parvals) = testingparam

    parvals_orig = list(origval)
    names(parvals_orig) = testingparam

    object$param_set$values[[testingparam]] = val
    testthat::expect_equal(object$param_set$values[[testingparam]], val, info = "parameters can be set directly")
    changedhash = object$hash
    testthat::expect_false(object$hash == oldhash, info = "hash changes with parameter set")
    testthat::expect_equal(object$phash, oldphash, info = "phash is unaffected by parameter set")
    testthat::expect_equal(object_clone$param_set$values[[testingparam]], origval,
      info = "params of cloned objects are distinct")
    object_changed_params = object$clone(deep = TRUE)

    object$param_set$values[[testingparam]] = origval
    testthat::expect_equal(object$param_set$values[[testingparam]], origval, info = "parameters can be reset directly")
    testthat::expect_equal(object$hash, oldhash, info = "hash is changed back by resetting parameter")
    testthat::expect_equal(object$phash, oldphash, info = "phash is unaffected by parameter set reset")

    object$configure(.values = parvals)
    testthat::expect_equal(object$param_set$values[[testingparam]], val,
      info = "configure can set parameters via .values")
    testthat::expect_equal(object$hash, changedhash, info = "hash changes with parameter set through configure")
    testthat::expect_equal(object$phash, oldphash, info = "phash is unaffected by parameter set through configure")
    testthat::expect_equal(object_clone$param_set$values[[testingparam]], origval,
      info = "params of cloned objects are distinct")
    object$configure(.values = parvals_orig)
    testthat::expect_equal(object$param_set$values[[testingparam]], origval,
      info = "configure can reset parameters via .values")
    testthat::expect_equal(object$hash, oldhash,
      info = "hash is unaffected by parameter set reset through configure")
    testthat::expect_equal(object$phash, oldphash,
      info = "phash is unaffected by parameter set reset through configure")


    do.call(object$configure, parvals)
    testthat::expect_equal(object$param_set$values[[testingparam]], val, info = "configure can set parameters via ...")
    testthat::expect_equal(object$hash, changedhash, info = "hash changes with parameter set through configure")
    testthat::expect_equal(object$phash, oldphash, info = "phash is unaffected by parameter set through configure")
    testthat::expect_equal(object_clone$param_set$values[[testingparam]], origval,
      info = "params of cloned objects are distinct")
    do.call(object$configure, parvals_orig)
    testthat::expect_equal(object$param_set$values[[testingparam]], origval,
      info = "configure can reset parameters via ...")
    testthat::expect_equal(object$hash, oldhash,
      info = "hash is unaffected by parameter set reset through configure")
    testthat::expect_equal(object$phash, oldphash,
      info = "phash is unaffected by parameter set reset through configure")

  }

  if (is.null(dict_package)) {
    dict_environment = topenv(object$.__enclos_env__)
  } else if (is.environment(dict_package)) {
    dict_environment = dict_package
  } else {
    dict_environment = asNamespace(dict_package)
  }

  dict_constructor = get(dict_shortaccess, mode = "function", envir = dict_environment)
  # dict_constructor is something like 'lrn', 'po', 'flt' etc.
  checkmate::expect_function(dict_constructor)

  dictionary = dict_constructor()
  checkmate::expect_r6(dictionary, "Dictionary")  # expect an mlr3misc::Dictionary here
  name_of_dictionary = Filter(function(x) identical(dict_environment[[x]], dictionary), names(dict_environment))[1]
  checkmate::expect_string(name_of_dictionary, min.chars = 1L, info = "name of dictionary in dict_environment")


  dict_object = do.call(function(...) dict_constructor(dict_entry, ...), constargs)
  testthat::expect_equal(dict_object, object, info = "object from dictionary is congruent with object")
  if (length(eligibleparams)) {
    dict_object2 = do.call(dict_constructor, c(list(dict_entry), mlr3misc::insert_named(constargs, parvals)))
    testthat::expect_equal(dict_object2, object_changed_params,
      info = "object from dictionary constructed with changed parameters")

    dict_object3 = do.call(dict_constructor, c(list(dict_entry), mlr3misc::insert_named(constargs, parvals_orig)))
    testthat::expect_equal(dict_object3, object, info = "object from dictionary constructed with original parameter")
  }

  if (check_congruent_man || check_package_export) {
    expected_package = topenv(object$.__enclos_env__)$.__NAMESPACE__.$spec[["name"]]
  }

  if (check_congruent_man) {
    checkmate::expect_string(object$man, pattern = sprintf("^%s::[^:]+$", expected_package))
    help_info = strsplit(object$man, "::")[[1]]
    help_topic = utils::help.search(sprintf("^%s$", help_info[[2]]), package = help_info[[1]], ignore.case = FALSE,
      agrep = FALSE, fields = "alias")$matches$Topic
    testthat::expect_true(length(help_topic) > 0L, info = "help page exists")
    testthat::expect_equal(help_topic,
      sprintf("%s_%s", name_of_dictionary, dict_entry),
      info = "help page name is congruent with dict_name and dict_entry")
  }

  if (check_package_export) {
    nspath = dirname(system.file("NAMESPACE", package = expected_package))
    exports = parseNamespaceFile(basename(nspath), dirname(nspath))$exports
    testthat::expect_true(class(object)[[1]] %in% exports, info = "class is exported")
  }

  construction_conf_objects = mget(construction_arguments, envir = object)
  additional_conf_objects = mget(additional_configuration, envir = object)

  # constructing and configuring with original configuration values should not have an effect

  object_explicit_construction = do.call(compclass$new, construction_conf_objects)
  testthat::expect_equal(object_explicit_construction, object,
    info = "construction with arguments retrieved from formals of initialize is equivalent to construction without"
  )

  object3 = do.call(compclass$new, constargs)

  object3$configure(.values = additional_conf_objects)
  testthat::expect_equal(object3, object, info = "configure with additional configuration does not change object")

  dict_object4 = do.call(dict_constructor, c(list(dict_entry), construction_conf_objects, additional_conf_objects))
  testthat::expect_equal(dict_object4, object,
    info = "object can be constructed from initialize-formals and additional_configuration")

  if (!is.null(object$param_set)) {
    dict_object5 = do.call(dict_constructor,
      c(list(dict_entry), construction_conf_objects, additional_conf_objects, object$param_set$values))
    testthat::expect_equal(dict_object5, object,
      info = "object can be constructed from initialize-formals, additional_configuration, and parameter set")
  }
}

#' @title Test many Mlr3Component subclasses
#'
#' @description
#' For a given list of Mlr3Component subclasses, run [expect_mlr3component_subclass()] for each of them.
#'
#' This function calls [testthat::test_that()], so it should *not* be run inside a `test_that()`-block.
#' Instead, it should be run at top level in a test file directly.
#'
#' @param compclasses (`list` of `R6ClassGenerator`)
#'   The list of Mlr3Component subclasses to test.
#'   It is a good idea to auto-generate this, see examples.
#' @param dict_constargs (`list`)
#'   A list of lists of construction arguments to pass to the dictionary.
#'   This list should be named by the class of the component for which they apply, but does not need to be exhaustive.
#'   Components not mentioned in the list get empty construction arguments by default.
#' @param check_congruent_man (`logical(1)`)
#'   Whether to check that the `man` field is congruent with the dictionary name and entry.
#' @param check_package_export (`logical(1)`)
#'   Whether to check that the component is exported from the package.
#' @param dict_package (`character(1)` | `environment`)
#'   The package that contains the dictionary.
#'   If `NULL`, the package of the component is used.
#'   An `environment` can also be passed, which will then be used directly.
#'
#' @examples
#' abstracts = c("PipeOp", "PipeOpEnsemble")
#' nspath = dirname(system.file("NAMESPACE", package = "mlr3pipelines"))
#' exports = parseNamespaceFile(basename(nspath), dirname(nspath))$exports
#' compclass_names = setdiff(grep(exports, pattern = "^PipeOp", value = TRUE), abstract_classes)
#' compclasses = lapply(compclass_names, get, envir = asNamespace("mlr3pipelines"))
#' dict_constargs = list(
#'   PipeOpImputeLearner = list(learner = mlr_learners$get("classif.rpart")),
#'   PipeOpLearner = list(learner = mlr_learners$get("classif.rpart")),
#'   PipeOpLearnerCV = list(learner = mlr_learners$get("classif.rpart")),
#' )
#' test_that_mlr3component_dict(compclasses, dict_constargs, dict_package = "mlr3pipelines")
#' @export

test_that_mlr3component_dict = function(compclasses, dict_constargs, check_congruent_man = TRUE,
  check_package_export = TRUE, dict_package = NULL
) {
  for (compclass in compclasses) {
    clname = compclass$classname
    if (is.null(clname)) {
      clname = "ERROR"  # we don't want top level code to fail.
    }
    testthat::test_that(sprintf("Mlr3Component subclass %s", clname), {
      expect_mlr3component_subclass(
        compclass = compclass,
        constargs = c(list(), dict_constargs[[clname]]),
        check_congruent_man = check_congruent_man,
        check_package_export = check_package_export,
        dict_package = dict_package
      )
    })
  }
}


#' @title Expect that 'one' is a deep clone of 'two'
#'
#' @description
#' Expect that 'one' is a deep clone of 'two'.
#'
#' @param one (`any`)
#'   The first object to compare.
#' @param two (`any`)
#'   The second object to compare.
#'
#' @export
expect_deep_clone = function(one, two) {
  # is equal
  testthat::expect_equal(one, two)
  visited = new.env()  # nolint
  visited_b = new.env()  # nolint
  expect_references_differ = function(a, b, path) {

    force(path)
    if (length(path) > 400) {
      stop("Recursion too deep in expect_deep_clone()")
    }

    # don't go in circles
    addr_a = data.table::address(a)
    addr_b = data.table::address(b)
    if (!is.null(visited[[addr_a]])) {
      return(invisible(NULL))
    }
    visited[[addr_a]] = path
    visited_b[[addr_b]] = path

    # follow attributes, even for non-recursive objects
    if (utils::tail(path, 1) != "[attributes]" && !is.null(base::attributes(a))) {
      Recall(base::attributes(a), base::attributes(b), c(path, "[attributes]"))
    }

    # don't recurse if there is nowhere to go
    if (!base::is.recursive(a)) {
      return(invisible(NULL))
    }

    # check that environments differ
    if (base::is.environment(a)) {
      # some special environments
      if (identical(a, baseenv()) || identical(a, globalenv()) || identical(a, emptyenv())) {
        return(invisible(NULL))
      }
      if (length(path) > 1 && R6::is.R6(a) && !"clone" %in% names(a)) {
        return(invisible(NULL))  # don't check if smth is not cloneable
      }
      label = sprintf("Object addresses differ at path %s", paste0(path, collapse = "->"))
      testthat::expect_true(addr_a != addr_b, label = label)
      testthat::expect_null(visited_b[[addr_a]], label = label)
    } else {
      a <- unclass(a)
      b <- unclass(b)
    }

    # recurse
    if (base::is.function(a)) {
      return(invisible(NULL))
      ## # maybe this is overdoing it
      ## Recall(base::formals(a), base::formals(b), c(path, "[function args]"))
      ## Recall(base::body(a), base::body(b), c(path, "[function body]"))
    }
    objnames = base::names(a)
    if (is.null(objnames) || anyDuplicated(objnames)) {
      index = seq_len(base::length(a))
    } else {
      index = objnames
      if (base::is.environment(a)) {
        index = Filter(function(x) !bindingIsActive(x, a), index)
      }
    }
    for (i in index) {
      if (utils::tail(path, 1) == "[attributes]" && i %in% c("srcref", "srcfile", ".Environment")) next
      Recall(base::`[[`(a, i), base::`[[`(b, i), c(path, sprintf("[element %s]%s", i,
        if (!is.null(objnames)) sprintf(" '%s'", if (is.character(index)) i else objnames[[i]]) else "")))
    }
  }
  expect_references_differ(one, two, "ROOT")
}
