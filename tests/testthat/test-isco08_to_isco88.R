test_that("check ncols", {

  crossed_base <- toy_base_lfs %>%
    isco08_to_isco88(.,isco = "ISCO3D")

  expect_equal(ncol(crossed_base), ncol(toy_base_lfs)+1)

  })
