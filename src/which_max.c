#include <R.h>
#include <Rinternals.h>
#include <limits.h>

typedef enum { TM_RANDOM, TM_FIRST, TM_LAST } ties_method_t;

static ties_method_t translate_ties_method(SEXP ties_method_) {
    const char * str = CHAR(STRING_ELT(ties_method_, 0));

    if (strcmp(str, "random") == 0)
        return TM_RANDOM;
    if (strcmp(str, "first") == 0)
        return TM_FIRST;
    if (strcmp(str, "last") == 0)
        return TM_LAST;

    error("Unknown ties method '%s'", str);
}


static int which_max_int(const int * x, const R_len_t nx, ties_method_t ties_method, Rboolean na_rm) {
    int max_index = -2;
    int max_value = INT_MIN;
    R_len_t ties = 1;

    for (R_len_t i = 0; i < nx; i++) {
        int xi = x[i];

        if (xi == NA_INTEGER) {
            if (!na_rm) {
                return NA_INTEGER;
            }
        } else if (xi > max_value) {
            max_index = i;
            max_value = xi;
            ties = 1;
        } else if (xi == max_value) {
            switch(ties_method) {
                case TM_RANDOM:
                    ties++;
                    if (ties * unif_rand() < 1.) {
                        max_index = i;
                    }
                    break;
                case TM_FIRST: break;
                case TM_LAST: max_index = i; break;
            }
        }
    }

    return max_index + 1;
}

static int which_max_dbl(const double * x, const R_len_t nx, ties_method_t ties_method, Rboolean na_rm) {
    int max_index = -2;
    double max_value = -DBL_MAX;
    R_len_t ties = 1;

    for (R_len_t i = 0; i < nx; i++) {
        double xi = x[i];

        if (ISNAN(xi)) {
            if (!na_rm) {
                return NA_REAL;
            }
        } else if (xi > max_value) {
            max_index = i;
            max_value = xi;
            ties = 1;
        } else if (xi == max_value) {
            switch(ties_method) {
                case TM_RANDOM:
                    ties++;
                    if (ties * unif_rand() < 1.) {
                        max_index = i;
                    }
                    break;
                case TM_FIRST: break;
                case TM_LAST: max_index = i; break;
            }
        }
    }

    return max_index + 1;
}

SEXP c_which_max(SEXP x_, SEXP ties_method_, SEXP na_rm_) {
    int index;
    ties_method_t ties_method = translate_ties_method(ties_method_);

    if (ties_method == TM_RANDOM)
        GetRNGstate();

    switch(TYPEOF(x_)) {
        case LGLSXP:
            index = which_max_int(LOGICAL(x_), length(x_), ties_method, LOGICAL(na_rm_)[0]);
            break;
        case INTSXP:
            index = which_max_int(INTEGER(x_), length(x_), ties_method, LOGICAL(na_rm_)[0]);
            break;
        case REALSXP:
            index = which_max_dbl(REAL(x_), length(x_), ties_method, LOGICAL(na_rm_)[0]);
            break;
        default: error("Unsupported vector type in which_max(). Supported are logical and numerical vectors.");
    }

    if (ties_method == TM_RANDOM)
        PutRNGstate();

    if (index == -1) {
        return allocVector(INTSXP, 0);
    }

   return ScalarInteger(index);
}
