#' Chunk elements of vectors into blocks of nearly equal size.
#'
#' In case of shuffling and vectors that cannot be chunked evenly,
#' it is chosen randomly which levels / chunks will receive less elements.
#'
#' @param x (`vector()`):
#'   Vector to be split into chunks.
#' @param chunk_size (`integer(1)`):
#'   Requested number of elements in each chunk.
#'   Mutually exclusive with `n_chunks` and `props`.
#' @param n_chunks (`integer(1)`):
#'   Requested number of chunks.
#'   Mutually exclusive with `chunk_size` and `props`.
#' @param shuffle (`logical(1)`):
#'   If `TRUE`, permutes the order of `x` before chunking.
#' @return (integer()`) of chunk indices.
#'   Pass to [base::split()] to create a list of chunks.
#' @export
#' @examples
#' x = 1:11
#'
#' ch = chunk(x, n_chunks = 2)
#' table(ch)
#' split(x, ch)
#'
#' ch = chunk(x, n_chunks = 2, shuffle = FALSE)
#' table(ch)
#' split(x, ch)
#'
#' ch = chunk(x, chunk_size = 4)
#' table(ch)
#' split(x, ch)
chunk = function (x, n_chunks = NULL, chunk_size = NULL, shuffle = TRUE) {
  assert_atomic_vector(x)
  if (!xor(is.null(n_chunks), is.null(chunk_size)))
    stop("You must provide either 'n_chunks' (x)or 'chunk_size'")
  assert_count(n_chunks, positive = TRUE, null.ok = TRUE)
  assert_count(chunk_size, positive = TRUE, null.ok = TRUE)
  assert_flag(shuffle)
  n = length(x)
  if (n == 0L)
    return(integer(0L))
  if (is.null(n_chunks))
    n_chunks = (n%/%chunk_size + (n%%chunk_size > 0L))
  chunks = as.integer((seq.int(0L, n - 1L)%%min(n_chunks, n))) + 1L
  if (shuffle) shuffle(chunks) else sort(chunks)
}
