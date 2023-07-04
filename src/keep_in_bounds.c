#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

SEXP c_keep_in_bounds(SEXP in, SEXP lower, SEXP upper) {
    const int * x = INTEGER(in);
    const int ll = INTEGER(lower)[0];
    const int lu = INTEGER(upper)[0];
    const R_xlen_t n = Rf_xlength(in);
    R_xlen_t i;

    // fast-forward to first element not in bounds
    for (i = 0; i < n; i++) {
        if (x[i] == NA_INTEGER || x[i] < ll || x[i] > lu) {
            break;
        }
    }

    // everything ok, in == out
    if (i == n) {
        return(in);
    }

    // allocate output vector
    SEXP out = PROTECT(Rf_allocVector(INTSXP, n));
    int * y = INTEGER(out);
    R_xlen_t j;

    // copy everything up to the first element out of bounds
    for (j = 0; j < i; j++) {
        y[j] = x[j];
    }

    // process remaining elements
    for (i = i + 1; i < n; i++) {
        if (x[i] != NA_INTEGER && x[i] >= ll && x[i] <= lu) {
            y[j] = x[i];
            j++;
        }
    }

    // resize the vector to the right length
    SETLENGTH(out, j);

    // unprotect + return
    UNPROTECT(1);
    return out;
}
