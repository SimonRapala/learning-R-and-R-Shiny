test_that("a timestamped job directory is created under the supplied root", {
  temporaryRoot <- withr::local_tempdir(
    pattern = "metaworks-directory-test-"
  )

  jobPath <- createJobsDir(temporaryRoot)

  expect_true(dir.exists(jobPath))
  expect_equal(
    dirname(jobPath),
    file.path(
      temporaryRoot,
      "project",
      "jobs"
    )
  )
  expect_match(
    basename(jobPath),
    "^MW-[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}$"
  )
})
