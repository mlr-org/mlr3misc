# Hash Input

Returns the part of an object to be used to calculate its hash.

## Usage

``` r
hash_input(x)

# S3 method for class '`function`'
hash_input(x)

# S3 method for class 'data.table'
hash_input(x)

# Default S3 method
hash_input(x)
```

## Arguments

- x:

  (`any`)  
  Object for which to retrieve the hash input.

## Methods (by class)

- `` hash_input(`function`) ``: The formals and the body are returned in
  a [`list()`](https://rdrr.io/r/base/list.html). This ensures that the
  bytecode or parent environment are not included. in the hash.

- `hash_input(data.table)`: The data.table is converted to a regular
  list and `hash_input()` is applied to all elements. The conversion to
  a list ensures that keys and indices are not included in the hash.

- `hash_input(default)`: Returns the object as is.
