# Topological Sorting of Dependency Graphs

Topologically sort a graph, where we are passed node labels and a list
of direct parents for each node, as labels, too. A node can be
'processed' if all its parents have been 'processed', and hence occur at
previous indices in the resulting sorting. Returns a table, in
topological row order for IDs, and an entry `depth`, which encodes the
topological layer, starting at 0. So nodes with `depth == 0` are the
ones with no dependencies, and the one with maximal `depth` are the ones
on which nothing else depends on.

## Usage

``` r
topo_sort(nodes)
```

## Arguments

- nodes:

  ([`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html))  
  Has 2 columns:

  - `id` of type `character`, contains all node labels.

  - `parents` of type `list` of `character`, contains all direct parents
    label of `id`.

## Value

([`data.table::data.table()`](https://rdrr.io/pkg/data.table/man/data.table.html))
with columns `id`, `depth`, sorted topologically for IDs.

## Examples

``` r
nodes = rowwise_table(
  ~id, ~parents,
  "a", "b",
  "b", "c",
  "c", character()
)
topo_sort(nodes)
#>        id depth
#>    <char> <int>
#> 1:      c     0
#> 2:      b     1
#> 3:      a     2
```
