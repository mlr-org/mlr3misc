#' @title Get the random seed
#'
#' @description
#' Retrieves the random seed (".Random.seed" in the global environment).
#' and initializes the RNG first, if necessary.
#'
#' @return `integer()`. Depends on the [base::RNGkind()].
#' @export
#' @examples
#' str(get_seed())
get_seed = function() {
  seed = get0(".Random.seed", globalenv(), mode = "integer", inherits = FALSE)
  if (!is.null(seed))
    return(seed)

  runif(1L)
  Recall()
}
