library(shiny)
library(testthat) # >= 3.0.0
library(shinytest)


test_that("as.vector() strips names", {
  x <- c(a = 1, b = 2)
  expect_equal(as.vector(x), c(1, 2))
})



complicated_object <- list(
  x = list(mtcars, iris),
  y = 10
)

expect_equal(complicated_object$y, 10)



f <- function() {
  stop("Calculation failed [location 1]")
}

# the second argument to expect_error() is a regular expression
expect_error(f(),  "Calculation failed")
