# Retrieve a Single Data Set

Loads a data set with name `id` from package `package` and returns it.
If the package is not installed, an error with condition
"packageNotFoundError" is raised. The name of the missing packages is
stored in the condition as `packages`.

## Usage

``` r
load_dataset(id, package, keep_rownames = FALSE)
```

## Arguments

- id:

  (`character(1)`)  
  Name of the data set.

- package:

  (`character(1)`)  
  Package to load the data set from.

- keep_rownames:

  (`logical(1)`)  
  Keep possible row names (default: `FALSE`).

## Examples

``` r
head(load_dataset("iris", "datasets"))
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
```
