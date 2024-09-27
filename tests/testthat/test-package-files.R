test_that("get_desc_data_tar", {
  path <- test_path("fixtures/test_0.0.0.9000.tar.gz")
  expect_snapshot({
    dsc <- get_desc_data_tar(path, "test")
    dsc
  })

  mockery::stub(get_desc_data_tar, "system", function(command, ...) {
    if (substr(command, 1, 4) == "gzip") {
      warning("this does not work, sorry")
      return("fee")
    }
    base::system(command, ...)
  })
  dsc2 <- get_desc_data_tar(path, "test")
  expect_equal(dsc2, dsc)

  mockery::stub(get_desc_data_tar, "system", function(command, ...) {
    structure("not good", status = 1L)
  })
  expect_equal(get_desc_data_tar(path, "test"), NA_character_)
})

test_that("get_desc_data_zip", {
  path <- test_path("fixtures/foobar_1.0.0.zip")
  expect_snapshot({
    get_desc_data_zip(path, "foobar")
  })

  mockery::stub(get_desc_data_tar, "system", function(command, ...) {
    structure("not good", status = 1L)
  })
  expect_equal(get_desc_data_tar(path, "test"), NA_character_)
})

test_that("get_desc_data", {
  paths <- test_path(c(
    "fixtures/test_0.0.0.9000.tar.gz",
    "fixtures/test_0.0.0.9000.tgz",
    "fixtures/foobar_1.0.0.zip",
    "fixtures/foobar_1.0.1.zip",
    "fixtures/foobar_1.0.2.zip"
  ))
  expect_snapshot({
    get_desc_data(paths)
  })
})
