# Replace Elements of Vectors with New Values

Replaces all values in `x` which match `old` with values in `new`.
Values are matched with
[`base::match()`](https://rdrr.io/r/base/match.html).

## Usage

``` r
map_values(x, old, new)
```

## Arguments

- x:

  (`vector())`.

- old:

  ([`vector()`](https://rdrr.io/r/base/vector.html))  
  Vector with values to replace.

- new:

  ([`vector()`](https://rdrr.io/r/base/vector.html))  
  Values to replace with. Will be forced to the same length as `old`
  with [`base::rep_len()`](https://rdrr.io/r/base/rep.html).

## Value

([`vector()`](https://rdrr.io/r/base/vector.html)) of the same length as
`x`.

## Examples

``` r
x = letters[1:5]

# replace all "b" with "_b_", and all "c" with "_c_"
old = c("b", "c")
new = c("_b_", "_c_")
map_values(x, old, new)
#> [1] "a"   "_b_" "_c_" "d"   "e"  
```
