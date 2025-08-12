#' @title Common Base Class for mlr3 Components
#'
#' @description
#' A pragmatic, lightweight base class that captures common patterns across
#' the mlr3 ecosystem.
#' It standardizes fields like `id`, `label`, `param_set`, `packages`, and `man`,
#' and provides shared methods for printing, help lookup, configuration of
#' parameter values and fields, and stable hashing.
#'
#' Subclasses can specialize behavior by:
#' - Adding additional public/active fields and methods.
#' - Overriding `print()` for richer output.
#' - Extending the hash inputs via `private$.extra_hash` or by overriding
#'   the `hash`/`phash` active bindings if necessary.
#'
#' @section Construction:
#' Mlr3Component$new(id, param_set = NULL, packages = character(),
#'   label = NA_character_, man = NA_character_)
#'
#' - `id` (`character(1)`): Identifier of the component.
#' - `param_set` ([paradox::ParamSet] | `NULL`): Optional hyperparameter set.
#'   If given, its `$values` are used by `$configure()` and are included in the hash.
#' - `packages` (`character()`): Required packages (namespaces). Not attached.
#'
#' @section Inheriting:
#' To create your own `Mlr3Component`, you need to overload the `$initialize()` function to do additional
#' initialization. The `$initialize()` method should have at least the arguments `id` and `param_set`, which should be
#' passed on to `super$initialize()` unchanged.
#' To create a class without a `param_set`, you can pass `NULL` as the `param_set` argument.
#' `packages` should have the default value `character(0)`, meaning no packages are required.
#' `properties` should have the default value `character(0)`, meaning no properties are set.
#'
#' If the `$initialize()` method has more arguments, then it is necessary to also overload the
#' `private$.additional_phash_input()` function. This function should return either all objects, or a hash of all
#' objects, that can change the function or behavior of the `Mlr3Component` and are independent
#' of the class, the id, the `$state`, and the `$param_set$values`. The last point is particularly important:
#' changing the `$param_set$values` should
#' *not* change the return value of `private$.additional_phash_input()`.
#'
#' @export
Mlr3Component = R6Class("Mlr3Component",
  public = list(
    #' @description
    #' Construct a new `Mlr3Component`.
    #' @param id (`character(1)`)
    #' @param param_set ([paradox::ParamSet] | `NULL`)
    #' @param packages (`character()`)
    initialize = function(dict_entry, dict_shortaccess, id = dict_entry,
      param_set = ps(), packages = character(0), properties = character(0),
      representable = TRUE
    ) {
      private$.has_id = !is.null(id)
      if (private$.has_id) {
        self$id = id
      } else {
        # if ID is not provided, it is read-only set to the dictionary entry
        private$.id = dict_entry
      }

      if (!is.null(packages)) {
        assert_character(packages, any.missing = FALSE, min.chars = 1L)
        check_packages_installed(packages,
          msg = sprintf("Package '%%s' required but not installed for %s '%s'",
            class(self)[1L], self$id))
        env = self$.__enclos_env__
        while (!is.null(env)) {
          packages[[length(packages) + 1]] = topenv(env)$.__NAMESPACE__.$spec[["name"]]
          env = env$super$.__enclos_env__
        }
        private$.packages = unique(packages[packages != "mlr3misc"])
      }

      private$.properties = unique(assert_character(properties, any.missing = FALSE, min.chars = 1L, null.ok = TRUE))

      # ParamSet is optional to keep this base class generic across components
      if (is.null(param_set)) {
        private$.param_set = NULL
        private$.param_set_source = NULL
        rm("param_set", envir = self)
      } else if (inherits(param_set, "ParamSet")) {
        private$.param_set = assert_param_set(param_set)
        private$.param_set_source = NULL
      } else {
        lapply(param_set, function(x) assert_param_set(eval(x)))
        private$.param_set_source = param_set
      }

      # upfront check; does not attach
      if (length(self$packages)) {
        check_packages_installed(self$packages,
          msg = sprintf("Package '%%s' required but not installed for %s '%s'",
            class(self)[1L], self$id))
      }
    },

    #' @description
    #' Helper for print outputs.
    #' @param ... (ignored).
    format = function(...) {
      if (private$.has_id) {
        sprintf("<%s:%s>", class(self)[1L], self$id)
      } else {
        sprintf("<%s>", class(self)[1L])
      }
    },

    #' @description
    #' Printer with concise, unified output.
    print = function(...) {
      msg_h = if (is.null(self$label) || is.na(self$label)) "" else paste0(": ", self$label)
      cat_cli({
        cli::cli_h1("{.cls {class(self)[1L]}} ({self$id}){msg_h}")
        cli::cli_li("Parameters: {as_short_string(if (is.null(private$.param_set)) list() else private$.param_set$values, 1000L)}")
        cli::cli_li("Packages: {.pkg {if (length(self$packages)) self$packages else '-'}}")
      })
    },

    #' @description
    #' Opens the corresponding help page referenced by field `$man`.
    help = function() {
      open_help(self$man)
    },

    #' @description
    #' Set parameter values and fields in one step.
    #' Named arguments overlapping with the `ParamSet` are set as parameters;
    #' remaining arguments are assumed to be regular fields of the object.
    #' @param ... (named `any`)
    #' @param .values (named `list()`)
    configure = function(..., .values = list()) {
      dots = list(...)
      assert_list(dots, names = "unique")
      assert_list(.values, names = "unique")
      assert_disjunct(names(dots), names(.values))
      new_values = insert_named(dots, .values)

      # set params in ParamSet if available
      if (!is.null(private$.param_set) && length(new_values)) {
        param_ids = private$.param_set$ids()
        ii = names(new_values) %in% param_ids
        if (any(ii)) {
          private$.param_set$values = insert_named(private$.param_set$values, new_values[ii])
          new_values = new_values[!ii]
        }
      } else {
        param_ids = character()
      }

      # remaining args become fields
      if (length(new_values)) {
        ndots = names(new_values)
        for (i in seq_along(new_values)) {
          nn = ndots[[i]]
          if (!exists(nn, envir = self, inherits = FALSE)) {
            stopf("Cannot set argument '%s' for '%s' (not a parameter, not a field).%s",
              nn, class(self)[1L], did_you_mean(nn, setdiff(names(self), ".__enclos_env__"))) # nolint
          }
          self[[nn]] = new_values[[i]]
        }
      }

      invisible(self)
    },

    #' @description
    #' Convenience: load (not attach) required namespaces.
    #' Raises a `packageNotFoundError` if loading fails.
    require_namespaces = function() {
      if (length(self$packages)) require_namespaces(self$packages)
      invisible(self)
    },

    #' @description
    #' Override the `man` and `hash` fields.
    #' @param man (`character(1)` | `NULL`)
    #'   The manual page of the component.
    #' @param hash (`character(1)` | `NULL`)
    #'   The hash of the component.
    override_info = function(man = NULL, hash = NULL) {
      if (!is.null(man)) {
        private$.man = man
        private$.label = NULL
      }
      if (!is.null(hash)) {
        private$.hashmap = NULL
        orig_phash = self$phash
        orig_hash = self$hash
        private$.hashmap = structure(c(hash, hash), names = c(orig_hash, orig_phash))
      }
    }
  ),

  active = list(
    #' @field id (`character(1)`)
    #' Identifier of the object.
    #' Used in tables, plot and text output.
    id = function(rhs) {
      if (!missing(rhs)) {
        if (!private$.has_id) {
          stop("id is read-only")
        }
        private$.id = assert_string(rhs, min.chars = 1L)
      }
      private$.id
    },

    #' @field label (`character(1)`)
    #' Human-friendly label.
    #' Can be used in tables, plot and text output instead of the ID.
    label = function(rhs) {
      if (!missing(rhs)) stop("label is read-only")
      if (is.null(private$.label)) {
        helpinfo = self$help()
        helpcontent = NULL
        if (inherits(helpinfo, "help_files_with_topic") && length(helpinfo)) {
          ghf = get(".getHelpFile", mode = "function", envir = getNamespace("utils"))
          helpcontent = ghf(helpinfo)
        } else if (inherits(helpinfo, "dev_topic")) {
          helpcontent = tools::parse_Rd(helpinfo$path)
        }
        if (is.null(helpcontent)) {
          private$.label = "LABEL COULD NOT BE RETRIEVED"
        } else {
          private$.label = Filter(function(x) identical(attr(x, "Rd_tag"), "\\title"), helpcontent)[[1]][[1]][1]
        }
      }
      private$.label
    },

    #' @field packages (`character()`)
    #' Set of required packages.
    #' These packages are loaded, but not attached.
    packages = function(rhs) {
      if (!missing(rhs)) stop("packages is read-only")
      private$.packages
    },

    #' @field properties (`character()`)\cr
    #' Stores a set of properties/capabilities the learner has.
    #' A complete list of candidate properties, grouped by task type, is stored in
    #' [`mlr_reflections$learner_properties`][mlr_reflections].
    properties = function(rhs) {
      if (!missing(rhs)) stop("properties is read-only")
      private$.properties
    },

    #' @field param_set ([paradox::ParamSet] | `NULL`)
    #' Set of hyperparameters.
    param_set = function(val) {
      if (is.null(private$.param_set)) {
        sourcelist = lapply(private$.param_set_source, function(x) eval(x))
        if (length(sourcelist) > 1) {
          private$.param_set = ParamSetCollection$new(sourcelist)
        } else {
          private$.param_set = sourcelist[[1]]
        }
      }
      if (!missing(val) && !identical(val, private$.param_set)) {
        stop("param_set is read-only.")
      }
      private$.param_set
    },

    #' @field man (`character(1)`)
    #' String in the format `[pkg]::[class name]` pointing to a manual page for this object.
    man = function(rhs) {
      if (!missing(rhs)) stop("man is read-only")
      if (is.null(private$.man)) {
        iter = 1
        env = self
        repeat {
          man = paste0(topenv(env$.__enclos_env__)$.__NAMESPACE__.$spec[["name"]], "::", class(self)[[iter]])
          help_works = tryCatch({
            open_help(man)
            TRUE
          }, error = function(e) FALSE)
          if (help_works) {
            private$.man = man
            break
          }
          iter = iter + 1
          env = env$.__enclos_env__$super
        }
      }
      private$.man
    },

    #' @field hash (`character(1)`)
    #' Stable hash that includes id, parameter values (if present) and `private$.extra_hash` fields.
    hash = function(rhs) {
      if (!missing(rhs)) stop("hash is read-only")
      hash = calculate_hash(class(self), self$id, .list = list(self$param_set$values, private$.additional_phash_input()))
      if (hash %in% names(private$.hashmap)) {
        private$.hashmap[[hash]]
      } else {
        hash
      }
    },

    #' @field phash (`character(1)`)
    #' Stable hash excluding parameter values (for tuning / partial identity), but including `private$.extra_hash`.
    phash = function(rhs) {
      if (!missing(rhs)) stop("phash is read-only")
      hash = calculate_hash(
        class(self), self$id,
        list(private$.additional_phash_input())
      )
      if (hash %in% names(private$.hashmap)) {
        private$.hashmap[[hash]]
      } else {
        hash
      }
    }
  ),

  private = list(
    .has_id = NULL,
    .id = NULL,
    .param_set = NULL,
    .packages = NULL,
    .properties = NULL,
    .param_set_source = NULL,
    .label = NULL,
    .man = NULL,
    .hashmap = NULL,

    .additional_phash_input = function() {
      if (is.null(self$initialize)) return(NULL)
      sc = sys.calls()
      # if we are called through `super$.additional_phash_input()` we are not complaining
      if (length(sc) > 1 && identical(sc[[length(sc) - 1]][[1]], quote(super$.additional_phash_input))) return(NULL)
      initformals <- names(formals(args(self$initialize)))
      if (!test_subset(initformals, c("id", "param_vals"))) {
        stopf("Class %s has construction arguments besides 'id' and 'param_vals' but does not overload the private '.additional_phash_input()' function.

The hash and phash of a class must differ when it represents a different operation; since %s has construction arguments that could change the operation that is performed by it, it is necessary for the $hash and $phash to reflect this. `.additional_phash_input()` should return all the information (e.g. hashes of encapsulated items) that should additionally be hashed; read the help of ?Mlr3Component for more information.",  # nolint
        class(self)[[1]], class(self)[[1]])
      }
    },

    deep_clone = function(name, value) {
      if (!is.null(private$.param_set_source)) {
        private$.param_set = NULL  # required to keep clone identical to original, otherwise tests get really ugly
        if (name == ".param_set_source") {
          value = lapply(value, function(x) {
            if (inherits(x, "R6")) x$clone(deep = TRUE) else x
          })
        }
      }
      if (is.environment(value) && ".__enclos_env__" %in% names(value) && "clone" %in% names(value)) {
        return(value$clone(deep = TRUE))
      }
      value
    }
  )
)



# TODO
# - dict_entry: own id in the dictionary
# - dict_shortaccess: dictionary short access name
# - autotest: construction vars are also active bindings
# - autotest: manual name congruent with dictionary
# - own param set thing
# - autotests from miesmuschel
# - what to do with composite objects?

# - cloning
# - conversion objects
# - dict_entry NULL -> not in dictionary, constructed via as_learner etc.
# - auto packages
# - warning if dict_entry is wrong
#   - but only if constructed via a package; maybe check 'mlr3'-packages first.
# - label & man deprecation
# - what to do with non-algorithm classes (objective, resamplingresult, databackend, etc)?

#' @title Deprecation Message related to the `Mlr3Component` Class
#'
#' @description
#' Will give different messages depending on deprecation progression and will be more agressive in tests than
#' interactively.
#'
#' @keywords internal
#' @param msg (`character(1)`)
#'   Message to print.
#' @export
deprecated_component = function(msg) {
  if (!identical(getOption("mlr3.on_deprecated", "ignore"), "ignore")) {
    if (identical(getOption("mlr3.on_deprecated"), "warn")) {
      warning(msg)
    } else {
      stop(msg)
    }
  }
}
