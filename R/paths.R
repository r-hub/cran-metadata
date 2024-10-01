repo_root <- function() {
  file.path(Sys.getenv("R_APP_WORKSPACE", "www"))
}

cache_dir <- function() {
  file.path(Sys.getenv("R_APP_TEMP", "cache"))
}
