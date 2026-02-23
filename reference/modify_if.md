# Selectively Modify Elements of a Vector

Modifies elements of a vector selectively, similar to the functions in
[purrr](https://CRAN.R-project.org/package=purrr).

`modify_if()` applies a predicate function `.p` to all elements of `.x`
and applies `.f` to those elements of `.x` where `.p` evaluates to
`TRUE`.

`modify_at()` applies `.f` to those elements of `.x` selected via `.at`.

## Usage

``` r
modify_if(.x, .p, .f, ...)

modify_at(.x, .at, .f, ...)
```

## Arguments

- .x:

  ([`vector()`](https://rdrr.io/r/base/vector.html)).

- .p:

  (`function()`)  
  Predicate function.

- .f:

  (`function()`)  
  Function to apply on `.x`.

- ...:

  (`any`)  
  Additional arguments passed to `.f`.

- .at:

  (([`integer()`](https://rdrr.io/r/base/integer.html) \|
  [`character()`](https://rdrr.io/r/base/character.html)))  
  Index vector to select elements from `.x`.

## Examples

``` r
x = modify_if(iris, is.factor, as.character)
str(x)
#> 'data.frame':    150 obs. of  5 variables:
#>  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#>  $ Species     : chr  "setosa" "setosa" "setosa" "setosa" ...

x = modify_at(iris, 5, as.character)
x = modify_at(iris, "Sepal.Length", sqrt)
str(x)
#> 'data.frame':    150 obs. of  5 variables:
#>  $ Sepal.Length: num  2.26 2.21 2.17 2.14 2.24 ...
#>  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#>  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
```
