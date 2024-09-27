download_files_chunk_size <- function() {
  as.integer(Sys.getenv("TEST_DOWNLOAD_CHUNK_SIZE", 100))
}

download_files <- function(urls, destdir) {
  chks <- chunk(urls, download_files_chunk_size())
  out <- lapply(chks, download_files_chunk, destdir = destdir)
  unlist(out)
}

download_files_chunk <- function(urls, destdir) {
  destfiles <- file.path(destdir, basename(urls))
  miss <- !file.exists(destfiles)
  if (sum(miss) == 0) return(destfiles)

  tmpfiles <- paste0(destfiles, ".tmp")
  on.exit(unlink(tmpfiles), add = TRUE)
  unlink(tmpfiles)
  mkdirp(unique(dirname(tmpfiles)))

  proc <- cli::cli_process_start("Downloading {sum(miss)} package{?s}.")
  dlres <- curl::multi_download(urls[miss], tmpfiles[miss], progress = FALSE)
  cli::cli_process_done(proc)

  httpfail <- dlres$success & dlres$status_code >= 300
  dlres$success[httpfail] <- FALSE
  dlres$error[httpfail] <- substr(paste0(
    "HTTP error ",
    dlres$status_code[httpfail], ": ",
    vapply(tmpfiles[miss][httpfail], "", FUN = function(f) { read_file(f) })
  ), 1, 300)

  if (any(!dlres$success)) {
    cli::cli_alert_danger(
      "Failed to download {sum(!dlres$success)} package{?s}."
    )
    cli::cli_text("First error message:")
    msg <- dlres$error[[which(!dlres$success)[1]]]
    cli::cli_text("{msg}")
  }

  dlok <- dlres$success
  file.rename(tmpfiles[miss][dlok], destfiles[miss][dlok])
  ok <- rep(FALSE, length(urls))
  ok[!miss] <- TRUE
  ok[miss][dlok] <- TRUE
  ifelse(ok, destfiles, NA_character_)
}
