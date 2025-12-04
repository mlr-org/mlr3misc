# Assertions for Callbacks

Assertions for
[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md)
class.

## Usage

``` r
assert_callback(callback, null_ok = FALSE)

assert_callbacks(callbacks)
```

## Arguments

- callback:

  ([Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md)).

- null_ok:

  (`logical(1)`)  
  If `TRUE`, `NULL` is allowed.

- callbacks:

  (list of
  [Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md)).

## Value

[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md) \|
List of
[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md)s.
