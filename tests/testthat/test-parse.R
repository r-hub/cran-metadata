test_that("parse_file_name", {
  expect_snapshot({
    parse_file_name(c(
      "package1_1.0.0.tar.gz",
      "package2_1.0.1.tgz",
      "package3_1.0.2.zip"
    ))
  })
})

test_that("parse_package_list", {
  withr::local_envvar(TEST_CRAN_PACKAGE_MIRROR = fake_cran$url())
  expect_snapshot({
    parse_package_list("src/contrib")
  }, transform = redact_webfakes)
})

test_that("parse_metadata_file", {
  withr::local_envvar(R_APP_WORKSPACE = test_path("fixtures"))
  expect_snapshot({
    parse_metadata_file("src/contrib")
  })

  withr::local_envvar(R_APP_WORKSPACE = tempfile())
  expect_snapshot({
    parse_metadata_file("src/contrib")
  }, transform = redact_tempfile)
})

test_that("get_state", {
  withr::local_envvar(TEST_CRAN_PACKAGE_MIRROR = fake_cran$url())
  withr::local_envvar(R_APP_WORKSPACE = test_path("fixtures"))
  expect_snapshot({
    get_state("src/contrib")
  }, transform = redact_webfakes)
})
