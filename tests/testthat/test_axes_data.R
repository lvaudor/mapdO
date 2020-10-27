context("read axes data")
library(mapdO)
setwd("/data/user/v/lvaudor/zPublish/shiny/mapdO")
test_that("get_data() works", {
  #output_ok=
  expect_true(file.exists(get_datapath(1,"Profil en long (m)")))
  expect_true(dplyr::is.tbl(get_data(1,"Profil en long (m)")))
  #sexpect_error(get_data(1,"POUETPOUET"), "There is no datafile for this.")
})
test_that("ok",{expect_is(1,"numeric")})
