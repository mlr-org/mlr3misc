# Reorder Vector According to Second Vector

Returns an integer vector to order vector `x` according to vector `y`.

## Usage

``` r
reorder_vector(x, y, na_last = NA)
```

## Arguments

- x:

  (`vector())`.

- y:

  ([`vector()`](https://rdrr.io/r/base/vector.html)).

- na_last:

  (`logical(1)`)  
  What to do with values in `x` which are not in `y`?

  - `NA`: Extra values are removed.

  - `FALSE`: Extra values are moved to the beginning of the new vector.

  - `TRUE`: Extra values are moved to the end of the new vector.

## Value

([`integer()`](https://rdrr.io/r/base/integer.html)).

## Examples

``` r
# x subset of y
x = c("b", "a", "c", "d")
y = letters
x[reorder_vector(x, y)]
#> [1] "a" "b" "c" "d"

# y subset of x
y = letters[1:3]
x[reorder_vector(x, y)]
#> [1] "a" "b" "c"
x[reorder_vector(x, y, na_last = TRUE)]
#> [1] "a" "b" "c" "d"
x[reorder_vector(x, y, na_last = FALSE)]
#> [1] "d" "a" "b" "c"
```
