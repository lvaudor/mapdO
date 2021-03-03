context("Get data and labels regarding profiles")
library(mapdO)
library(testthat)
setwd("/data/user/v/lvaudor/zPublish/shiny/mapdO")
test_that("Get_datapath() returns a path towards an existing file when metric exists", {
  expect_true(file.exists(get_datapath("AX0005","Profil en long")))
  expect_error(get_data("AX0005","POUETPOUET"), "There is no datafile for this.")
})

test_that("Get_data() returns a tibble for proper datafile", {
  expect_true(dplyr::is.tbl(get_data("AX0005","Profil en long")))
  expect_error(get_data("AX0005","POUETPOUET"), "There is no datafile for this.")
})

test_that("Get_info() returns a list of length 2",{
  expect_true(is.list(get_info("AX0005","Profil en long")))
  expect_true(length(get_info("AX0005","Profil en long"))==2)
})


context("Plot profiles")
test_that("plot_profiles() returns a ggplot object",{
  p=plot_profiles(info=get_info(axis="AX0005", y="Profil en long"))
  expect_true("gg" %in% class(p))
})