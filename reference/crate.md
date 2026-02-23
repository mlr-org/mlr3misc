# Isolate a Function from its Environment

Put a function in a "lean" environment that does not carry unnecessary
baggage with it (e.g. references to datasets).

## Usage

``` r
crate(.fn, ..., .parent = topenv(parent.frame()), .compile = TRUE)
```

## Arguments

- .fn:

  (`function()`)  
  function to crate

- ...:

  (`any`)  
  The objects, which should be visible inside `.fn`.

- .parent:

  (`environment`)  
  Parent environment to look up names. Default to
  [`topenv()`](https://rdrr.io/r/base/ns-topenv.html).

- .compile:

  (`logical(1)`)  
  Whether to jit-compile the function. In case the function is already
  compiled. If the input function `.fn` is compiled, this has no effect,
  and the output function will always be compiled.

## Examples

``` r
meta_f = function(z) {
  x = 1
  y = 2
  crate(function() {
    c(x, y, z)
  }, x)
}
x = 100
y = 200
z = 300
f = meta_f(1)
f()
#> Error in f(): object 'y' not found
```
