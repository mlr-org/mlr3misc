# Calculate a Hash for Multiple Objects

Calls
[`digest::digest()`](https://eddelbuettel.github.io/digest/man/digest.html)
using the 'xxhash64' algorithm after applying
[`hash_input`](https://mlr3misc.mlr-org.com/dev/reference/hash_input.md)
to each object. To customize the hashing behaviour, you can overwrite
[`hash_input`](https://mlr3misc.mlr-org.com/dev/reference/hash_input.md)
for specific classes. For `data.table` objects,
[`hash_input`](https://mlr3misc.mlr-org.com/dev/reference/hash_input.md)
is applied to all columns, so you can overwrite
[`hash_input`](https://mlr3misc.mlr-org.com/dev/reference/hash_input.md)
for columns of a specific class. Objects that don't have a specific
method are hashed as is.

## Usage

``` r
calculate_hash(...)
```

## Arguments

- ...:

  (`any`)  
  Objects to hash.

## Value

(`character(1)`).

## Examples

``` r
calculate_hash(iris, 1, "a")
#> [1] "9dec48c68dae0533"
```
