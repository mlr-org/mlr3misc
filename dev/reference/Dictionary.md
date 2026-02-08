# Key-Value Storage

A key-value store for
[R6::R6](https://r6.r-lib.org/reference/R6Class.html) objects. On
retrieval of an object, the following applies:

- If the object is a `R6ClassGenerator`, it is initialized with `new()`.

- If the object is a function, it is called and must return an instance
  of a [R6::R6](https://r6.r-lib.org/reference/R6Class.html) object.

- If the object is an instance of a R6 class, it is returned as-is.

Default argument required for construction can be stored alongside their
constructors by passing them to `$add()`.

## S3 methods

- `as.data.table(d)`  
  Dictionary -\>
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html)  
  Converts the dictionary to a
  [`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html).

## Public fields

- `items`:

  ([`environment()`](https://rdrr.io/r/base/environment.html))  
  Stores the items of the dictionary

## Methods

### Public methods

- [`Dictionary$new()`](#method-Dictionary-new)

- [`Dictionary$format()`](#method-Dictionary-format)

- [`Dictionary$print()`](#method-Dictionary-print)

- [`Dictionary$keys()`](#method-Dictionary-keys)

- [`Dictionary$has()`](#method-Dictionary-has)

- [`Dictionary$get()`](#method-Dictionary-get)

- [`Dictionary$mget()`](#method-Dictionary-mget)

- [`Dictionary$add()`](#method-Dictionary-add)

- [`Dictionary$remove()`](#method-Dictionary-remove)

- [`Dictionary$prototype_args()`](#method-Dictionary-prototype_args)

- [`Dictionary$clone()`](#method-Dictionary-clone)

------------------------------------------------------------------------

### Method `new()`

Construct a new Dictionary.

#### Usage

    Dictionary$new()

------------------------------------------------------------------------

### Method [`format()`](https://rdrr.io/r/base/format.html)

Format object as simple string.

#### Usage

    Dictionary$format(...)

#### Arguments

- `...`:

  (ignored).

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Print object.

#### Usage

    Dictionary$print()

------------------------------------------------------------------------

### Method `keys()`

Returns all keys which comply to the regular expression `pattern`. If
`pattern` is `NULL` (default), all keys are returned.

#### Usage

    Dictionary$keys(pattern = NULL)

#### Arguments

- `pattern`:

  (`character(1)`).

#### Returns

[`character()`](https://rdrr.io/r/base/character.html) of keys.

------------------------------------------------------------------------

### Method `has()`

Returns a logical vector with `TRUE` at its i-th position if the i-th
key exists.

#### Usage

    Dictionary$has(keys)

#### Arguments

- `keys`:

  ([`character()`](https://rdrr.io/r/base/character.html)).

#### Returns

[`logical()`](https://rdrr.io/r/base/logical.html).

------------------------------------------------------------------------

### Method [`get()`](https://rdrr.io/r/base/get.html)

Retrieves object with key `key` from the dictionary. Additional
arguments must be named and are passed to the constructor of the stored
object.

#### Usage

    Dictionary$get(key, ..., .prototype = FALSE)

#### Arguments

- `key`:

  (`character(1)`).

- `...`:

  (`any`)  
  Passed down to constructor.

- `.prototype`:

  (`logical(1)`)  
  Whether to construct a prototype object.

#### Returns

Object with corresponding key.

------------------------------------------------------------------------

### Method [`mget()`](https://rdrr.io/r/base/get.html)

Returns objects with keys `keys` in a list named with `keys`. Additional
arguments must be named and are passed to the constructors of the stored
objects.

#### Usage

    Dictionary$mget(keys, ...)

#### Arguments

- `keys`:

  ([`character()`](https://rdrr.io/r/base/character.html)).

- `...`:

  (`any`)  
  Passed down to constructor.

#### Returns

Named [`list()`](https://rdrr.io/r/base/list.html) of objects with
corresponding keys.

------------------------------------------------------------------------

### Method `add()`

Adds object `value` to the dictionary with key `key`, potentially
overwriting a previously stored item. Additional arguments in `...` must
be named and are passed as default arguments to `value` during
construction.

#### Usage

    Dictionary$add(key, value, ..., .prototype_args = list())

#### Arguments

- `key`:

  (`character(1)`).

- `value`:

  (`any`).

- `...`:

  (`any`)  
  Passed down to constructor.

- `.prototype_args`:

  ([`list()`](https://rdrr.io/r/base/list.html))  
  List of arguments to construct a prototype object. Can be used when
  objects have construction arguments without defaults.

#### Returns

`Dictionary`.

------------------------------------------------------------------------

### Method [`remove()`](https://rdrr.io/r/base/rm.html)

Removes objects with from the dictionary.

#### Usage

    Dictionary$remove(keys)

#### Arguments

- `keys`:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Keys of objects to remove.

#### Returns

`Dictionary`.

------------------------------------------------------------------------

### Method `prototype_args()`

Returns the arguments required to construct a simple prototype of the
object.

#### Usage

    Dictionary$prototype_args(key)

#### Arguments

- `key`:

  (`character(1)`)  
  Key of object to query for required arguments.

#### Returns

[`list()`](https://rdrr.io/r/base/list.html) of prototype arguments

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Dictionary$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
library(R6)
item1 = R6Class("Item", public = list(x = 1))
item2 = R6Class("Item", public = list(x = 2))
d = Dictionary$new()
d$add("a", item1)
d$add("b", item2)
d$add("c", item1$new())
d$keys()
#> [1] "a" "b" "c"
d$get("a")
#> <Item>
#>   Public:
#>     clone: function (deep = FALSE) 
#>     x: 1
d$mget(c("a", "b"))
#> $a
#> <Item>
#>   Public:
#>     clone: function (deep = FALSE) 
#>     x: 1
#> 
#> $b
#> <Item>
#>   Public:
#>     clone: function (deep = FALSE) 
#>     x: 2
#> 
```
