test_that("multiplication works", {
  vector = 1:10
  expect_equal(2+sum(vector),suma(vector))
})
