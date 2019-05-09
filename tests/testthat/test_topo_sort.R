context("topo_sort")

test_that("topo_sort", {
  # graph:
  # a
  nodes = rbindlist(list(
    list(id = "a", parents = list(character(0L)))
  ), use.names = TRUE)
  r = topo_sort(nodes)
  rr = data.table(id = "a", depth = 0)
  expect_equal(r, rr)

  # graph:
  # a      b
  nodes = rbindlist(list(
    list(id = "a", parents = list(character(0L))),
    list(id = "b", parents = list(character(0L)))
  ), use.names = TRUE)
  r = topo_sort(nodes)
  rr = data.table(
    id = c("a", "b"),
    depth = c(0, 0))
  expect_equal(r, rr)

  # graph:
  # c -> b -> a
  nodes = rbindlist(list(
    list(id = "a", parents = list(c("b"))),
    list(id = "b", parents = list(c("c"))),
    list(id = "c", parents = list(character(0L)))
  ), use.names = TRUE)
  r = topo_sort(nodes)
  rr = data.table(
    id = c("c", "b", "a"),
    depth = c(0, 1, 2))
  expect_equal(r, rr)

  # graph:
  # c -> b ---------> e
  #      b -> a ----> e
  # d -> b
  nodes = rbindlist(list(
    list(id = "a", parents = list(c("b"))),
    list(id = "b", parents = list(c("c", "d"))),
    list(id = "c", parents = list(character(0L))),
    list(id = "d", parents = list(character(0L))),
    list(id = "e", parents = list(c("a", "b")))
  ), use.names = TRUE)
  r = topo_sort(nodes)
  rr = data.table(
    id = c("c", "d", "b", "a", "e"),
    depth = c(0, 0, 1, 2, 3))
  expect_equal(r, rr)

  # graph:
  # a -> b -> c -> a
  nodes = rbindlist(list(
    list(id = "a", parents = list(c("c"))),
    list(id = "b", parents = list(c("a"))),
    list(id = "c", parents = list(c("a")))
  ), use.names = TRUE)
  expect_error(topo_sort(nodes), "Cycle")
})
