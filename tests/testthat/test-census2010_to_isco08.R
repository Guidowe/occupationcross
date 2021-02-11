context("test-census2010_to_isco08")

test_that("check ncols", {

  crossed_base <- toy_base_ipums_cps_2018 %>%
    census2010_to_isco08(.,census = "OCC")

  expect_equal(ncol(crossed_base), ncol(toy_base_ipums_cps_2018)+3)

})
