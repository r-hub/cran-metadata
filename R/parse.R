get_cran_mirror <- function() {
  "https://cran.r-project.org"
}

parse_file_name <- function(x) {
  list(
    package = sub("_.*$", "", basename(x)),
    version = package_version(
      sub("([.]tar[.]gz|[.]zip)$", "", sub("^.*_", "", basename(x)))
    )
  )
}

parse_package_list <- function(dir) {
  mirror <- get_cran_mirror()
  url <- glue::glue("{mirror}/{dir}")
  cli::cli_alert_info("Downloading package list from {.url {url}}.")
  html <- rvest::read_html(url)
  tab <- rvest::html_table(html)[[1]]
  # drop non-package files
  tgz <- grepl("[.]tar[.]gz$", tab[["Name"]])
  ptab <- tab[tgz, ]
  pkgver <- parse_file_name(ptab[["Name"]])
  tibble::tibble(
    file = ptab[["Name"]],
    package = pkgver[["package"]],
    version = pkgver[["version"]]
  )
}

parse_metadata_file <- function(dir) {
  path <- file.path(repo_root(), "metadata", dir, "METADATA2.gz")
  cli::cli_alert_info("Parsing metadata from {.path {path}}.")
  tab <- tibble::tibble(read.csv(path))
  tab
}

get_state <- function(dir) {
  new <- parse_package_list(dir)
  old <- parse_metadata_file(dir)
  miss <- ! new[["file"]] %in% old[["file"]]
  list(old = old, new = new, missing = new[miss, ])
}
