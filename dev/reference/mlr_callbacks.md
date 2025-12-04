# Dictionary of Callbacks

A simple
[Dictionary](https://mlr3misc.mlr-org.com/dev/reference/Dictionary.md)
storing objects of class
[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md). Each
callback has an associated help page, see `mlr_callbacks_[id]`.

This dictionary can get populated with additional callbacks by add-on
packages. As a convention, the key should start with the name of the
package, i.e. `package.callback`.

For a more convenient way to retrieve and construct learners, see
[`clbk()`](https://mlr3misc.mlr-org.com/dev/reference/clbk.md)/[`clbks()`](https://mlr3misc.mlr-org.com/dev/reference/clbk.md).

## Usage

``` r
mlr_callbacks
```

## Format

An object of class `DictionaryCallbacks` (inherits from `Dictionary`,
`R6`) of length 12.
