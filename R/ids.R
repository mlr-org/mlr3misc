#' @title Short helper to extract ids from a typed R6 list of ID-able objects.
#'
#' @description
#' None.
#'
#' @param xs :: [list]\cr
#'   Every element must be R6 and have a slot 'id'.
#' @export
ids = function(xs) {
  map_chr(xs, "id")
}
