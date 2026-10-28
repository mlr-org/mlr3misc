# Callback

Callbacks allow to customize the behavior of processes in mlr3 packages.
The following packages implement callbacks:

- `CallbackOptimization` in
  [bbotk](https://CRAN.R-project.org/package=bbotk).

- `CallbackTuning` in
  [mlr3tuning](https://CRAN.R-project.org/package=mlr3tuning).

- `CallbackTorch` in [`mlr3torch`](https://github.com/mlr-org/mlr3torch)

## Details

Callback is an abstract base class. A subclass inherits from Callback
and adds stages as public members. Names of stages should start with
`"on_"`. For each subclass a function should be implemented to create
the callback. For an example on how to implement such a function see
`callback_optimization()` in
[bbotk](https://CRAN.R-project.org/package=bbotk). Callbacks are
executed at stages using the function
[`call_back()`](https://mlr3misc.mlr-org.com/dev/reference/call_back.md).
A [Context](https://mlr3misc.mlr-org.com/dev/reference/Context.md)
defines which information can be accessed from the callback.

## Public fields

- `id`:

  (`character(1)`)  
  Identifier of the callback.

- `label`:

  (`character(1)`)  
  Label for this object. Can be used in tables, plot and text output
  instead of the ID.

- `man`:

  (`character(1)`)  
  String in the format `[pkg]::[topic]` pointing to a manual page for
  this object. Defaults to `NA`, but can be set by child classes.

- `state`:

  (named [`list()`](https://rdrr.io/r/base/list.html))  
  A callback can write data into the state.

## Methods

### Public methods

- [`Callback$new()`](#method-Callback-initialize)

- [`Callback$format()`](#method-Callback-format)

- [`Callback$print()`](#method-Callback-print)

- [`Callback$help()`](#method-Callback-help)

- [`Callback$call()`](#method-Callback-call)

- [`Callback$clone()`](#method-Callback-clone)

------------------------------------------------------------------------

### `Callback$new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    Callback$new(id, label = NA_character_, man = NA_character_)

#### Arguments

- `id`:

  (`character(1)`)  
  Identifier for the new instance.

- `label`:

  (`character(1)`)  
  Label for the new instance.

- `man`:

  (`character(1)`)  
  String in the format `[pkg]::[topic]` pointing to a manual page for
  this object. The referenced help package can be opened via method
  `$help()`.

------------------------------------------------------------------------

### `Callback$format()`

Helper for print outputs.

#### Usage

    Callback$format(...)

#### Arguments

- `...`:

  (ignored).

------------------------------------------------------------------------

### `Callback$print()`

Printer.

#### Usage

    Callback$print(...)

#### Arguments

- `...`:

  (ignored).

------------------------------------------------------------------------

### `Callback$help()`

Opens the corresponding help page referenced by field `$man`.

#### Usage

    Callback$help()

------------------------------------------------------------------------

### `Callback$call()`

Call the specific stage for a given context.

#### Usage

    Callback$call(stage, context)

#### Arguments

- `stage`:

  (`character(1)`)  
  stage.

- `context`:

  (`Context`)  
  Context.

------------------------------------------------------------------------

### `Callback$clone()`

The objects of this class are cloneable with this method.

#### Usage

    Callback$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
library(R6)

# implement callback subclass
CallbackExample = R6Class("CallbackExample",
  inherit = mlr3misc::Callback,
  public = list(
    on_stage_a = NULL,
    on_stage_b = NULL,
    on_stage_c = NULL
  )
)
```
