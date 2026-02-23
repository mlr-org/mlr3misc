# Unnest List Columns

Transforms list columns to separate columns, possibly by reference. The
original columns are removed from the returned table. All non-atomic
objects in the list columns are expanded to new list columns.

## Usage

``` r
unnest(x, cols, prefix = NULL)
```

## Arguments

- x:

  ([`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html))  
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  with columns to unnest.

- cols:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Column names of list columns to operate on.

- prefix:

  (`logical(1)` \| `character(1)`)  
  String to prefix the new column names with. Use `"{col}"` (without the
  quotes) as placeholder for the original column name.

## Value

([`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)).

## Examples

``` r
x = data.table::data.table(
  id = 1:2,
  value = list(list(a = 1, b = 2), list(a = 2, b = 2))
)
print(x)
#>       id     value
#>    <int>    <list>
#> 1:     1 <list[2]>
#> 2:     2 <list[2]>
unnest(data.table::copy(x), "value")
#>       id     a     b
#>    <int> <num> <num>
#> 1:     1     1     2
#> 2:     2     2     2
unnest(data.table::copy(x), "value", prefix = "{col}.")
#>       id value.a value.b
#>    <int>   <num>   <num>
#> 1:     1       1       2
#> 2:     2       2       2
```
