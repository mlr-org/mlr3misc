# formatting

    Code
      stopf("abc")
    Condition
      Error:
      ! abc

---

    Code
      stopf("s: %s", "b")
    Condition
      Error:
      ! s: b

---

    Code
      warningf("abc")
    Condition
      Warning:
      abc

