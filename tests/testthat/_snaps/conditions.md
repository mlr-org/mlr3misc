# errors

    Code
      error_input("a: %s", "b")
    Condition
      Error:
      ! 
      x a: b
      > Class: Mlr3ErrorInput

---

    Code
      error_config("abc")
    Condition
      Error:
      ! 
      x abc
      > Class: Mlr3ErrorConfig

---

    Code
      error_timeout()
    Condition
      Error:
      ! 
      x reached elapsed time limit
      > Class: Mlr3ErrorTimeout

---

    Code
      error_mlr3("abc")
    Condition
      Error:
      ! 
      x abc
      > Class: Mlr3Error

# warnings

    Code
      warning_config("%s & %s", "a", "b")
    Condition
      Warning:
      
      x a & b
      > Class: Mlr3WarningConfig

---

    Code
      warning_mlr3("a")
    Condition
      Warning:
      
      x a
      > Class: Mlr3Warning

# bullets

    Code
      error_mlr3(c(i = "abc", i = "def"))
    Condition
      Error:
      ! 
      abc
      def
      > Class: Mlr3Error

# parent error chaining

    Code
      error_mlr3("wrapper context", parent = parent)
    Condition
      Error:
      ! 
      x wrapper context
      > Class: Mlr3Error
      Caused by:
        x original problem
        > Class: Mlr3Error

---

    Code
      error_mlr3("wrapper", parent = plain_error)
    Condition
      Error:
      ! 
      x wrapper
      > Class: Mlr3Error
      Caused by:
        plain error

---

    Code
      error_mlr3("outer", parent = middle)
    Condition
      Error:
      ! 
      x outer
      > Class: Mlr3Error
      Caused by:
        x middle
        > Class: Mlr3Error
        Caused by:
          x inner
          > Class: Mlr3Error

