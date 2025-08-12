# formatting

    Code
      stopf("abc")
    Condition
      Error:
      ! 
      x abc
      > Class: Mlr3Error

---

    Code
      stopf("s: %s", "b")
    Condition
      Error:
      ! 
      x s: b
      > Class: Mlr3Error

---

    Code
      warningf("abc")
    Condition
      Warning:
      
      x abc
      > Class: Mlr3Warning

