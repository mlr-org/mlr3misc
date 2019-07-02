split_sec = function(n) {
  assert_number(n, lower = 0L)
  parts = round((n / c(86400L, 3600L, 60L, 1L)) %% c(1, 24, 60, 60), digits = c(0L, 0L, 0L, 1L))
  names(parts) = c("d", "h", "m", "s")
  from = wf(parts > 0)
  if (length(from) == 0L)
    return("0s")
  parts = parts[seq.int(from, to = 4L)]
  paste0(parts, names(parts), collapse = " ")
}
