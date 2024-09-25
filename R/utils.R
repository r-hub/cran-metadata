`%||%` <- function(l, r) if (is.null(l)) r else l

`%&&%` <- function(l, r) if (is.null(l)) l else r

is_na1 <- function(x) {
  identical(x, NA_character_) || identical(x, NA_integer_) ||
    identical(x, NA_real_) || identical(x, NA_complex_) ||
    identical(x, NA)
}

`%|NA|%` <- function(l, r) if (is_na1(l)) r else l

chunk <- function(x, size) {
  split(x, ceiling(seq_along(x)/size))
}

mkdirp <- function(x) {
  vapply(x, logical(1), FUN = function(xx) {
    dir.create(xx, showWarnings = FALSE, recursive = TRUE)
  })
}

read_file <- function(x) {
  cnt <- rawToChar(readBin(x, "raw", n = file.size(x)))
  Encoding(cnt) <- "UTF-8"
  cnt
}
