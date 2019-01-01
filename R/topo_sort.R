#' @title Topological sorting of a dependency graph
#'
#' @description
#' Topologically sort a graph, where we are passed node labels and a list of direct
#' parents for each node, as labels, too.
#' A node can be 'processed' if all its parents have been 'processed',
#' and hence occur at previous indices in the resulting sorting.
#' Returns a table, in topological row order for IDs, and an entry `depth`,
#' which encodes the topological layer, starting at 0.
#' So nodes with `depth == 0` are the ones with no dependencies,
#' and the one with maximal `depth` are the ones on which nothing else depends on.
#'
#' @param nodes (`data.table`)
#'   Has 2 columns:
#'     * `id` of type `character`, contains all node labels.
#'     * `parents` of type `list` of `character`, contains all direct parents label of `id`.
#' @return `data.table`, with columns `id`, `depth`, sorted topologically for IDs.
#' @export
topo_sort = function(nodes) {
  assert_data_table(nodes, ncols = 2L, types = c("character", "list"))
  assert_names(names(nodes), identical.to = c("id", "parents"))
  assert_list(nodes$parents, types = "character")
  assert_subset(unlist(nodes$parents), nodes$id)
  nodes = copy(nodes) # copy ref to be sure
  n = nrow(nodes)
  # sort nodes with few parent to start
  o = order(map_int(nodes$parents, length), decreasing = FALSE)
  nodes = nodes[o]

  nodes$topo = nodes$depth = NA_integer_ # cols for topo-index and depth layer in sort
  j = 1L; topo_count = 1L; depth_count = 0L
  while (topo_count <= n) {
    # if element is not sorted and has no deps (anymore), we sort it in
    if (is.na(nodes$topo[j]) && length(nodes$parents[[j]]) == 0L) {
      nodes$topo[j] = topo_count; topo_count = topo_count + 1L
      nodes$depth[j] = depth_count
    }
    j = (j %% n) + 1L # inc j, but wrap around end
    if (j == 1) { # we wrapped, lets remove nodes of current layer from deps
      layer = nodes[nodes$depth == depth_count]$id
      if (length(layer) == 0L)
        stop("Cycle detected, this is not a DAG!")
      nodes$parents = map(nodes$parent, function(x) setdiff(x, layer))
      depth_count = depth_count + 1L
    }
  }
  nodes[order(nodes$topo), c("id", "depth")] # sort by topo, and then remove topo-col
}

