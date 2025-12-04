# Chunk Vectors

Chunk atomic vectors into parts of roughly equal size. `chunk()` takes a
vector length `n` and returns an integer with chunk numbers.
`chunk_vector()` uses
[`base::split()`](https://rdrr.io/r/base/split.html) and `chunk()` to
split an atomic vector into chunks.

## Usage

``` r
chunk_vector(x, n_chunks = NULL, chunk_size = NULL, shuffle = TRUE)

chunk(n, n_chunks = NULL, chunk_size = NULL, shuffle = TRUE)
```

## Arguments

- x:

  ([`vector()`](https://rdrr.io/r/base/vector.html))  
  Vector to split into chunks.

- n_chunks:

  (`integer(1)`)  
  Requested number of chunks. Mutually exclusive with `chunk_size` and
  `props`.

- chunk_size:

  (`integer(1)`)  
  Requested number of elements in each chunk. Mutually exclusive with
  `n_chunks` and `props`.

- shuffle:

  (`logical(1)`)  
  If `TRUE`, permutes the order of `x` before chunking.

- n:

  (`integer(1)`)  
  Length of vector to split.

## Value

`chunk()` returns a [`integer()`](https://rdrr.io/r/base/integer.html)
of chunk indices, `chunk_vector()` a
[`list()`](https://rdrr.io/r/base/list.html) of `integer` vectors.

## Examples

``` r
x = 1:11

ch = chunk(length(x), n_chunks = 2)
table(ch)
#> ch
#> 1 2 
#> 6 5 
split(x, ch)
#> $`1`
#> [1]  3  5  7  9 10 11
#> 
#> $`2`
#> [1] 1 2 4 6 8
#> 

chunk_vector(x, n_chunks = 2)
#> [[1]]
#> [1]  1  2  4  5  7 11
#> 
#> [[2]]
#> [1]  3  6  8  9 10
#> 

chunk_vector(x, n_chunks = 3, shuffle = TRUE)
#> [[1]]
#> [1]  2  5  7 10
#> 
#> [[2]]
#> [1]  1  6  9 11
#> 
#> [[3]]
#> [1] 3 4 8
#> 
```
