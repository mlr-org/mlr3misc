# Insert or Remove Named Elements

Insert elements from `y` into `x` by name, or remove elements from `x`
by name. Works for vectors, lists, environments and data frames and data
tables. Objects with reference semantic
([`environment()`](https://rdrr.io/r/base/environment.html) and
[`data.table::data.table()`](https://rdatatable.gitlab.io/data.table/reference/data.table.html))
might be modified in-place.

## Usage

``` r
insert_named(x, y)

# S3 method for class '`NULL`'
insert_named(x, y)

# Default S3 method
insert_named(x, y)

# S3 method for class 'environment'
insert_named(x, y)

# S3 method for class 'data.frame'
insert_named(x, y)

# S3 method for class 'data.table'
insert_named(x, y)

remove_named(x, nn)

# S3 method for class 'environment'
remove_named(x, nn)

# S3 method for class 'data.frame'
remove_named(x, nn)

# S3 method for class 'data.table'
remove_named(x, nn)
```

## Arguments

- x:

  ([`vector()`](https://rdrr.io/r/base/vector.html) \|
  [`list()`](https://rdrr.io/r/base/list.html) \|
  [`environment()`](https://rdrr.io/r/base/environment.html) \|
  [`data.table::data.table()`](https://rdatatable.gitlab.io/data.table/reference/data.table.html))  
  Object to insert elements into, or remove elements from. Changes are
  by-reference for environments and data tables.

- y:

  ([`list()`](https://rdrr.io/r/base/list.html))  
  List of elements to insert into `x`.

- nn:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Character vector of elements to remove.

## Value

Modified object.

## Examples

``` r
x = list(a = 1, b = 2)
insert_named(x, list(b = 3, c = 4))
#> $a
#> [1] 1
#> 
#> $b
#> [1] 3
#> 
#> $c
#> [1] 4
#> 
remove_named(x, "b")
#> $a
#> [1] 1
#> 
```
