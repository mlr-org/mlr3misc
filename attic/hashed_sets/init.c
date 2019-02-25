#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>
/* .Call calls */
extern SEXP C_set_unique_flag(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"C_set_unique_flag", (DL_FUNC) &C_set_unique_flag, 1},
    {NULL, NULL, 0}
};

void R_init_mlr3misc(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
