# Remove All Elements Out Of Bounds

Filters vector `x` to only keep elements which are in bounds
`[lower, upper]`. This is equivalent to the following, but tries to
avoid unnecessary allocations:

     x[!is.na(x) & x >= lower & x <= upper]

Currently only works for integer `x`.

## Usage

``` r
keep_in_bounds(x, lower, upper)
```

## Arguments

- x:

  ([`integer()`](https://rdrr.io/r/base/integer.html))  
  Vector to filter.

- lower:

  (`integer(1)`)  
  Lower bound.

- upper:

  (`integer(1)`)  
  Upper bound.

## Value

(integer()) with only values in `[lower, upper]`.

## Examples

``` r
keep_in_bounds(sample(20), 5, 10)
#> [1]  5 10  9  6  8  7
```
