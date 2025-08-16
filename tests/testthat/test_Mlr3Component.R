skip_if_not_installed("paradox")

MiniBaseclass = R6Class("MiniBaseclass", inherit = Mlr3Component,
  public = list(
    initialize = function(id, param_set = ps(), properties = character(0),
      packages = character(0), additional_configuration = character(0)) {
      super$initialize(dict_entry = id, dict_shortaccess = "mini",
        param_set = param_set, properties = properties, packages = packages,
        additional_configuration = c("some_configurable", additional_configuration)
      )
      private$.some_configurable = TRUE
    }
  ),
  active = list(
    some_configurable = function(value) {
      if (!missing(value)) {
        private$.some_configurable = value
      }
      private$.some_configurable
    }
  ),
  private = list(
    .some_configurable = NULL,
    .additional_phash_input = function() {
      list(private$.some_configurable, super$.additional_phash_input())
    }
  )
)

mlr_mini = R6Class("DictionaryMini", inherit = Dictionary, cloneable = FALSE,
)$new()

mini = function(.key, ...) {
  dictionary_sugar_get(dict = mlr_mini, .key, ...)
}

MiniConcrete = R6Class("MiniConcrete", inherit = MiniBaseclass,
  public = list(
    initialize = function(constarg) {
      super$initialize(id = "concrete",
        param_set = paradox::ps(x = paradox::p_dbl(0, 10, init = 2)), properties = "xyz",
        packages = "data.table",  # we know this one is present
        additional_configuration = "some_other_configurable"
      )
      private$.constarg = constarg
      private$.some_other_configurable = FALSE
    }
  ),
  active = list(
    some_other_configurable = function(value) {
      if (!missing(value)) {
        private$.some_other_configurable = value
      }
      private$.some_other_configurable
    },
    constarg = function(value) {
      if (!missing(value)) {
        private$.constarg = value
      }
      private$.constarg
    }
  ),
  private = list(
    .some_other_configurable = NULL,
    .constarg = NULL,
    .additional_phash_input = function() {
      list(private$.some_other_configurable, super$.additional_phash_input())
    }
  )
)

mlr_mini$add("concrete", MiniConcrete)


test_that("Mlr3Component basic tests", {
  object = mini("concrete", constarg = "testvalue")
  expect_equal(object$constarg, "testvalue")
  expect_equal(object$some_other_configurable, FALSE)
  expect_equal(object$some_configurable, TRUE)
  expect_equal(object$id, "concrete")
  expect_equal(object$param_set$values, list(x = 2))
  object$id = "newid"
  expect_equal(object$id, "newid")
  expect_string(object$hash)
  expect_string(object$phash)
  expect_equal(object$format(), "<MiniConcrete:newid>")
  expect_output(object$print(), "<MiniConcrete> \\(newid\\)")

  object$configure(x = 3, some_configurable = FALSE, id = "newerid")
  expect_equal(object$some_configurable, FALSE)
  expect_equal(object$id, "newerid")
  expect_equal(object$param_set$values, list(x = 3))

  # The man page is Mlr3Component, since MiniBaseclass and MiniConcrete don't have help pages
  expect_equal(object$man, "mlr3misc::Mlr3Component")
  expect_equal(object$packages, "data.table")
  expect_equal(object$properties, "xyz")

  object$override_info(man = "mlr3misc::MiniConcrete", hash = "abcxyz")
  expect_equal(object$man, "mlr3misc::MiniConcrete")
  expect_equal(object$hash, "abcxyz")
  expect_equal(object$phash, "abcxyz")
  object$param_set$values$x = 4

  expect_equal(object$phash, "abcxyz")
  expect_true(object$hash != "abcxyz")

  object$param_set$values$x = 3
  expect_equal(object$hash, "abcxyz")
  expect_equal(object$phash, "abcxyz")
})


test_that_mlr3component_dict(
  compclasses = list(MiniConcrete),
  dict_constargs = list(MiniConcrete = list(constarg = "testconstargval")),
  check_congruent_man = FALSE,  # test-class does not have correct man page value
  check_package_export = FALSE,  # test-class is not exported
  dict_package = environment()  # dictionary is in this environment
)
