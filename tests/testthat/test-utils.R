test_that("%&&%", {
  expect_equal(NULL %&&% "foo", NULL)
  expect_equal(letters %&&% letters[1:3], c("a", "b", "c"))
  expect_equal(NULL %&&% NULL, NULL)
  expect_equal(NULL %&&% stop("ouch"), NULL)
})

test_that("is_na1", {
  expect_true(is_na1(NA_character_))
  expect_true(is_na1(NA_integer_))
  expect_true(is_na1(NA_real_))
  expect_true(is_na1(NA_complex_))
  expect_true(is_na1(NA))
  expect_false(is_na1("foo"))
  expect_false(is_na1(NULL))
})

test_that("%|NA|%", {
  expect_equal(NA_character_ %|NA|% "foobar", "foobar")
  expect_equal("this" %|NA|% "notthis", "this")
})

test_that("chunk", {
  expect_equal(
    chunk(letters, 10),
    list(letters[1:10], letters[11:20], letters[21:26])
  )
  expect_equal(chunk(character(), 5), list())
  expect_equal(chunk(1:10, 10), list(1:10))
  expect_equal(chunk(1, 10), list(1))
})

test_that("mkdirp", {
  mkdirp(tmp <- tempfile())
  on.exit(unlink(tmp), add = TRUE)
  mkdirp(file.path(tmp, c("foo/bar", "foobar")))
  expect_true(file.exists(file.path(tmp, "foo/bar")))
  expect_true(file.exists(file.path(tmp, "foobar")))
})

test_that("read_file", {
  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)
  cnt <- paste(c(letters, "\ud020"), collapse = "|")
  writeBin(charToRaw(cnt), tmp)
  cnt2 <- read_file(tmp)
  expect_equal(cnt2, cnt)
})
