get_desc_data_tar <- function(f, p) {
  cmd <- glue::glue(
    "gzip -dc \"{f}\" 2>/dev/null | head -c 200000 | tar -xOf - {p}/DESCRIPTION 2>/dev/null"
  )
  out <- tryCatch(
    system(cmd, intern = TRUE, ignore.stderr = TRUE),
    warning = function(e) {
      suppressWarnings(system(
        sprintf("tar -xOf \"%s\" %s/DESCRIPTION", f, p),
        intern = TRUE,
        ignore.stderr = TRUE
      ))
    }
  )
  if (!is.null(attr(out, "status")) && attr(out, "status") >= 1) {
    NA_character_
  } else {
    out
  }
}

get_desc_data_zip <- function(f, p) {
  cmd <- glue::glue("unzip -p \"{f}\" {p}/DESCRIPTION")
  out <- system(cmd, intern = TRUE)
  if (!is.null(attr(out, "status")) && attr(out, "status") >= 1) {
    NA_character_
  } else {
    out
  }
}

get_desc_data <- function(files) {
  files <- path.expand(files)
  pkgs <- parse_file_name(files)$package
  pb <- cli::cli_progress_bar(
    format = "Getting DESCRIPTION data [{cli::pb_current}/{cli::pb_total}].",
    total = length(files)
  )
  dd <- mapply(files, pkgs, USE.NAMES = FALSE, FUN = function(f, p) {
    cli::cli_progress_update(id = pb)
    d <- if (grepl("\\.zip$", f)) {
      get_desc_data_zip(f, p)
    } else {
      get_desc_data_tar(f, p)
    }
    dsc <- if (!is.na(d[1])) {
      tryCatch(desc::desc(text = d), error = function(e) NULL)
    }
    c(file = f,
      package = p,
      sysreqs = dsc %&&% dsc$get_field("SystemRequirements", "") %||% NA_character_,
      built = dsc %&&% dsc$get_field("Built", "") %||% NA_character_,
      published = dsc %&&% dsc$get_field("Date/Publication", "") %||% NA_character_
    )
  })
  cli::cli_progress_done(id = pb)

  tibble::as_tibble(t(dd))
}
