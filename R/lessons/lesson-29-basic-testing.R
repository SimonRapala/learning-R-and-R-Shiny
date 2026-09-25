validateMode <- function(mode) {
  mode <- tolower(mode)

  if (!(mode %in% c("success", "failure"))) {
    stop("Mode must be success or failure")
  }

  return(mode)
}
#Manual Testing
# validateMode("SUCCESS")
# validateMode("wrong")

testthat::test_that("validateMode returns lowercase mode", 
{
  testthat::expect_equal( validateMode("SUCCESS"), "success")

  testthat::expect_equal(validateMode("FAILURE"), "failure")
})

testthat::test_that("validateMode rejects invalid modes", 
{testthat::expect_error( validateMode("wrong"), "Mode must be success or failure")
})

testthat::test_that(desc = "Testing successes with mix of lower and uppercase",
code = {
  testthat::expect_equal(validateMode("failuRE"), expected = "failure")
  testthat::expect_equal(validateMode("SUCcEsS"), expected = "success")
}
)

testthat::test_that( desc = "These should pass as an error as they are not success or failure",
code = {
  testthat::expect_error(object = validateMode("cancel"), "Mode must be success or failure")
  testthat::expect_error(object = validateMode("STOP"), "Mode must be success or failure")
}

)