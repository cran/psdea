test_that("the weight matrix is symmetric and named", {
  units <- c("A", "B", "C")
  W <- psdea_spw(c("A", "B"), c("B", "C"), units)
  expect_equal(dim(W), c(3, 3))
  expect_equal(rownames(W), units)
  expect_equal(unname(rowSums(W)), rep(1, 3))
  W0 <- psdea_spw(c("A", "B"), c("B", "C"), units, row_standardise = FALSE)
  expect_equal(W0[1, 2], W0[2, 1])
})

test_that("learned weights are non-negative and row-normalised", {
  set.seed(3)
  Z <- matrix(runif(50, 1, 2), 5, 10)
  W <- psdea_learn(Z, lambda = 0.05)
  expect_true(all(W >= 0))
  expect_equal(rowSums(W), rep(1, 10), tolerance = 1e-8)
  expect_equal(diag(W), rep(0, 10))
  expect_true(attr(W, "n_peers") > 0)
})

test_that("Moran's I is positive for a gradient", {
  x <- c(1, 2, 3, 4, 5)
  W <- psdea_spw(1:4, 2:5, 1:5)
  I <- psdea_moran(x, W, nperm = 99)
  expect_true(I["observed"] > 0)
  expect_true(I["p_value"] >= 0 && I["p_value"] <= 1)
})
