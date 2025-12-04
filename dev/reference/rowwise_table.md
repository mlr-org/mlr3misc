# Row-Wise Constructor for 'data.table'

Similar to the [tibble](https://CRAN.R-project.org/package=tibble)
function `tribble()`, this function allows to construct tabular data in
a row-wise fashion.

The first arguments passed as formula will be interpreted as column
names. The remaining arguments will be put into the resulting table.

## Usage

``` r
rowwise_table(..., .key = NULL)
```

## Arguments

- ...:

  (`any`)  
  Arguments: Column names in first rows as formulas (with empty left
  hand side), then the tabular data in the following rows.

- .key:

  (`character(1)`)  
  If not `NULL`, set the key via
  [`data.table::setkeyv()`](https://rdatatable.gitlab.io/data.table/reference/setkey.html)
  after constructing the table.

## Value

[`data.table::data.table()`](https://rdatatable.gitlab.io/data.table/reference/data.table.html).

## Examples

``` r
rowwise_table(
  ~a, ~b,
  1, "a",
  2, "b"
)
#>        a      b
#>    <num> <char>
#> 1:     1      a
#> 2:     2      b
```
