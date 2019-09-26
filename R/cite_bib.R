#' @title Cite using a Bibtex File
#'
#' @description
#' This function is called by the provided Rd macro `\\cite{pkg}{key}`:
#'
#' * Parses the bibtex file `references.bib` in the root directory of package `package` using [bibtex::read.bib()].
#' * Extracts the entry with key `key`.
#' * Converts to Rd with [tools::toRd()].
#'
#' @param package (`character(1)`)\cr
#'   Package to read the bibtex file from.
#' @param key (`character(1)`)\cr
#'   Entry of the bibtex file.
#'
#' @return (`character(1)`) Bibentry formated as Rd.
#'
#' @export
#' @examples
#' # examplary bibtex file
#' path = system.file("references.bib", package = "mlr3misc")
#' cat(readLines(path), sep = "\n")
#'
#' # return value: raw rd
#' cite_bib("mlr3misc", "mlr")
cite_bib = function(package, key) {
  assert_string(package)
  assert_string(key)

  if (!requireNamespace("bibtex", quietly = TRUE)) {
    warningf("Could not load package 'bibtex' to parse citation '%s'", key)
    return(sprintf("bibtex:%s", key))
  }

  path = system.file("references.bib", package = package)
  if (!file.exists(path)) {
    warningf("Bibtex file '%s' for package '%s' does not exist", path, package)
    return(sprintf("bibtex:%s", key))
  }

  bib = bibtex::read.bib(path)

  if (key %nin% names(bib)) {
    warningf("Key '%s' not found in references.bib of package '%s'", key, package)
    return(sprintf("bibtex:%s", key))
  }

  paste0(tools::toRd(bib[[key]]), "\n")
}
