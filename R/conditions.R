create_condition = function(.signal, .msg, ..., .class, .attach) {
  assert_string(.msg)
  assert_character(.class, any.missing = FALSE, min.chars = 1L, null.ok = TRUE)
  assert_list(.attach, null.ok = TRUE, names = "unique")

  condition = insert_named(list(message = sprintf(.msg, ...), call = NULL), .attach)
  set_class(condition, c(.class, .signal, "condition"))
}

signal_message = function(.msg, ..., .class = NULL, .attach = NULL) {
  condition = create_condition("message", .msg = .msg, ..., .class = .class, .attach = .attach)
  message(condition)
}

signal_warning = function(.msg, ..., .class = NULL, .attach = NULL) {
  condition = create_condition("warning", .msg = .msg, ..., .class = .class, .attach = .attach)
  warning(condition)
}

signal_error = function(.msg, ..., .class = NULL, .attach = NULL) {
  condition = create_condition("error", .msg = .msg, ..., .class = .class, .attach = .attach)
  warning(condition)
}
