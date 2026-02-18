# Functions for Formatted Output and Conditions

`catf()`, `messagef()`, `warningf()` and `stopf()` are wrappers around
[`base::cat()`](https://rdrr.io/r/base/cat.html),
[`base::message()`](https://rdrr.io/r/base/message.html),
[`base::warning()`](https://rdrr.io/r/base/warning.html) and
[`base::stop()`](https://rdrr.io/r/base/stop.html), respectively.

## Usage

``` r
catf(msg, ..., file = "", wrap = FALSE)

messagef(msg, ..., wrap = FALSE, class = NULL)

warningf(msg, ..., wrap = FALSE, class = NULL)

stopf(msg, ..., wrap = FALSE, class = NULL)
```

## Arguments

- msg:

  (`character(1)`)  
  Format string passed to
  [`base::sprintf()`](https://rdrr.io/r/base/sprintf.html).

- ...:

  (`any`)  
  Arguments passed down to
  [`base::sprintf()`](https://rdrr.io/r/base/sprintf.html).

- file:

  (`character(1)`)  
  Passed to [`base::cat()`](https://rdrr.io/r/base/cat.html).

- wrap:

  (`integer(1)` \| `logical(1)`)  
  If set to a positive integer,
  [`base::strwrap()`](https://rdrr.io/r/base/strwrap.html) is used to
  wrap the string to the provided width. If set to `TRUE`, the width
  defaults to `0.9 * getOption("width")`. If set to `FALSE`, wrapping is
  disabled (default). If wrapping is enabled, all whitespace characters
  (`[[:space:]]`) are converted to spaces, and consecutive spaces are
  converted to a single space.

- class:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Class of the condition (for errors and warnings).

## Details

For leanified R6 classes, the call included in the condition is the
method call and not the call into the leanified method.

## Errors and Warnings

Errors and warnings get the classes `mlr3{error, warning}` and also
inherit from `simple{Error, Warning}`. It is possible to give errors and
warnings their own class via the `class` argument. Doing this, allows to
suppress selective conditions via calling handlers, see e.g.
[`globalCallingHandlers`](https://rdrr.io/r/base/conditions.html).

When a function throws such a condition that the user might want to
disable, a section *Errors and Warnings* should be included in the
function documentation, describing the condition and its class.

## Examples

``` r
messagef("
  This is a rather long %s
  on multiple lines
  which will get wrapped.
", "string", wrap = 15)
#> This is a
#> rather long
#> string on
#> multiple lines
#> which will get
#> wrapped.
```
