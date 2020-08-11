context("leanify")

make_classes = function(pe = parent.frame()) {
  cls_top = R6::R6Class("test", parent_env = pe,
    public = list(a = function() 1),
    private = list(b = function() 2),
    active = list(c = function() 3))
  cls_bottom = R6::R6Class("test_sub", parent_env = pe, inherit = cls_top,
    public = list(a = function() super$a() + 1),
    private = list(b = function() super$b() + 1),
    active = list(c = function() super$c + 1))
  pe$cls_top = cls_top
  pe$cls_bottom = cls_bottom
  list(cls_top = cls_top, cls_bottom = cls_bottom)
}

test_that("leanificate method", {

  en = new.env(parent = emptyenv())
  clx = make_classes(en)

  leanificate_method(clx$cls_top, "a", en)
  expect_equal(as.character(body(clx$cls_top$new()$a)[[1]]), ".__test__a")
  expect_subset(".__test__a", names(en))
  expect_equal(clx$cls_top$new()$a(), 1)

  leanificate_method(clx$cls_top, "b", en)
  expect_equal(as.character(body(clx$cls_top$new()$.__enclos_env__$private$b)[[1]]), ".__test__b")
  expect_subset(".__test__b", names(en))
  expect_equal(clx$cls_top$new()$.__enclos_env__$private$b(), 2)

  leanificate_method(clx$cls_top, "c", en)
  expect_equal(as.character(body(clx$cls_top$new()$.__enclos_env__$.__active__$c)[[1]]), ".__test__c")
  expect_subset(".__test__c", names(en))
  expect_equal(clx$cls_top$new()$c, 3)

  leanificate_method(clx$cls_bottom, "a", en)
  expect_equal(as.character(body(clx$cls_bottom$new()$a)[[1]]), ".__test_sub__a")
  expect_subset(".__test_sub__a", names(en))
  expect_equal(clx$cls_bottom$new()$a(), 2)

  leanificate_method(clx$cls_bottom, "b", en)
  expect_equal(as.character(body(clx$cls_bottom$new()$.__enclos_env__$private$b)[[1]]), ".__test_sub__b")
  expect_subset(".__test_sub__b", names(en))
  expect_equal(clx$cls_bottom$new()$.__enclos_env__$private$b(), 3)

  leanificate_method(clx$cls_bottom, "c", en)
  expect_equal(as.character(body(clx$cls_bottom$new()$.__enclos_env__$.__active__$c)[[1]]), ".__test_sub__c")
  expect_subset(".__test_sub__c", names(en))
  expect_equal(clx$cls_bottom$new()$c, 4)

})

test_that("leanify r6 method", {

  en = new.env(parent = emptyenv())
  clx = make_classes(en)

  leanify_r6(clx$cls_bottom, en)

  expect_equal(as.character(body(clx$cls_bottom$new()$a)[[1]]), ".__test_sub__a")
  expect_subset(".__test_sub__a", names(en))
  expect_equal(clx$cls_bottom$new()$a(), 2)

  expect_equal(as.character(body(clx$cls_bottom$new()$.__enclos_env__$private$b)[[1]]), ".__test_sub__b")
  expect_subset(".__test_sub__b", names(en))
  expect_equal(clx$cls_bottom$new()$.__enclos_env__$private$b(), 3)

  expect_equal(as.character(body(clx$cls_bottom$new()$.__enclos_env__$.__active__$c)[[1]]), ".__test_sub__c")
  expect_subset(".__test_sub__c", names(en))
  expect_equal(clx$cls_bottom$new()$c, 4)
})

test_that("leanify_package", {

  en = new.env(parent = emptyenv())
  clx = make_classes(en)

  leanify_package(en, function(x) x$classname == "test_sub")

  expect_equal(as.character(body(clx$cls_top$new()$a)[[1]]), ".__test__a")
  expect_subset(".__test__a", names(en))
  expect_equal(clx$cls_top$new()$a(), 1)

  expect_equal(as.character(body(clx$cls_top$new()$.__enclos_env__$private$b)[[1]]), ".__test__b")
  expect_subset(".__test__b", names(en))
  expect_equal(clx$cls_top$new()$.__enclos_env__$private$b(), 2)

  expect_equal(as.character(body(clx$cls_top$new()$.__enclos_env__$.__active__$c)[[1]]), ".__test__c")
  expect_subset(".__test__c", names(en))
  expect_equal(clx$cls_top$new()$c, 3)

})
