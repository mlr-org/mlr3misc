# Bind Columns by Reference

Performs [`base::cbind()`](https://rdrr.io/r/base/cbind.html) on
[data.tables](https://rdrr.io/pkg/data.table/man/data.table.html),
possibly by reference.

## Usage

``` r
rcbind(x, y)
```

## Arguments

- x:

  ([`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html))  
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  to add columns to.

- y:

  ([`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html))  
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  to take columns from.

## Value

([`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)):
Updated `x` .

## Examples

``` r
x = data.table::data.table(a = 1:3, b = 3:1)
y = data.table::data.table(c = runif(3))
rcbind(x, y)
#>        a     b         c
#>    <int> <int>     <num>
#> 1:     1     3 0.2580168
#> 2:     2     2 0.4785452
#> 3:     3     1 0.7663107
```
