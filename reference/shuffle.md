# Safe Version of Sample

A version of [`sample()`](https://rdrr.io/r/base/sample.html) which does
not treat positive scalar integer `x` differently. See example.

## Usage

``` r
shuffle(x, n = length(x), ...)
```

## Arguments

- x:

  ([`vector()`](https://rdrr.io/r/base/vector.html))  
  Vector to sample elements from.

- n:

  ([`integer()`](https://rdrr.io/r/base/integer.html))  
  Number of elements to sample.

- ...:

  (`any`)  
  Arguments passed down to
  [`base::sample.int()`](https://rdrr.io/r/base/sample.html).

## Examples

``` r
x = 2:3
sample(x)
#> [1] 2 3
shuffle(x)
#> [1] 2 3

x = 3
sample(x)
#> [1] 1 3 2
shuffle(x)
#> [1] 3
```
