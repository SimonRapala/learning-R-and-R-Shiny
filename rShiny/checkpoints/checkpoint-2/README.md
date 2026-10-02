# MetaWorks Shiny test suite

This test suite is designed for the current single-file Shiny application.
It does not require you to reorganize the app yet.

## Add it to the project

1. Keep the application code in `app.R`.
2. Copy this `tests` directory beside `app.R`.
3. Install the testing dependencies once:

```r
install.packages(c("testthat", "withr"))
```

## Run the tests

From the directory containing `app.R`, run:

```bash
Rscript tests/testthat.R
```

The tests use temporary directories. They do not create jobs inside the real
`project/jobs` directory.

## Coverage included

- Matching complete R1/R2 pairs.
- Reporting missing R1 and R2 files.
- Creating a timestamped job directory under a supplied root.
- Copying simulated Shiny uploads into a job's `inputs` directory.
- Errors for a missing job directory or missing uploaded source files.
- The server's Create Job flow and reactive job summary.

The suite intentionally does not test page appearance or click the download
button in a browser. Those are end-to-end interface tests and can be added with
`shinytest2` after the app's layout stabilizes.
