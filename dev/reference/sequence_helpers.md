# Sequence Construction Helpers

`seq_row()` creates a sequence along the number of rows of `x`,
`seq_col()` a sequence along the number of columns of `x`. `seq_len0()`
and `seq_along0()` are the 0-based counterparts to
[`base::seq_len()`](https://rdrr.io/r/base/seq.html) and
[`base::seq_along()`](https://rdrr.io/r/base/seq.html).

## Usage

``` r
seq_row(x)

seq_col(x)

seq_len0(n)

seq_along0(x)
```

## Arguments

- x:

  (`any`)  
  Arbitrary object. Used to query its rows, cols or length.

- n:

  (`integer(1)`)  
  Length of the sequence.

## Examples

``` r
seq_len0(3)
#> [1] 0 1 2
```
