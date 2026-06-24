context("test-cno70_to_isco08")

test_that("check ncols", {

  crossed_base <- toy_base_colombia_cno70 %>%
    cno70_to_isco08(., oficio = OFICIO)

  expect_equal(ncol(crossed_base), ncol(toy_base_colombia_cno70)+3)

})

test_that("weighted allocation changes the result", {

  u <- as.character(cno70_to_isco08(toy_base_colombia_cno70, oficio = OFICIO)$ISCO.08)
  w <- as.character(suppressMessages(
    cno70_to_isco08(toy_base_colombia_cno70, oficio = OFICIO, allocation = "weighted"))$ISCO.08)

  expect_false(isTRUE(all.equal(u, w)))

})