#include <R.h>
#include <Rinternals.h>

SEXP c_keep_in_bounds(SEXP s_in, SEXP s_lower, SEXP s_upper) {
    const int *x = INTEGER(s_in);
    const int ll = asInteger(s_lower);
    const int lu = asInteger(s_upper);
    const R_xlen_t n = LENGTH(s_in);
    R_xlen_t i, j;

    // count the number of elements within bounds
    int count = 0;
    for (i = 0; i < n; i++)
        if (x[i] != NA_INTEGER && x[i] >= ll && x[i] <= lu) count++;

    // if all ok, immediatly return without alloc and copy
    if (count == n) return(s_in);

    // create a new vector to store the filtered elements
    SEXP s_out = PROTECT(allocVector(REALSXP, count));
    double *out = REAL(s_out);

    // Copy the elements within bounds to the new vector
    j = 0;
    for (i = 0; i < n; i++) {
        if (x[i] != NA_INTEGER && x[i] >= ll && x[i] <= lu)
            out[j++] = x[i];
    }
    UNPROTECT(1);
    return s_out;
}
