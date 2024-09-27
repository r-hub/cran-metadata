test_that("download_files", {
  mkdirp(tmp <- tempfile())
  on.exit(unlink(tmp), add = TRUE)
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  baseurl <- fake_cran$url()
  urls <- paste0(baseurl, "/download/", letters)
  withr::local_envvar(TEST_DOWNLOAD_CHUNK_SIZE = 10)

  expect_snapshot({
    res <- download_files(urls, destdir = tmp)
  })

  expect_equal(res, file.path(tmp, letters))
  for (l in letters) {
    expect_equal(
      read_file(file.path(tmp, l)),
      strrep(l, 1000)
    )
  }

  expect_equal(
    download_files(urls, destdir = tmp),
    file.path(tmp, letters)
  )

  # failures
  unlink(file.path(tmp, "e"))
  urls[5] <- paste0(baseurl, "/fail/e")
  expect_snapshot({
    res <- download_files(urls, destdir = tmp)
  })
  expect_equal(
    res,
    ifelse(1:26 == 5, NA_character_, file.path(tmp, letters))
  )
})
