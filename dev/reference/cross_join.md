# Cross-Join for data.table

A safe version of
[`data.table::CJ()`](https://rdrr.io/pkg/data.table/man/J.html) in case
a column is called `sorted` or `unique`.

## Usage

``` r
cross_join(dots, sorted = TRUE, unique = FALSE)
```

## Arguments

- dots:

  (named [`list()`](https://rdrr.io/r/base/list.html))  
  Vectors to cross-join.

- sorted:

  (`logical(1)`)  
  See [`data.table::CJ()`](https://rdrr.io/pkg/data.table/man/J.html).

- unique:

  (`logical(1)`)  
  See [`data.table::CJ()`](https://rdrr.io/pkg/data.table/man/J.html).

## Value

[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html).

## Examples

``` r
cross_join(dots = list(sorted = 1:3, b = letters[1:2]))
#> Key: <sorted, b>
#>    sorted      b
#>     <int> <char>
#> 1:      1      a
#> 2:      1      b
#> 3:      2      a
#> 4:      2      b
#> 5:      3      a
#> 6:      3      b
```
