# Set Names

Sets the names (or colnames) of `x` to `nm`. If `nm` is a function, it
is used to transform the already existing names of `x`.

## Usage

``` r
set_names(x, nm = x, ...)

set_col_names(x, nm, ...)
```

## Arguments

- x:

  (`any`.)  
  Object to set names for.

- nm:

  ([`character()`](https://rdrr.io/r/base/character.html) \|
  `function()`)  
  New names, or a function which transforms already existing names.

- ...:

  (`any`)  
  Passed down to `nm` if `nm` is a function.

## Value

`x` with updated names.

## Examples

``` r
x = letters[1:3]

# name x with itself:
x = set_names(x)
print(x)
#>   a   b   c 
#> "a" "b" "c" 

# convert names to uppercase
x = set_names(x, toupper)
print(x)
#>   A   B   C 
#> "a" "b" "c" 
```
