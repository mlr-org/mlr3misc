#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h>
#include <R_ext/Rdynload.h>

extern SEXP c_count_missing(SEXP);
extern SEXP c_keep_in_bounds(SEXP, SEXP, SEXP);
extern SEXP c_which_max(SEXP, SEXP, SEXP);
extern SEXP c_to_decimal(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"c_count_missing", (DL_FUNC) &c_count_missing, 1},
    {"c_keep_in_bounds", (DL_FUNC) &c_keep_in_bounds, 3},
    {"c_which_max", (DL_FUNC) &c_which_max, 3},
    {"c_to_decimal", (DL_FUNC) &c_to_decimal, 1},
    {NULL, NULL, 0}
};

void R_init_mlr3misc(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
