test_that("topo_sort", {
  # graph:
  # a
  nodes = rbindlist(
    list(
      list(id = "a", parents = list(character()))
    ),
    use.names = TRUE
  )
  r = topo_sort(nodes)
  rr = data.table(id = "a", depth = 0)
  expect_equal(r, rr)

  # graph:
  # a      b
  nodes = rbindlist(
    list(
      list(id = "a", parents = list(character())),
      list(id = "b", parents = list(character()))
    ),
    use.names = TRUE
  )
  r = topo_sort(nodes)
  rr = data.table(
    id = c("a", "b"),
    depth = c(0, 0)
  )
  expect_equal(r, rr)

  # graph:
  # c -> b -> a
  nodes = rbindlist(
    list(
      list(id = "a", parents = list("b")),
      list(id = "b", parents = list("c")),
      list(id = "c", parents = list(character()))
    ),
    use.names = TRUE
  )
  r = topo_sort(nodes)
  rr = data.table(
    id = c("c", "b", "a"),
    depth = c(0, 1, 2)
  )
  expect_equal(r, rr)

  # graph:
  # c -> b ---------> e
  #      b -> a ----> e
  # d -> b
  nodes = rbindlist(
    list(
      list(id = "a", parents = list("b")),
      list(id = "b", parents = list(c("c", "d"))),
      list(id = "c", parents = list(character())),
      list(id = "d", parents = list(character())),
      list(id = "e", parents = list(c("a", "b")))
    ),
    use.names = TRUE
  )
  r = topo_sort(nodes)
  rr = data.table(
    id = c("c", "d", "b", "a", "e"),
    depth = c(0, 0, 1, 2, 3)
  )
  expect_equal(r, rr)

  # graph:
  # a -> b -> c -> a
  nodes = rbindlist(
    list(
      list(id = "a", parents = list("c")),
      list(id = "b", parents = list("a")),
      list(id = "c", parents = list("a"))
    ),
    use.names = TRUE
  )
  expect_error(topo_sort(nodes), "Cycle")
})

test_that("topo_sort preserves ordering within depth layers", {
  nodes = data.table(
    id = c("e", "d", "b", "a"),
    parents = list(c("a", "b"), "a", character(), character())
  )

  expect_equal(
    topo_sort(nodes),
    data.table(id = c("b", "a", "d", "e"), depth = c(0L, 0L, 1L, 1L))
  )
})

test_that("topo_sort handles empty graphs and repeated parent labels", {
  expect_equal(
    topo_sort(data.table(id = character(), parents = list())),
    data.table(id = character(), depth = integer())
  )

  nodes = data.table(
    id = c("a", "b"),
    parents = list(character(), c("a", "a"))
  )
  expect_equal(topo_sort(nodes), data.table(id = c("a", "b"), depth = 0:1))
})
