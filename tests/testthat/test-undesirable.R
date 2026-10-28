test_that("undesirable outputs use the joint s+k normalisation", {
  ## one input, one desirable and one undesirable output, two units
  X <- matrix(c(1, 1), nrow = 1)
  Y <- matrix(c(1, 1), nrow = 1)
  B <- matrix(c(1, 2), nrow = 1)
  e <- psdea_sbm(X, Y, B)$eff
  ## unit 2 has twice the emissions of unit 1 for the same input and output,
  ## so it is the worse unit and must score below one
  expect_true(e[2] < e[1])
  expect_equal(e[1], 1, tolerance = 1e-8)
})

test_that("VRS scores are at least as large as CRS scores", {
  set.seed(11)
  X <- matrix(runif(30, 1, 3), 2, 15)
  Y <- matrix(runif(15, 1, 3), 1, 15)
  expect_true(all(psdea_sbm(X, Y, vrs = TRUE)$eff >= psdea_sbm(X, Y)$eff - 1e-8))
})

test_that("shares are NA exactly on the frontier", {
  X <- matrix(c(1, 2, 3, 4), nrow = 1)
  Y <- matrix(c(2, 3, 4, 8), nrow = 1)
  W <- matrix(0, 4, 4); W[1, 2] <- 1; W[2, 1] <- 1
  r <- psdea_sbm(X, Y, W = W)
  expect_true(all(is.na(r$s_local[abs(r$eff - 1) < 1e-8])))
  expect_true(all(!is.na(r$s_local[abs(r$eff - 1) >= 1e-8])))
})
