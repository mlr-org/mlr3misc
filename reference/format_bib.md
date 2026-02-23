# Format Bibentries in Roxygen

Operates on a named list of
[`bibentry()`](https://rdrr.io/r/utils/bibentry.html) entries and
formats them nicely for documentation with
[roxygen2](https://CRAN.R-project.org/package=roxygen2).

- `format_bib()` is intended to be called in the `@references` section
  and prints the complete entry using `toRd()`.

- `cite_bib()` returns the family name of the first author (if
  available, falling back to the complete author name if not applicable)
  and the year in format `"[LastName] (YYYY)"`.

## Usage

``` r
format_bib(..., bibentries = NULL, envir = parent.frame())

cite_bib(..., bibentries = NULL, envir = parent.frame())
```

## Arguments

- ...:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  One or more names of bibentries.

- bibentries:

  (named [`list()`](https://rdrr.io/r/base/list.html))  
  Named list of bibentries.

- envir:

  (`environment`)  
  Environment to lookup `bibentries` if not provided.

## Value

(`character(1)`).

## Examples

``` r
bibentries = list(checkmate = citation("checkmate"), R = citation())
format_bib("checkmate")
#> [1] "Lang M (2017).\n\\dQuote{checkmate: Fast Argument Checks for Defensive R Programming.}\n\\emph{The R Journal}, \\bold{9}(1), 437--445.\n\\doi{10.32614/RJ-2017-028}."
format_bib("R")
#> [1] "R Core Team (2025).\n\\emph{R: A Language and Environment for Statistical Computing}.\nR Foundation for Statistical Computing, Vienna, Austria.\n\\url{https://www.R-project.org/}."
cite_bib("checkmate")
#> [1] "Lang (2017)"
cite_bib("checkmate", "R")
#> [1] "Lang (2017) and R Core Team (2025)"
```
