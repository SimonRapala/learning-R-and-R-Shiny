createRunDirectory <- function(
  jobsRoot,
  runID
) {
  if (!dir.exists(jobsRoot)) {
    stop("Jobs root does not exist")
  }

  runPath <- file.path(
    jobsRoot,
    runID
  )

  if (dir.exists(runPath)) {
    stop("Run ID already exists")
  }

  dir.create(runPath)

  return(runPath)
}


testthat::test_that(
  desc = "run directory is created inside the supplied root",
  code = {
    temporaryJobsRoot <- withr::local_tempdir(
      pattern = "fake-jobs-"
    )

    runPath <- createRunDirectory(
      jobsRoot = temporaryJobsRoot,
      runID = "MW-2026-TEST"
    )

    testthat::expect_true(
      dir.exists(runPath)
    )

    testthat::expect_equal(
      basename(runPath),
      "MW-2026-TEST"
    )

    testthat::expect_equal(
      dirname(runPath),
      temporaryJobsRoot
    )

  }
)