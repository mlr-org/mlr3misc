source("setup.R")
using("checkmate")


# modify_if
x = modify_if(iris, is.factor, as.character)
expect_character(x$Species)

x = modify_if(as.data.table(iris), is.factor, as.character)
expect_character(x$Species)

# modify_at
x = modify_at(iris, "Species", as.character)
expect_character(x$Species)

x = modify_at(as.data.table(iris), "Species", as.character)
expect_character(x$Species)
