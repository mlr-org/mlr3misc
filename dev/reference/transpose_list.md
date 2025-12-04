# Transpose lists of lists

Transposes a list of list, and turns it inside out, similar to the
function
[`transpose()`](https://rdatatable.gitlab.io/data.table/reference/transpose.html)
in package [purrr](https://CRAN.R-project.org/package=purrr).

## Usage

``` r
transpose_list(.l)
```

## Arguments

- .l:

  ([`list()`](https://rdrr.io/r/base/list.html) of
  [`list()`](https://rdrr.io/r/base/list.html)).

## Value

[`list()`](https://rdrr.io/r/base/list.html).

## Examples

``` r
x = list(list(a = 2, b = 3), list(a = 5, b = 10))
str(x)
#> List of 2
#>  $ :List of 2
#>   ..$ a: num 2
#>   ..$ b: num 3
#>  $ :List of 2
#>   ..$ a: num 5
#>   ..$ b: num 10
str(transpose_list(x))
#> List of 2
#>  $ a:List of 2
#>   ..$ : num 2
#>   ..$ : num 5
#>  $ b:List of 2
#>   ..$ : num 3
#>   ..$ : num 10

# list of data frame rows:
transpose_list(iris[1:2, ])
#> [[1]]
#> [[1]]$Sepal.Length
#> [1] 5.1
#> 
#> [[1]]$Sepal.Width
#> [1] 3.5
#> 
#> [[1]]$Petal.Length
#> [1] 1.4
#> 
#> [[1]]$Petal.Width
#> [1] 0.2
#> 
#> [[1]]$Species
#> [1] setosa
#> Levels: setosa versicolor virginica
#> 
#> 
#> [[2]]
#> [[2]]$Sepal.Length
#> [1] 4.9
#> 
#> [[2]]$Sepal.Width
#> [1] 3
#> 
#> [[2]]$Petal.Length
#> [1] 1.4
#> 
#> [[2]]$Petal.Width
#> [1] 0.2
#> 
#> [[2]]$Species
#> [1] setosa
#> Levels: setosa versicolor virginica
#> 
#> 
```
