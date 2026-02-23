# Create Formulas

Given the left-hand side and right-hand side as character vectors,
generates a new
[`stats::formula()`](https://rdrr.io/r/stats/formula.html).

## Usage

``` r
formulate(lhs = character(), rhs = character(), env = NULL, quote = "right")
```

## Arguments

- lhs:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Left-hand side of formula. Multiple elements will be collapsed with
  `" + "`.

- rhs:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Right-hand side of formula. Multiple elements will be collapsed with
  `" + "`.

- env:

  ([`environment()`](https://rdrr.io/r/base/environment.html))  
  Environment for the new formula. Defaults to `NULL`.

- quote:

  (`character(1)`)  
  Which side of the formula to quote? Subset of `("left", "right")`,
  defaulting to `"right"`.

## Value

[`stats::formula()`](https://rdrr.io/r/stats/formula.html).

## Examples

``` r
formulate("Species", c("Sepal.Length", "Sepal.Width"))
#> Species ~ Sepal.Length + Sepal.Width
#> NULL
formulate(rhs = c("Sepal.Length", "Sepal.Width"))
#> ~Sepal.Length + Sepal.Width
#> NULL
```
