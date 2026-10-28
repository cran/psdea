test_that("the simplex solves a small program", {
  A <- matrix(c(1, 2, -1, 0,
                3, 1,  0, -1), 2, 4, byrow = TRUE)
  out <- psdea_lp(A, c(4, 6), c(1, 1, 0, 0))
  expect_equal(out$status, 0L)
  expect_equal(out$obj, 2.8, tolerance = 1e-8)
  expect_equal(out$x[1:2], c(1.6, 1.2), tolerance = 1e-8)
})
