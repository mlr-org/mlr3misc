#' @title Common Base Class for mlr3 Components
#'
#' @description
#' A pragmatic, lightweight base class that captures common patterns across the mlr3 ecosystem.
#' It standardizes various fields and provides shared methods for printing, help lookup, setting parameter values and fields, and hashing.
#'
#' Semantically, an mlr3 component is usually an object representing an algorithm or a method, such as a [mlr3::Learner] or a [mlr3::Measure].
#' This algorithm can be configured though its parameters, accessible as the [paradox::ParamSet] in the `$param_set` field, as well as
#' through various other custom algorithm-specific fields.
#' All of these together can be changed via the `$configure()` method.
#' Some components, such as prominently the [mlr3::Learner], also have "state", such as the learned model.
#'
#' The identity of an object represented by an [`Mlr3Component`] is sometimes important, for example when aggregating benchmark results accross various settings of different algorithms used in tha benchmark, such as different [mlr3::Learner]s or different [mlr3::Measure].
#' For this,the component provides a `$hash` field, which should identify the algorithm and its configuration, without including the state.
#' There is also the `$phash` field, which identifies the algorithm without its `$param_set` configuration -- this is used when aggregating benchmark results for individual algorithms when these algorithms were evaluated for different configuration parameter settings.
#'
#' [`Mlr3Component`]s should usually be constructed from a [Dictionary], which should be accessible via a short-form, such as [mlr3::lrn] or [mlr3pipelines::po].
#'
#' @section Inheriting:
#' To create your own `Mlr3Component`, you need to overload the `$initialize()` function.
#' A concrete class should ideally provide all arguments of the `$initialize()` directly, i.e. the user should not need to provide `id` or `param_set`.
#'
#' The information contained in a concrete mlr3 component should usually be completely determined by four things:
#'
#' 1. The *construction arguments* given to the `$initialize()` method of the concrete class.
#'    These can be [`Mlr3Component`]s themselves, or configuration options that do not naturally fit into the [paradox::ParamSet].
#'    These arguments should *not* overlap with the [paradox::ParamSet] parameters, and should not be the construction arguments of the
#'    abstract [Mlr3Component] base class such as `id` or `packages`.
#' 2. The *configuration arguments* inside `$param_set$values`.
#' 3. Additional *configuration settings* that influence the behavior of the component, but are not part of the [paradox::ParamSet] because they do not naturally constitute a dimension that could be optimized.
#' 4. Some additional *state information*, storing the result of the algorithm, such as the learned model, often contained in a field called `$state`.
#'
#' Information from 1. should also be made accessible as active bindings, with the same name as the construction arguments.
#'
#' The information from 1., and 3. is contained in the `$phash` value.
#' For this, the `private$.additional_phash_input()` function needs to be overloaded by subclasses.
#' It is often sufficient for an abstract subclass to implement this, and concrete classes to inherit from this. E.g. the [mlr3::Learner] class implements `$private$.additional_phash_input()` to return the necessary iformation to be included in the `$phash` for almost all possible [mlr3::Learner]s.
#' Only concrete [mlr3::Learner]s that contain additional information not contained in one of the standard fields needs to overload the function again, such as e.g. [mlr3tuning::AutoTuner].
#' It is best if this second overload only collects the additional information not contained in the abstract base class, and also calls `super$.additional_phash_input()`.
#'
#' The information from 1., 2., and 3. together is contained in the `$phash` value.
#' It is also collected automatically from the `private$.additional_phash_input()` function, as well as the `$param_set$values` field.
#'
#' The information from 3. should be made available through the `additional_configuration` construction argument of [`Mlr3Component`].
#'
#' @section Cloning:
#' [`Mlr3Component`] implements a `private$deep_clone()` method that automatically clones R6 objects stored directly in the object, as well as in `$param_set$values`.
#' Because of the way the `$param_set` field is handled, subclasses that need to do additional cloning should overload this function, but always call `super$deep_clone(name, value)` for values they do not handle.
#'
#'
#' @export
Mlr3Component = R6Class("Mlr3Component",
  public = list(
    #' @description
    #' Construct a new `Mlr3Component`.
    #' @param dict_entry (`character(1)`)
    #'   The entry in the dictionary by which this component can be constructed.
    #' @param dict_shortaccess (`character(1)`)
    #'   Name of the short access function for the dictionary that this component can be found under.
    #'   `get(dict_shortaccess, mode = "function")(dict_entry)` should create an object of the concrete class.
    #' @param id (`character(1)`)
    #'   The ID of the constructed object.
    #'   ID field can be used to identify objects in tables or plots, and sometimes to prefix parameter names in combined [paradox::ParamSet]s.
    #'   If instances of a given abstract subclass should all not have IDs, this should be set to `NULL`.
    #'   Should default to the value of `dict_entry` in most cases, with few exceptions for wrapper objects (e.g. a [mlr3pipelines::PipeOp] wrapping a [mlr3::Learner]).
    #' @param param_set ([paradox::ParamSet] | `list` | `NULL`)
    #'   Parameter space description. This should be created by the subclass and given to `super$initialize()`.
    #'   If this is a [`ParamSet`][paradox::ParamSet], it is used for `$param_set` directly.
    #'   Otherwise it must be a `list` of expressions e.g. created by `alist()` that evaluate to [`ParamSet`][paradox::ParamSet]s.
    #'   These [`ParamSet`][paradox::ParamSet] are combined using a [`ParamSetCollection`][paradox::ParamSetCollection].\cr
    #'   If instances of a given abstract subclass should all not have a [paradox::ParamSet], this should be set to `NULL`.
    #'   Otherwise, if a concrete subclass just happens to have an empty search space, the default [paradox::ps()] should be used.
    #' @param packages (`character()`)
    #'   The packages required by the constructed object.
    #'   The constructor will check whether these packages can be loaded and give a warning otherwise.
    #'   The packages of the R6 objects in the inheritance hierarchy are automatically added and do not need to be provided here.
    #'   Elements of `packages` are deduplicated and made accessible as the `$packages` field.
    #' @param properties (`character()`)
    #'   A set of properties/capabilities the object has.
    #'   These often need to be a subset of an entry in [mlr3::mlr_reflections].
    #'   However, the [`Mlr3Component`] constructor does not check this, it needs to be asserted by an abstract inheriting class.
    #'   Elements are deduplicated and made accessible as the `$properties` field.
    #' @param additional_configuration (`character()`)
    #'   Names of class fields that constitute additional configuration settings that influence the behavior of the component, but are neither construction argument, nor part of the [paradox::ParamSet].
    #'   An example is the `$predict_type` field of a [mlr3::Learner].
    #' @param representable (`logical(1)`)
    #'   Whether the object can be represented as a simple string.
    #'   Should generally be `TRUE` except for objects that are constructed with a large amount of data, such as [mlr3::Task]s.
    initialize = function(dict_entry, dict_shortaccess, id = dict_entry,
      param_set = ps(), packages = character(0), properties = character(0),
      additional_configuration = character(0),
      representable = TRUE
    ) {
      private$.dict_entry = assert_string(dict_entry)
      private$.dict_shortaccess = assert_string(dict_shortaccess)
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
          newpkg = topenv(env)$.__NAMESPACE__.$spec[["name"]]
          if (length(newpkg) == 1L) {
            packages[[length(packages) + 1]] = newpkg
          }
          env = env$super$.__enclos_env__
        }
        private$.packages = unique(packages[packages != "mlr3misc"])
      }

      private$.properties = unique(assert_character(properties, any.missing = FALSE, min.chars = 1L, null.ok = TRUE))

      # ParamSet is optional to keep this base class generic across components
      if (is.null(param_set)) {
        private$.param_set = NULL
        private$.param_set_source = NULL
      } else if (inherits(param_set, "ParamSet")) {
        private$.param_set = paradox::assert_param_set(param_set)
        private$.param_set_source = NULL
      } else {
        lapply(param_set, function(x) paradox::assert_param_set(eval(x)))
        private$.param_set_source = param_set
      }

      assert_character(additional_configuration, any.missing = FALSE, min.chars = 1L, unique = TRUE)
      assert_subset(additional_configuration, names(self))
      assert_disjunct(additional_configuration, c(
        # additional configuration can not be:
        # (1) a parameter, (2) a construction argument (these are captured automatically), (3) a standard field
        if (!is.null(self$param_set)) self$param_set$ids(),
        names(formals(self$initialize)),
        "id", "label", "param_set", "packages", "properties", "format", "print", "help", "configure", "override_info", "man", "hash", "phash"
      ))
      private$.additional_configuration = additional_configuration
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
    #' Printer.
    #' @param ... (ignored).
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
    #' Named arguments overlapping with the [`ParamSet`][paradox::ParamSet] are set as parameters;
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
    #' Auto-generated from the title of the help page.
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
    #' Absence of these packages will generate a warning during construction.
    packages = function(rhs) {
      if (!missing(rhs)) stop("packages is read-only")
      private$.packages
    },

    #' @field properties (`character()`)\cr
    #' Stores a set of properties/capabilities the object has.
    #' These are set during construction and should not be changed afterwards.
    #' They may be "optimistic" in the sense that the true capabilities could depend on specific configuration parameter settings;
    #' `$properties` then indicate the capabilities under favorable configuration settings.
    properties = function(rhs) {
      if (!missing(rhs)) {
        mlr3component_deprecation_msg("writing to properties is deprecated. Write to private$.properties if this is necessary for tests.")  # nolint
        # stop("properties is read-only")
        private$.properties = rhs
      }
      private$.properties
    },

    #' @field param_set ([paradox::ParamSet] | `NULL`)
    #' Set of hyperparameters.
    param_set = function(val) {
      if (is.null(private$.param_set) && !is.null(private$.param_set_source)) {
        sourcelist = lapply(private$.param_set_source, function(x) eval(x))
        if (length(sourcelist) > 1) {
          private$.param_set = paradox::ParamSetCollection$new(sourcelist)
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
    #' Inferred automatically from the class name and package in which the class is defined.
    #' If a concrete class is not defined in a package, the help page of its first parent class with a help page is used.
    #' Can be overridden with the `$override_info()` method.
    man = function(rhs) {
      if (!missing(rhs)) {
        mlr3component_deprecation_msg("writing to man is deprecated")
        private$.man = rhs
        # stop("man is read-only")
      }
      if (is.null(private$.man)) {
        iter = 1
        env = self
        repeat {
          man = paste0(topenv(env$.__enclos_env__)$.__NAMESPACE__.$spec[["name"]], "::", class(self)[[iter]])
          help_works = tryCatch({
            length(as.character(open_help(man))) > 0L
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
    #' Stable hash that includes id, parameter values (if present) and additional configuration settings (from construction or class fields) but not state.
    #' Makes use of the `private$.additional_phash_input()` function to collect additional information, which must therefore be implemented by subclasses.
    hash = function(rhs) {
      if (!missing(rhs)) stop("hash is read-only")
      hash = calculate_hash(class(self), self$id, .list = c(self$param_set$values, private$.additional_phash_input()))
      if (hash %in% names(private$.hashmap)) {
        private$.hashmap[[hash]]
      } else {
        hash
      }
    },

    #' @field phash (`character(1)`)
    #' Hash that includes id and additional configuration settings (from construction or class fields) but not parameter values and no state.
    #' Makes use of the `private$.additional_phash_input()` function to collect additional information, which must therefore be implemented by subclasses.
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
    .dict_entry = NULL,
    .dict_shortaccess = NULL,
    .has_id = NULL,
    .id = NULL,
    .param_set = NULL,
    .packages = NULL,
    .properties = NULL,
    .param_set_source = NULL,
    .label = NULL,
    .man = NULL,
    .hashmap = NULL,
    .additional_configuration = NULL,

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
mlr3component_deprecation_msg = function(msg) {
  if (!identical(getOption("mlr3.on_deprecated_mlr3component", "ignore"), "ignore")) {
    if (identical(getOption("mlr3.on_deprecated_mlr3component"), "warn")) {
      warning(msg)
    } else {
      stop(msg)
    }
  }
}
