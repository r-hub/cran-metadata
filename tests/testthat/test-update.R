test_that("get_package_directories", {
  expect_snapshot({
    get_package_directories()
  })
})

test_that("update", {
  dirs <- NULL
  mockery::stub(update, "update_dir", function(dir) {
    dirs <<- c(dirs, dir)
  })
  expect_snapshot({
    update()
  })
  expect_equal(dirs, get_package_directories())
  })

test_that("update_dir", {
  mkdirp(tmp <- tempfile())
  on.exit(unlink(tmp), add = TRUE)
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)

  withr::local_envvar(TEST_CRAN_PACKAGE_MIRROR = fake_cran$url())
  withr::local_envvar(GITHUB_WORKSPACE = test_path("fixtures"))
  withr::local_envvar(RUNNER_TEMP = file.path(tmp, "cache"))

  # create a local METADATA2.gz file that is outdated
  meta <- suppressMessages(parse_metadata_file("src/contrib"))
  meta_upd <- rbind(meta, c("test_0.0.0.1.tar.gz", 1, NA, "", NA, ""))
  withr::local_envvar(GITHUB_WORKSPACE = tmp)
  write_metadata("src/contrib", meta_upd)

  expect_snapshot({
    ret <- update_dir("src/contrib")
  }, transform = function(x) redact_tempfile(redact_webfakes(x)))
  meta_new <- suppressMessages(parse_metadata_file("src/contrib"))
  expect_snapshot({
    meta_new[grepl("test", meta_new$file), ]
  })

  # all packages are up to date now
  expect_snapshot({
    ret <- update_dir("src/contrib")
  }, transform = function(x) redact_tempfile(redact_webfakes(x)))

  # simulate a download error
  write_metadata("src/contrib", meta_upd)
  mockery::stub(update_dir, "download_files", function(urls, ...) {
    rep(NA_character_, length(urls))
  })
  expect_snapshot({
    ret <- update_dir("src/contrib")
  }, transform = function(x) redact_tempfile(redact_webfakes(x)))
  meta_new <- suppressMessages(parse_metadata_file("src/contrib"))
  expect_snapshot({
    meta_upd[!meta_upd$file %in% meta_new$file, ]
  })
  expect_true(all(meta_new$file %in% meta_upd$file))
})
