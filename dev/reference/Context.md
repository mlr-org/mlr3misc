# Context

Context objects allow
[Callback](https://mlr3misc.mlr-org.com/dev/reference/Callback.md)
objects to access and modify data. The following packages implement
context subclasses:

- `ContextOptimization` in
  [bbotk](https://CRAN.R-project.org/package=bbotk).

- `ContextEval` in
  [mlr3tuning](https://CRAN.R-project.org/package=mlr3tuning).

- `ContextTorch` in [`mlr3torch`](https://github.com/mlr-org/mlr3torch)

## Details

Context is an abstract base class. A subclass inherits from Context.
Data is stored in public fields. Access to the data can be restricted
with active bindings (see example).

## Public fields

- `id`:

  (`character(1)`)  
  Identifier of the object. Used in tables, plot and text output.

- `label`:

  (`character(1)`)  
  Label for this object. Can be used in tables, plot and text output
  instead of the ID.

## Methods

### Public methods

- [`Context$new()`](#method-Context-new)

- [`Context$format()`](#method-Context-format)

- [`Context$print()`](#method-Context-print)

- [`Context$clone()`](#method-Context-clone)

------------------------------------------------------------------------

### Method `new()`

Creates a new instance of this
[R6](https://r6.r-lib.org/reference/R6Class.html) class.

#### Usage

    Context$new(id, label = NA_character_)

#### Arguments

- `id`:

  (`character(1)`)  
  Identifier for the new instance.

- `label`:

  (`character(1)`)  
  Label for the new instance.

------------------------------------------------------------------------

### Method [`format()`](https://rdrr.io/r/base/format.html)

Format object as simple string.

#### Usage

    Context$format(...)

#### Arguments

- `...`:

  (ignored).

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print object.

#### Usage

    Context$print()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Context$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
library(data.table)
library(R6)

# data table with column x an y
data = data.table(x = runif(10), y = sample(c("A", "B"), 10, replace = TRUE))

# context only allows to access column y
ContextExample = R6Class("ContextExample",
  inherit = Context,
  public = list(
    data = NULL,

    initialize = function(data) {
        self$data = data
    }
  ),

  active = list(
    y = function(rhs) {
      if (missing(rhs)) return(self$data$y)
      self$data$y = rhs
    }
  )
)

context = ContextExample$new(data)

# retrieve content of column y
context$y
#>  [1] "A" "B" "A" "A" "B" "B" "A" "A" "B" "A"

# change content of column y to "C"
context$y = "C"
```
