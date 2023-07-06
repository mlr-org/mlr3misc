#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

SEXP c_to_decimal(SEXP _bits) {
    const R_len_t n = Rf_length(_bits);
    const int * bits = LOGICAL(_bits);

    if (n > 30) {
        Rf_error("to_decimal() only works for vectors with <= 30 elements");
    }

    int power = 1 << n;
    int out = 0;

    for (R_len_t i = 0; i < n; i++) {
        power >>= 1;

        if (bits[i] == NA_LOGICAL) {
            Rf_error("Bit vector contains missing values");
        }

        if (bits[i]) {
            out += power;
        }
    }

    return Rf_ScalarInteger(out);
}
