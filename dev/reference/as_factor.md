# Convert to Factor

Converts a vector to a [`factor()`](https://rdrr.io/r/base/factor.html)
and ensures that levels are in the order of the provided levels.

## Usage

``` r
as_factor(x, levels, ordered = is.ordered(x))
```

## Arguments

- x:

  (atomic [`vector()`](https://rdrr.io/r/base/vector.html))  
  Vector to convert to factor.

- levels:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Levels of the new factor.

- ordered:

  (`logical(1)`)  
  If `TRUE`, create an ordered factor.

## Value

([`factor()`](https://rdrr.io/r/base/factor.html)).

## Examples

``` r
x = factor(c("a", "b"))
y = factor(c("a", "b"), levels = c("b", "a"))

# x with the level order of y
as_factor(x, levels(y))
#> [1] a b
#> Levels: b a

# y with the level order of x
as_factor(y, levels(x))
#> [1] a b
#> Levels: a b
```
