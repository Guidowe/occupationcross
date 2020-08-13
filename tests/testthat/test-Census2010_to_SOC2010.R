context("test-Census2010_to_SOC2010")

test_that("check ncols", {

  crossed_base <- toy_base_ipums_cps_2018 %>%
    census2010_to_soc2010(.,census = "OCC",code_titles = FALSE)

  expect_equal(ncol(crossed_base), ncol(toy_base_ipums_cps_2018)+1)

})
