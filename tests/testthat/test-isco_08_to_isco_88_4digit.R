context("test-isco_08_to_isco_88_4digit")

test_that("check ncols", {

  crossed_base <- toy_base_piaac %>%
    isco08_to_isco88_4digit(.,isco = "ISCO08_C")

  expect_equal(ncol(crossed_base), ncol(toy_base_piaac)+1)

})
