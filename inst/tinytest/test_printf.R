source("setup.R")
using("checkmate")


# messagef
expect_message(messagef("xxx%ixxx", 123), "xxx123xxx")


# catf
# FIXME:
# expect_message(catf("xxx%ixxx", 123), "xxx123xxx")


# catf into file
fn = tempfile()
catf("xxx%ixxx", 123, file = fn)
s = readLines(fn)
expect_equal(s, "xxx123xxx")
file.remove(fn)


# warningf
expect_warning(warningf("xxx%ixxx", 123), "xxx123xxx")
f = function() warningf("123")
expect_warning(f(), "123")

# stopf
expect_error(stopf("xxx%ixxx", 123), "xxx123xxx")
f = function() stopf("123")
expect_error(f(), "123")
