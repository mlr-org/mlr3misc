% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/insert_named.R, R/remove_named.R
\name{insert_named}
\alias{insert_named}
\alias{insert_named.NULL}
\alias{insert_named.default}
\alias{insert_named.environment}
\alias{insert_named.data.frame}
\alias{insert_named.data.table}
\alias{remove_named}
\alias{remove_named.environment}
\alias{remove_named.data.frame}
\alias{remove_named.data.table}
\title{Insert or Remove Named Elements}
\usage{
insert_named(x, y)

\method{insert_named}{`NULL`}(x, y)

\method{insert_named}{default}(x, y)

\method{insert_named}{environment}(x, y)

\method{insert_named}{data.frame}(x, y)

\method{insert_named}{data.table}(x, y)

remove_named(x, nn)

\method{remove_named}{environment}(x, nn)

\method{remove_named}{data.frame}(x, nn)

\method{remove_named}{data.table}(x, nn)
}
\arguments{
\item{x}{(\code{vector()} | \code{list()} | \code{environment()} | \code{\link[data.table:data.table]{data.table::data.table()}})\cr
Object to insert elements into, or remove elements from.
Changes are by-reference for environments and data tables.}

\item{y}{(\code{list()})\cr
List of elements to insert into \code{x}.}

\item{nn}{(\code{character()})\cr
Character vector of elements to remove.}
}
\value{
Modified object.
}
\description{
Insert elements from \code{y} into \code{x} by name, or remove elements from \code{x} by name.
Works for vectors, lists, environments and data frames and data tables.
Objects with reference semantic (\code{environment()} and \code{\link[data.table:data.table]{data.table::data.table()}}) might be modified in-place.
}
\examples{
x = list(a = 1, b = 2)
insert_named(x, list(b = 3, c = 4))
remove_named(x, "b")
}
