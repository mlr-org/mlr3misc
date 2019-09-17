# mlr3misc 0.1.4

* Added argument `na_rm` to `which_max()` and `which_min()`.
* Fixed a bug in `as_short_string()` for empty atomic vectors.

# mlr3misc 0.1.3

* New function `detect()`.
* New function `dictionary_sugar()`.
* It is now asserted that the return value of `Dictionary$get()` is an R6 object.
* Fix some assertions in `Dictionary`

# mlr3misc 0.1.2

* New function `named_vector()`.
* New function `keep_in_bounds()`.
* New function `set_col_names()`.
* New function `distinct_values()`.
* Added argument `.key` to `rowwise_table()`.
* Additional arguments passed to `Dictionary$get()` and `Dictionary$mget()`
  must now be named.

# mlr3misc 0.1.1

* New function `encapsulate()` to call functions while recording a log.
* `invoke()`: New arguments `.opts` and `.seed` to temporarily set options or
  random seeds, respectively.
* Fixed warnings about partial argument matching.

# mlr3misc 0.1.0

* Initial release.
