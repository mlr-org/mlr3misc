# Changelog

## mlr3misc (development version)

## mlr3misc 0.19.0

CRAN release: 2025-09-12

- feat: Added various new functions for improved error handling.
- feat:
  [`encapsulate()`](https://mlr3misc.mlr-org.com/dev/reference/encapsulate.md)
  now returns the specific condition objects along the logs, allowing
  for improved error handling on the caller side.

## mlr3misc 0.18.0

CRAN release: 2025-05-26

- feat: Added `"mirai"` as encapsulation method to
  [`encapsulate()`](https://mlr3misc.mlr-org.com/dev/reference/encapsulate.md).

## mlr3misc 0.17.0

CRAN release: 2025-05-12

- feat:
  [`as_callbacks()`](https://mlr3misc.mlr-org.com/dev/reference/as_callback.md)
  returns a list named by the callback ids now.
- feat: Added logical operators `%check&&%` and `%check||%` for
  `check_*`-functions from `checkmate` (moved here from
  `mlr3pipelines`).
- feat: Added helper
  [`cat_cli()`](https://mlr3misc.mlr-org.com/dev/reference/cat_cli.md).
- fix: Default `dicts_suggest = NULL` for `dictionary_get_item()` and
  `dictionary_retrieve_item()` for backward compatibility.
- fix: Wrong assert in `dictionary_sugar_inc_get`.
- feat: Functions
  [`warningf()`](https://mlr3misc.mlr-org.com/dev/reference/printf.md)
  and [`stopf()`](https://mlr3misc.mlr-org.com/dev/reference/printf.md)
  now have a `class` argument and also add the additional class
  `mlr3warning` and `mlr3error`, respectively. The condition object now
  also includes the call.

## mlr3misc 0.16.0

CRAN release: 2024-11-28

- fix: [`crate()`](https://mlr3misc.mlr-org.com/dev/reference/crate.md)
  is using the correct ‘topenv’ environment now.
- BREAKING CHANGE: Remove the unused ‘safe’ variants of dictionary
  getters.
- feat:
  [`dictionary_sugar_get()`](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md)
  and corresponding functions now take a list of dictionaries as
  optional argument `.dicts_suggest` to look for suggestions if `.key`
  is not part of the dictionary.

## mlr3misc 0.15.1

CRAN release: 2024-06-24

- refactor: Update
  [`as_callback()`](https://mlr3misc.mlr-org.com/dev/reference/as_callback.md)
  functions.

## mlr3misc 0.15.0

CRAN release: 2024-04-10

- Feat: Added `strip_srcrefs` S3 generic, which removes source
  references from objects
- The RNG state is now copied to the callr session when using
  [`encapsulate()`](https://mlr3misc.mlr-org.com/dev/reference/encapsulate.md).

## mlr3misc 0.14.0

CRAN release: 2024-02-01

- Added argument `.compile` to function
  [`crate()`](https://mlr3misc.mlr-org.com/dev/reference/crate.md)
  because R disables byte-code compilation of functions when changing
  their enclosing environment
- Added the possibility to include prototype arguments when adding
  elements to a `Dictionary`
- Removed unused argument `required_args` from `Dictionary` class
- Disable leanification when `ROXYGEN_PKG` environment variable is set

## mlr3misc 0.13.0

CRAN release: 2023-09-20

- Updated default environment for
  [`crate()`](https://mlr3misc.mlr-org.com/dev/reference/crate.md) to
  [`topenv()`](https://rdrr.io/r/base/ns-topenv.html)
  ([\#86](https://github.com/mlr-org/mlr3misc/issues/86)).
- Added safe methods for dictionary retrieval
  ([\#83](https://github.com/mlr-org/mlr3misc/issues/83))
- fix: Fixed an important bug that caused serialized objects to be
  overly large when installing mlr3 with `--with-keep.source`
  ([\#88](https://github.com/mlr-org/mlr3misc/issues/88))

## mlr3misc 0.12.0

CRAN release: 2023-05-12

- Added new encapsulation mode `"try"`.
- Added functions `dictionary_sugar_inc_get` and
  `dictionary_sugar_inc_mget` which allow to conveniently add suffixes
  to dictionary ids when retrieving objects.

## mlr3misc 0.11.0

CRAN release: 2022-09-22

- Added initial support for a callback mechanism, see
  [`as_callback()`](https://mlr3misc.mlr-org.com/dev/reference/as_callback.md).
- Added helper
  [`catn()`](https://mlr3misc.mlr-org.com/dev/reference/catn.md).
- Added helper
  [`set_params()`](https://mlr3misc.mlr-org.com/dev/reference/set_params.md).
- Added assign method for
  [`get_private()`](https://mlr3misc.mlr-org.com/dev/reference/get_private.md).
- Elements of a dictionary via
  [`dictionary_sugar_mget()`](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md)
  are now returned named.

## mlr3misc 0.10.0

CRAN release: 2022-01-11

- Added helper
  [`get_private()`](https://mlr3misc.mlr-org.com/dev/reference/get_private.md).
- Added helper
  [`map_br()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md)
  and
  [`map_bc()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md).
- Added helper
  [`recycle_vectors()`](https://mlr3misc.mlr-org.com/dev/reference/recycle_vectors.md).
- Added helpers
  [`walk()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md),
  [`iwalk()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md)
  and
  [`pwalk()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md).

## mlr3misc 0.9.5

CRAN release: 2021-11-16

- Added helper
  [`deframe()`](https://mlr3misc.mlr-org.com/dev/reference/enframe.md).

## mlr3misc 0.9.4

CRAN release: 2021-09-08

- Added helper
  [`capitalize()`](https://mlr3misc.mlr-org.com/dev/reference/capitalize.md).
- Added helper
  [`to_decimal()`](https://mlr3misc.mlr-org.com/dev/reference/to_decimal.md).
- Fixed cleanup in
  [`register_namespace_callback()`](https://mlr3misc.mlr-org.com/dev/reference/register_namespace_callback.md).

## mlr3misc 0.9.3

CRAN release: 2021-07-14

- New (internal) helper functions:
  [`calculate_hash()`](https://mlr3misc.mlr-org.com/dev/reference/calculate_hash.md)
  and
  [`assert_ro_binding()`](https://mlr3misc.mlr-org.com/dev/reference/assert_ro_binding.md)

## mlr3misc 0.9.2

CRAN release: 2021-06-29

- R6 objects retrieved from the dictionary are now properly cloned.

## mlr3misc 0.9.1

CRAN release: 2021-04-28

- Fixed compilation for R versions older than 3.5.0
  ([\#59](https://github.com/mlr-org/mlr3misc/issues/59)).

## mlr3misc 0.9.0

CRAN release: 2021-04-12

- Changed return type of
  [`reorder_vector()`](https://mlr3misc.mlr-org.com/dev/reference/reorder_vector.md).
- Added assertions in
  [`pmap()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md)
  to avoid a segfault
  ([\#56](https://github.com/mlr-org/mlr3misc/issues/56)).
- Added
  [`count_missing()`](https://mlr3misc.mlr-org.com/dev/reference/count_missing.md).

## mlr3misc 0.8.0

CRAN release: 2021-03-19

- New function
  [`reorder_vector()`](https://mlr3misc.mlr-org.com/dev/reference/reorder_vector.md).
- [`formulate()`](https://mlr3misc.mlr-org.com/dev/reference/formulate.md)
  can now quote all terms, defaulting to quote all terms on the right
  hand side.

## mlr3misc 0.7.0

CRAN release: 2021-01-05

- Make more map functions work nicely with data frames and data tables.
- [`formulate()`](https://mlr3misc.mlr-org.com/dev/reference/formulate.md)
  now supports multiple LHS terms.
- Added
  [`format_bib()`](https://mlr3misc.mlr-org.com/dev/reference/format_bib.md)
  and
  [`cite_bib()`](https://mlr3misc.mlr-org.com/dev/reference/format_bib.md)
  helpers for working with bibentries and roxygen2.

## mlr3misc 0.6.0

CRAN release: 2020-11-17

- New argument `.timeout` for
  [`invoke()`](https://mlr3misc.mlr-org.com/dev/reference/invoke.md).
- New argument `.timeout` for
  [`encapsulate()`](https://mlr3misc.mlr-org.com/dev/reference/encapsulate.md).
- Removed
  [`cite_bib()`](https://mlr3misc.mlr-org.com/dev/reference/format_bib.md)
  and Rd macro `\cite{}` and removed orphaned package `bibtex` from
  suggests.
- New argument `quietly` for
  [`require_namespaces()`](https://mlr3misc.mlr-org.com/dev/reference/require_namespaces.md).
- New function
  [`crate()`](https://mlr3misc.mlr-org.com/dev/reference/crate.md) to
  cleanly separate a function from its environment.
- New function
  [`register_namespace_callback()`](https://mlr3misc.mlr-org.com/dev/reference/register_namespace_callback.md).

## mlr3misc 0.5.0

CRAN release: 2020-08-13

- Added
  [`compose()`](https://mlr3misc.mlr-org.com/dev/reference/compose.md)
  function for function composition.
- Added method
  [`leanify_package()`](https://mlr3misc.mlr-org.com/dev/reference/leanify_r6.md)
  that shrinks the size of serialized R6 objects.

## mlr3misc 0.4.0

CRAN release: 2020-07-17

- Added helper functions to assist in generating Rd documentation for
  ‘mlr3’ objects.

## mlr3misc 0.3.0

CRAN release: 2020-06-03

- Introduced a placeholder for column name prefixes in
  [`unnest()`](https://mlr3misc.mlr-org.com/dev/reference/unnest.md).

## mlr3misc 0.2.0

CRAN release: 2020-04-15

- Fixed an issue with
  [`rcbind()`](https://mlr3misc.mlr-org.com/dev/reference/rcbind.md) for
  columns of `x` named `y`
  ([\#42](https://github.com/mlr-org/mlr3misc/issues/42)).
- Fixed broken [`on.exit()`](https://rdrr.io/r/base/on.exit.html) in
  [`invoke()`](https://mlr3misc.mlr-org.com/dev/reference/invoke.md) if
  both a seed and a list of options were provided.

## mlr3misc 0.1.8

CRAN release: 2020-02-21

- New function
  [`check_packages_installed()`](https://mlr3misc.mlr-org.com/dev/reference/check_packages_installed.md).
- New function
  [`open_help()`](https://mlr3misc.mlr-org.com/dev/reference/open_help.md).

## mlr3misc 0.1.7

CRAN release: 2020-01-28

- [`map_dtr()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md),
  [`imap_dtr()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md)
  and
  [`pmap_dtr()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md)
  now pass `.idcol` down to argument `idcol` of
  [`data.table::rbindlist()`](https://rdrr.io/pkg/data.table/man/rbindlist.html).
- [`cite_bib()`](https://mlr3misc.mlr-org.com/dev/reference/format_bib.md)
  can now handle packages with multiple citation entries.
- Added argument `wrap` to
  [`catf()`](https://mlr3misc.mlr-org.com/dev/reference/printf.md),
  [`messagef()`](https://mlr3misc.mlr-org.com/dev/reference/printf.md),
  [`warningf()`](https://mlr3misc.mlr-org.com/dev/reference/printf.md)
  and [`stopf()`](https://mlr3misc.mlr-org.com/dev/reference/printf.md)
  to wrap the respective messages to a customizable width.
- Added
  [`with_package()`](https://mlr3misc.mlr-org.com/dev/reference/with_package.md)
  helper, similar to the one in package `withr`.

## mlr3misc 0.1.6

CRAN release: 2019-12-12

- [`cite_bib()`](https://mlr3misc.mlr-org.com/dev/reference/format_bib.md)
  or Rd macro `\cite{}` can now return the citation information of the
  package if key is set to `"pkg::citation"`.
- Updated dictionary helpers.

## mlr3misc 0.1.5

CRAN release: 2019-09-28

- Fixed error in C code discovered by UBSAN checks on CRAN.
- Added
  [`dictionary_sugar_mget()`](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md).
- Renamed
  [`dictionary_sugar()`](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md)
  to
  [`dictionary_sugar_get()`](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md).
- Added function
  [`cite_bib()`](https://mlr3misc.mlr-org.com/dev/reference/format_bib.md)
  and Rd macro `\cite{}` to insert entries from bibtex files into
  roxygen documentation.
- [`unnest()`](https://mlr3misc.mlr-org.com/dev/reference/unnest.md) now
  creates list columns for non atomic list elements.

## mlr3misc 0.1.4

CRAN release: 2019-09-17

- Added argument `na_rm` to
  [`which_max()`](https://mlr3misc.mlr-org.com/dev/reference/which_min.md)
  and
  [`which_min()`](https://mlr3misc.mlr-org.com/dev/reference/which_min.md).
- Fixed a bug in
  [`as_short_string()`](https://mlr3misc.mlr-org.com/dev/reference/as_short_string.md)
  for empty atomic vectors.

## mlr3misc 0.1.3

CRAN release: 2019-08-22

- New function
  [`detect()`](https://mlr3misc.mlr-org.com/dev/reference/compat-map.md).
- New function
  [`dictionary_sugar()`](https://mlr3misc.mlr-org.com/dev/reference/dictionary_sugar_get.md).
- It is now asserted that the return value of `Dictionary$get()` is an
  R6 object.
- Fix some assertions in `Dictionary`

## mlr3misc 0.1.2

CRAN release: 2019-08-07

- New function
  [`named_vector()`](https://mlr3misc.mlr-org.com/dev/reference/named_vector.md).
- New function
  [`keep_in_bounds()`](https://mlr3misc.mlr-org.com/dev/reference/keep_in_bounds.md).
- New function
  [`set_col_names()`](https://mlr3misc.mlr-org.com/dev/reference/set_names.md).
- New function
  [`distinct_values()`](https://mlr3misc.mlr-org.com/dev/reference/distinct_values.md).
- Added argument `.key` to
  [`rowwise_table()`](https://mlr3misc.mlr-org.com/dev/reference/rowwise_table.md).
- Additional arguments passed to `Dictionary$get()` and
  `Dictionary$mget()` must now be named.

## mlr3misc 0.1.1

CRAN release: 2019-07-23

- New function
  [`encapsulate()`](https://mlr3misc.mlr-org.com/dev/reference/encapsulate.md)
  to call functions while recording a log.
- [`invoke()`](https://mlr3misc.mlr-org.com/dev/reference/invoke.md):
  New arguments `.opts` and `.seed` to temporarily set options or random
  seeds, respectively.
- Fixed warnings about partial argument matching.

## mlr3misc 0.1.0

CRAN release: 2019-07-10

- Initial release.
