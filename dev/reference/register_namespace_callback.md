# Registers a Callback on Namespace load/unLoad Events

Register a function `callback` to be called after a namespace is loaded.
Calls `callback` once if the namespace has already been loaded before
and also adds an unload-hook that removes the load hook.

## Usage

``` r
register_namespace_callback(pkgname, namespace, callback)
```

## Arguments

- pkgname:

  (`character(1)`)  
  Name of the package which registers the callback.

- namespace:

  (`character(1)`)  
  Namespace to react on.

- callback:

  (`function()`)  
  Function to call on namespace load.

## Value

`NULL`.
