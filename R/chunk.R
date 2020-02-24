#' @title Chunk Vectors
#'
#' @description
#' Chunk atomic vectors into parts of roughly equal size.
#' `chunk()` takes a vector length `n` and returns an integer with chunk numbers.
#' `chunk_vector()` uses [base::split()] and `chunk()` to split an atomic vector into chunks.
#'
#' @param x (`vector()`)\cr
#'   Vector to split into chunks.
#' @param chunk_size (`integer(1)`)\cr
#'   Requested number of elements in each chunk.
#'   Mutually exclusive with `n_chunks` and `props`.
#' @param n_chunks (`integer(1)`)\cr
#'   Requested number of chunks.
#'   Mutually exclusive with `chunk_size` and `props`.
#' @param shuffle (`logical(1)`)\cr
#'   If `TRUE`, permutes the order of `x` before chunking.
#'
#' @return `chunk()` returns a `integer()` of chunk indices,
#'   `chunk_vector()` a `list()` of `integer` vectors.
#' @export
#' @examples
#' x = 1:11
#'
#' ch = chunk(length(x), n_chunks = 2)
#' table(ch)
#' split(x, ch)
#'
#' chunk_vector(x, n_chunks = 2)
#'
#' chunk_vector(x, n_chunks = 3, shuffle = TRUE)
chunk_vector = function(x, n_chunks = NULL, chunk_size = NULL, shuffle = TRUE) {
  assert_atomic_vector(x)
  unname(split(x, chunk(length(x), n_chunks, chunk_size, shuffle)))
}

#' @param n (`integer(1)`)\cr
#'   Length of vector to split.
#' @rdname chunk_vector
#' @export
chunk = function(n, n_chunks = NULL, chunk_size = NULL, shuffle = TRUE) {

  assert_count(n)
  if (!xor(is.null(n_chunks), is.null(chunk_size))) {
    stop("You must provide either 'n_chunks' (x)or 'chunk_size'")
  }
  assert_count(n_chunks, positive = TRUE, null.ok = TRUE)
  assert_count(chunk_size, positive = TRUE, null.ok = TRUE)
  assert_flag(shuffle)

  if (n == 0L) {
    return(integer(0L))
  }
  if (is.null(n_chunks)) {
    n_chunks = (n %/% chunk_size + (n %% chunk_size > 0L))
  }
  chunks = as.integer((seq.int(0L, n - 1L) %% min(n_chunks, n))) + 1L
  if (shuffle) shuffle(chunks) else sort(chunks)
}
