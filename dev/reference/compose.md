# Composition of Functions

Composes two or more functions into a single function. The returned
function calls all provided functions in reverse order: The return value
of the last function servers as input for the next to last function, and
so on.

## Usage

``` r
compose(...)
```

## Arguments

- ...:

  (`functions`)  
  Functions to compose.

## Value

(`function()`) which calls the functions provided via `...` in reverse
order.

## Examples

``` r
f = compose(function(x) x + 1, function(x) x / 2)
f(10)
#> [1] 6
```
