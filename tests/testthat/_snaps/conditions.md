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

