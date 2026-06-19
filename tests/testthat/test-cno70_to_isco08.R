context("test-cno70_to_isco08")

test_that("check ncols", {

  crossed_base <- toy_base_colombia_cno70 %>%
    cno70_to_isco08(., oficio = OFICIO)

  expect_equal(ncol(crossed_base), ncol(toy_base_colombia_cno70)+3)

})
