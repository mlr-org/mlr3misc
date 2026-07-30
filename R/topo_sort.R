#' @title Topological Sorting of Dependency Graphs
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
#' @param nodes ([data.table::data.table()])\cr
#'   Has 2 columns:
#'   * `id` of type `character`, contains all node labels.
#'   * `parents` of type `list` of `character`, contains all direct parents label of `id`.
#'
#' @return ([data.table::data.table()]) with columns `id`, `depth`, sorted topologically for IDs.
#' @export
#' @examples
#' nodes = rowwise_table(
#'   ~id, ~parents,
#'   "a", "b",
#'   "b", "c",
#'   "c", character()
#' )
#' topo_sort(nodes)
topo_sort = function(nodes) {
  assert_data_table(nodes, ncols = 2L, types = c("character", "list"))
  assert_names(names(nodes), identical.to = c("id", "parents"))
  assert_list(nodes$parents, types = "character")
  assert_subset(unlist(nodes$parents, use.names = FALSE), nodes$id)

  # sort nodes with few parents first and preserve this order within each depth layer
  nodes = nodes[order(lengths(get("parents")), decreasing = FALSE)]
  n = nrow(nodes)
  parents = nodes$parents
  indegree = lengths(parents)
  ii = which(indegree > 1L)
  parents[ii] = map(parents[ii], unique)
  indegree[ii] = lengths(parents[ii])

  parent_idx = match(unlist(parents, use.names = FALSE), nodes$id)
  child_idx = rep.int(seq_len(n), indegree)
  children = split(child_idx, factor(parent_idx, levels = seq_len(n)))

  topo = integer(n)
  depth = rep.int(NA_integer_, n)
  available = which(indegree == 0L)
  topo_count = 0L
  depth_count = 0L

  while (length(available)) {
    k = length(available)
    topo[topo_count + seq_len(k)] = available
    topo_count = topo_count + k
    depth[available] = depth_count

    next_available = vector("list", k)
    for (i in seq_along(available)) {
      parent = available[[i]]
      kids = children[[parent]]
      if (length(kids)) {
        indegree[kids] = indegree[kids] - 1L
        next_available[[i]] = kids[indegree[kids] == 0L]
      }
    }
    available = sort(unlist(next_available, use.names = FALSE))
    depth_count = depth_count + 1L
  }

  if (topo_count != n) {
    stop("Cycle detected, this is not a DAG!")
  }

  data.table(id = nodes$id[topo], depth = depth[topo])
}
