library(testthat)
library(courserafarsfg1)

test_that("check make_filename function", {

  make_filename <- function(year) {
    year <- as.integer(year)
    sprintf("accident_%d.csv.bz2", year)
  }

  expect_that(make_filename(2010), equals("accident_2010.csv.bz2"))
  expect_equal(make_filename(2013.4), "accident_2013.csv.bz2")
} )
