#include <R.h>
#include <Rinternals.h>

SEXP c_to_decimal(SEXP _bits) {
    const R_len_t n = length(_bits);
    const int * bits = LOGICAL(_bits);

    if (n > 30) {
        error("to_decimal() only works for vectors with <= 30 elements");
    }

    int power = 1 << n;
    int out = 0;

    for (R_len_t i = 0; i < n; i++) {
        power >>= 1;

        if (bits[i] == NA_LOGICAL) {
            error("Bit vector contains missing values");
        }

        if (bits[i]) {
            out += power;
        }
    }

    return ScalarInteger(out);
}
