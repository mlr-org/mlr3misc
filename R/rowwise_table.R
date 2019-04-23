#' @title Construct a data.table in a row-wise fashion
#'
#' Similar to the \CRANpkg{tibble} function `tribble()`, this function
#' allows to construct tabular data in a row-wise fashion.
#'
#' The first arguments passed as formula will be interpreted as column names.
#' The remaining arguments will be put into the resulting table.
#'
#' @param ... Arguments: Column names first as formula, then the tabular data.
#'
#' @return [`data.table::data.table()`].
#' @export
#' @examples
#' rowwise_table(
#'   ~a,  ~b,
#'   1,   "a",
#'   2,   "b"
#' )
rowwise_table = function(...) {
  dots = list(...)

  for (i in seq_along(dots)) {
    if (!inherits(dots[[i]], "formula")) {
      ncol = i - 1L
      break
    }
  }

  if (ncol == 0L)
    stop("No column names provided")
  n = length(dots) - ncol
  if (n %% ncol != 0L)
    stop("Data is not rectangular")

  tab = lapply(seq_len(ncol), function(i) simplify2array(dots[seq(from = ncol + i, to = length(dots), by = ncol)]))
  setnames(setDT(tab), map_chr(head(dots, ncol), function(x) attr(terms(x), "term.labels")))[]
}

