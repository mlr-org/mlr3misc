#include <R.h>
#include <Rinternals.h>

SEXP u_sym; // unique symbol

SEXP C_set_unique_flag(SEXP x) {
    if (!u_sym) u_sym = install(".unique");

    SEXP true_val = PROTECT(ScalarLogical(TRUE));
    setAttrib(x, u_sym, true_val);
    UNPROTECT(1);
    return x;
}
