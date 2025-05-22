get_package_directories <- function() {
  c(
    "src/contrib",
    # old macOS
    # "bin/macosx/contrib/4.0",
    # "bin/macosx/contrib/4.1",
    # "bin/macosx/contrib/4.2",
    # arm64 package binaries for R 4.1 seem to be lost?
    "bin/macosx/big-sur-arm64/contrib/4.2",
    # new macOS x86_64
    "bin/macosx/big-sur-x86_64/contrib/4.3",
    "bin/macosx/big-sur-x86_64/contrib/4.4",
    "bin/macosx/big-sur-x86_64/contrib/4.5",
    # new macOS arm64
    "bin/macosx/big-sur-arm64/contrib/4.3",
    "bin/macosx/big-sur-arm64/contrib/4.4",
    "bin/macosx/big-sur-arm64/contrib/4.5",
    # windows
    # "bin/windows/contrib/4.0",
    # "bin/windows/contrib/4.1",
    "bin/windows/contrib/4.2",
    "bin/windows/contrib/4.3",
    "bin/windows/contrib/4.4",
    "bin/windows/contrib/4.5"
    "bin/windows/contrib/4.6"
  )
}

update <- function() {
  dirs <- get_package_directories()
  for (dir in dirs) {
    cli::cli_alert_info("Updating {.path {dir}}.")
    update_dir(dir)
  }
}

update_dir <- function(dir) {
  stat <- get_state(dir)
  if (nrow(stat$missing) == 0) {
    cli::cli_alert_success("All packages are up to date.")
    return(invisible(NULL))
  }
  cli::cli_alert_info("Will update {nrow(stat$missing)} package{?s}.")
  upd <- stat$missing
  # there might be multiple versions of the same package,
  # but that's fine, we match on path in pkgcache
  upd <- upd[order(upd$package, upd$version),]
  upd$url <- glue::glue("{get_cran_mirror()}/{dir}/{upd[['file']]}")
  destdir <- file.path(cache_dir(), dir)
  upd$path <- download_files(upd[["url"]], destdir)

  newdata <- tibble::tibble(
    file = upd$file
  )
  cli::cli_alert_info("Checking file sizes.")
  newdata$size <- file.size(upd$path)
  cli::cli_alert_info("Calculating SHA256 hashes.")
  newdata$sha <- rep(NA_character_, nrow(upd))
  newdata$sha[!is.na(upd$path)] <-
    cli::hash_file_sha256(upd$path[!is.na(upd$path)])
  newdata <- cbind(newdata, get_desc_data(upd$path)[, -(1:2)])
  newdata <- tibble::as_tibble(newdata)

  bad <- is.na(newdata$size) | is.na(newdata$sha) | is.na(newdata$sysreqs)
  if (any(bad)) {
    cli::cli_alert_danger(
      "Failed to update {sum(bad)} package{?s}: {upd$package[bad]}."
    )
    newdata <- newdata[!bad, ]
  }

  olddata <- stat$old[stat$old$file %in% stat$new$file, ]
  alldata <- rbind(olddata, newdata)
  alldata <- alldata[order(alldata$file), ]

  cli::cli_alert_info("Writing new metadata")
  write_metadata(dir, alldata)

  cli::cli_alert_success("Metadata successfully updated for {.path {dir}}.")
  invisible(alldata)
}

write_metadata <- function(dir, metadata) {
  path <- file.path(repo_root(), "metadata", dir, "METADATA2.gz")
  mkdirp(dirname(path))
  outcon <- gzcon(file(path, "wb"))
  utils::write.csv(metadata, outcon, row.names = FALSE)
  close(outcon)
}
