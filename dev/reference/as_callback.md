# Convert to a Callback

Convert object to a
[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md) or a
list of
[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md).

## Usage

``` r
as_callback(x, ...)

# S3 method for class 'Callback'
as_callback(x, clone = FALSE, ...)

as_callbacks(x, clone = FALSE, ...)

# S3 method for class '`NULL`'
as_callbacks(x, ...)

# S3 method for class 'list'
as_callbacks(x, clone = FALSE, ...)

# S3 method for class 'Callback'
as_callbacks(x, clone = FALSE, ...)
```

## Arguments

- x:

  (`any`)  
  Object to convert.

- ...:

  (`any`)  
  Additional arguments.

- clone:

  (`logical(1)`)  
  If `TRUE`, ensures that the returned object is not the same as the
  input `x`.

## Value

[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md).
