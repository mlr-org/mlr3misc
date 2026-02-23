# Convert a Vector of Bits to a Decimal Number

Converts a logical vector from binary to decimal. The bit vector may
have any length, the last position is the least significant, i.e. bits
are multiplied with `2^(n-1)`, `2^(n-2)`, ..., `2^1`, `2^0` where `n` is
the length of the bit vector.

## Usage

``` r
to_decimal(bits)
```

## Arguments

- bits:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  Logical vector of input values. Missing values are treated as being
  `FALSE`. If `bits` is longer than 30 elements, an exception is raised.

## Value

(`integer(1)`).
