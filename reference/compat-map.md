# Apply Functions in the spirit of 'purrr'

`map`-like functions, similar to the ones implemented in
[purrr](https://CRAN.R-project.org/package=purrr):

- `map()` returns the results of `.f` applied to `.x` as list. If `.f`
  is not a function, `map` will call `[[` on all elements of `.x` using
  the value of `.f` as index.

- `imap()` applies `.f` to each value of `.x` (passed as first argument)
  and its name (passed as second argument). If `.x` does not have names,
  a sequence along `.x` is passed as second argument instead.

- `pmap()` expects `.x` to be a list of vectors of equal length, and
  then applies `.f` to the first element of each vector of `.x`, then
  the second element of `.x`, and so on.

- `map_if()` applies `.f` to each element of `.x` where the predicate
  `.p` evaluates to `TRUE`.

- `map_at()` applies `.f` to each element of `.x` referenced by `.at`.
  All other elements remain unchanged.

- `keep()` keeps those elements of `.x` where predicate `.p` evaluates
  to `TRUE`.

- `discard()` discards those elements of `.x` where predicate `.p`
  evaluates to `TRUE`.

- `compact()` discards elements of `.x` that are `NULL`.

- `every()` is `TRUE` if predicate `.p` evaluates to `TRUE` for each
  `.x`.

- `some()` is `TRUE` if predicate `.p` evaluates to `TRUE` for at least
  one `.x`.

- `detect()` returns the first element where predicate `.p` evaluates to
  `TRUE`.

- `walk()`, `iwalk()` and `pwalk()` are the counterparts to `map()`,
  `imap()` and `pmap()`, but just visit (or change by reference) the
  elements of `.x`. They return input `.x` invisibly.

Additionally, the functions `map()`, `imap()` and `pmap()` have
type-safe variants with the following suffixes:

- `*_lgl()` returns a `logical(length(.x))`.

- `*_int()` returns a `integer(length(.x))`.

- `*_dbl()` returns a `double(length(.x))`.

- `*_chr()` returns a `character(length(.x))`.

- `*_br()` returns an object where the results of `.f` are put together
  with [`base::rbind()`](https://rdrr.io/r/base/cbind.html).

- `*_bc()` returns an object where the results of `.f` are put together
  with [`base::cbind()`](https://rdrr.io/r/base/cbind.html).

- `*_dtr()` returns a
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  where the results of `.f` are put together in an
  [`base::rbind()`](https://rdrr.io/r/base/cbind.html) fashion.

- `*_dtc()` returns a
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)
  where the results of `.f` are put together in an
  [`base::cbind()`](https://rdrr.io/r/base/cbind.html) fashion.

## Usage

``` r
map(.x, .f, ...)

map_lgl(.x, .f, ...)

map_int(.x, .f, ...)

map_dbl(.x, .f, ...)

map_chr(.x, .f, ...)

map_br(.x, .f, ...)

map_bc(.x, .f, ...)

map_dtr(.x, .f, ..., .fill = FALSE, .idcol = NULL)

map_dtc(.x, .f, ...)

pmap(.x, .f, ...)

pmap_lgl(.x, .f, ...)

pmap_int(.x, .f, ...)

pmap_dbl(.x, .f, ...)

pmap_chr(.x, .f, ...)

pmap_dtr(.x, .f, ..., .fill = FALSE, .idcol = NULL)

pmap_dtc(.x, .f, ...)

imap(.x, .f, ...)

imap_lgl(.x, .f, ...)

imap_int(.x, .f, ...)

imap_dbl(.x, .f, ...)

imap_chr(.x, .f, ...)

imap_dtr(.x, .f, ..., .fill = FALSE, .idcol = NULL)

imap_dtc(.x, .f, ...)

keep(.x, .f, ...)

discard(.x, .p, ...)

compact(.x)

map_if(.x, .p, .f, ...)

# Default S3 method
map_if(.x, .p, .f, ...)

map_at(.x, .at, .f, ...)

every(.x, .p, ...)

some(.x, .p, ...)

detect(.x, .p, ...)

walk(.x, .f, ...)

iwalk(.x, .f, ...)

pwalk(.x, .f, ...)
```

## Arguments

- .x:

  ([`list()`](https://rdrr.io/r/base/list.html) \| atomic
  [`vector()`](https://rdrr.io/r/base/vector.html)).

- .f:

  (`function()` \|
  [`character()`](https://rdrr.io/r/base/character.html) \|
  [`integer()`](https://rdrr.io/r/base/integer.html))  
  Function to apply, or element to extract by name (if `.f` is
  [`character()`](https://rdrr.io/r/base/character.html)) or position
  (if `.f` is [`integer()`](https://rdrr.io/r/base/integer.html)).

- ...:

  (`any`)  
  Additional arguments passed down to `.f` or `.p`.

- .fill:

  (`logical(1)`)  
  Passed down to
  [`data.table::rbindlist()`](https://rdrr.io/pkg/data.table/man/rbindlist.html).

- .idcol:

  (`logical(1)`)  
  Passed down to
  [`data.table::rbindlist()`](https://rdrr.io/pkg/data.table/man/rbindlist.html).

- .p:

  (`function()` \| [`logical()`](https://rdrr.io/r/base/logical.html))  
  Predicate function.

- .at:

  ([`character()`](https://rdrr.io/r/base/character.html) \|
  [`integer()`](https://rdrr.io/r/base/integer.html) \|
  [`logical()`](https://rdrr.io/r/base/logical.html))  
  Index vector.
