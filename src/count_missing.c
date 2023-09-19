#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include <Rversion.h>
#include "backports.h"

static R_xlen_t count_missing_logical(SEXP x) {
#if defined(R_VERSION) && R_VERSION >= R_Version(3, 6, 0)
    if (LOGICAL_NO_NA(x))
        return 0;
#endif
    const R_xlen_t n = Rf_xlength(x);
    const int * xp = LOGICAL_RO(x);
    R_xlen_t count = 0;
    for (R_xlen_t i = 0; i < n; i++) {
        if (xp[i] == NA_LOGICAL)
            count++;
    }
    return count;
}

static R_xlen_t count_missing_integer(SEXP x) {
#if defined(R_VERSION) && R_VERSION >= R_Version(3, 5, 0)
    if (INTEGER_NO_NA(x))
        return 0;
#endif
    const R_xlen_t n = Rf_xlength(x);
    const int * xp = INTEGER_RO(x);
    R_xlen_t count = 0;
    for (R_xlen_t i = 0; i < n; i++) {
        if (xp[i] == NA_INTEGER)
            count++;
    }
    return count;
}

static R_xlen_t count_missing_double(SEXP x) {
#if defined(R_VERSION) && R_VERSION >= R_Version(3, 5, 0)
    if (REAL_NO_NA(x))
        return 0;
#endif
    const R_xlen_t n = Rf_xlength(x);
    const double * xp = REAL_RO(x);
    R_xlen_t count = 0;
    for (R_xlen_t i = 0; i < n; i++) {
        if (ISNAN(xp[i]))
            count++;
    }
    return count;
}

static R_xlen_t count_missing_complex(SEXP x) {
    const R_xlen_t n = Rf_xlength(x);
    const Rcomplex * xp = COMPLEX_RO(x);
    R_xlen_t count = 0;
    for (R_xlen_t i = 0; i < n; i++) {
        if (ISNAN((xp[i]).r) || ISNAN((xp[i]).i))
            count++;
    }
    return count;
}

static R_xlen_t count_missing_string(SEXP x) {
#if defined(R_VERSION) && R_VERSION >= R_Version(3, 5, 0)
    if (STRING_NO_NA(x))
        return 0;
#endif
    const R_xlen_t nx = Rf_xlength(x);
    R_xlen_t count = 0;
    for (R_xlen_t i = 0; i < nx; i++) {
        if (STRING_ELT(x, i) == NA_STRING)
            count++;
    }
    return count;
}

SEXP c_count_missing(SEXP x) {
    switch(TYPEOF(x)) {
        case LGLSXP:  return Rf_ScalarInteger(count_missing_logical(x));
        case INTSXP:  return Rf_ScalarInteger(count_missing_integer(x));
        case REALSXP: return Rf_ScalarInteger(count_missing_double(x));
        case CPLXSXP: return Rf_ScalarInteger(count_missing_complex(x));
        case STRSXP:  return Rf_ScalarInteger(count_missing_string(x));
        default: Rf_error("Object of type '%s' not supported", Rf_type2char(TYPEOF(x)));
    }
}
