# Convert a Named Vector into a data.table and Vice Versa

`enframe()` returns a
[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
with two columns: The names of `x` (or `seq_along(x)` if unnamed) and
the values of `x`.

`deframe()` converts a two-column data.frame to a named vector. If the
data.frame only has a single column, an unnamed vector is returned.

## Usage

``` r
enframe(x, name = "name", value = "value")

deframe(x)
```

## Arguments

- x:

  ([`vector()`](https://rdrr.io/r/base/vector.html) (`enframe()`) or
  [`data.frame()`](https://rdrr.io/r/base/data.frame.html)
  (`deframe()`))  
  Vector to convert to a
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html).

- name:

  (`character(1)`)  
  Name for the first column with names.

- value:

  (`character(1)`)  
  Name for the second column with values.

## Value

[`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
or named `vector`.

## Examples

``` r
x = 1:3
enframe(x)
#>     name value
#>    <int> <int>
#> 1:     1     1
#> 2:     2     2
#> 3:     3     3

x = set_names(1:3, letters[1:3])
enframe(x, value = "x_values")
#>      name x_values
#>    <char>    <int>
#> 1:      a        1
#> 2:      b        2
#> 3:      c        3
```
