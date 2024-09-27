fake_cran_app <- webfakes::new_app()
fake_cran_app$get("/src/contrib", function(req, res) {
  res$send_file(testthat::test_path("fixtures/src-contrib.html"))
})
fake_cran_app$get("/download/:name", function(req, res) {
  cnt <- strrep(req$params$name, 1000)
  res$send(cnt)
})
fake_cran_app$get("/fail/:name", function(req, res) {
  res$set_status(404L)
  res$send("oops")
})
fake_cran_app$get(
  webfakes::new_regexp("/src/contrib/(?<file>.*)$"),
  function(req, res) {
    res$send_file(testthat::test_path("fixtures", req$params$file))
  }
)
fake_cran <- webfakes::new_app_process(fake_cran_app)

redact_webfakes <- function(x) {
  gsub("http://127.0.0.1:[0-9]+", "http://127.0.0.1:<port>", x)
}

redact_tempfile <- function(x) {
  tmp <- tempdir()
  x <- gsub(tmp, "<tempdir>", x)
  x <- gsub("<tempdir>/file[^/]*/", "<tempdir>/<tempfile>/", x)
  x
}
