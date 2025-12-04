# Strip source references from objects

Source references can make objects unexpectedly large and are
undesireable in many situations. As
[renv](https://CRAN.R-project.org/package=renv) installs packages with
the `--with-keep.source` option, we sometimes need to remove source
references from objects. Methods should remove source references from
the input, but should otherwise leave the input unchanged.

## Usage

``` r
strip_srcrefs(x, ...)
```

## Arguments

- x:

  (`any`)  
  The object to strip of source references.

- ...:

  (`any`)  
  Additional arguments to the method.
