test_that("the three-unit example matches the analytic values", {
  X <- matrix(c(1, 1, 1), nrow = 1)
  Y <- matrix(c(1, 2, 4), nrow = 1)
  expect_equal(psdea_sbm(X, Y)$eff, c(0.25, 0.5, 1), tolerance = 1e-8)
})

test_that("restricting the reference set gives the restricted score", {
  X <- matrix(c(1, 1, 1), nrow = 1)
  Y <- matrix(c(1, 2, 4), nrow = 1)
  W <- matrix(c(0, 1, 0,
                1, 0, 1,
                0, 1, 0), 3, 3, byrow = TRUE)
  r <- psdea_sbm(X, Y, W = W)
  expect_equal(r$eff_loc, c(0.5, 0.5, 1), tolerance = 1e-8)
  expect_equal(r$tgr, r$eff / r$eff_loc)
})

test_that("self-reference returns one and a complete matrix the global score", {
  X <- matrix(c(1, 2, 3, 4), nrow = 1)
  Y <- matrix(c(2, 4, 6, 8), nrow = 1)
  W0 <- matrix(0, 4, 4)
  expect_equal(psdea_sbm(X, Y, W = W0)$eff_loc, rep(1, 4), tolerance = 1e-8)
  W1 <- matrix(1, 4, 4); diag(W1) <- 0
  r <- psdea_sbm(X, Y, W = W1)
  expect_equal(r$eff_loc, r$eff, tolerance = 1e-8)
  expect_equal(r$tgr, rep(1, 4), tolerance = 1e-8)
})

test_that("only the pattern of the weights matters", {
  X <- matrix(c(1, 2, 3, 4), nrow = 1)
  Y <- matrix(c(3, 4, 6, 9), nrow = 1)
  W <- matrix(c(0, 1, 1, 0,
                1, 0, 0, 0,
                1, 0, 0, 1,
                0, 0, 1, 0), 4, 4, byrow = TRUE)
  set.seed(1)
  W2 <- W * matrix(runif(16, 0.5, 2), 4, 4)
  expect_equal(psdea_sbm(X, Y, W = W)$eff_loc,
               psdea_sbm(X, Y, W = W2)$eff_loc, tolerance = 1e-10)
})

test_that("enlarging the reference set never raises a score", {
  set.seed(42)
  X <- matrix(runif(60, 1, 3), 3, 20)
  Y <- matrix(runif(20, 1, 3), 1, 20)
  W <- matrix(0, 20, 20)
  for (i in 1:20) W[i, sample(setdiff(1:20, i), 2)] <- 1
  base <- psdea_sbm(X, Y, W = W)$eff_loc
  W2 <- W; W2[1, 3] <- 1; W2[3, 1] <- 1
  expect_true(all(psdea_sbm(X, Y, W = W2)$eff_loc <= base + 1e-8))
})

test_that("scores are invariant to units and to the order of the units", {
  set.seed(7)
  X <- matrix(runif(40, 1, 3), 2, 20)
  Y <- matrix(runif(20, 1, 3), 1, 20)
  e1 <- psdea_sbm(X, Y)$eff
  e2 <- psdea_sbm(X * c(1000, 1), Y)$eff
  expect_equal(e1, e2, tolerance = 1e-8)
  p <- sample(20)
  e3 <- psdea_sbm(X[, p], Y[, p])$eff
  expect_equal(e1[p], e3, tolerance = 1e-8)
})

test_that("shares sum to one and are missing on the frontier", {
  X <- matrix(c(1, 2, 3, 4), nrow = 1)
  Y <- matrix(c(2, 3, 4, 8), nrow = 1)
  W <- matrix(c(0, 1, 1, 0,
                1, 0, 0, 0,
                1, 0, 0, 1,
                0, 0, 1, 0), 4, 4, byrow = TRUE)
  r <- psdea_sbm(X, Y, W = W)
  s <- r$s_local + r$s_gap
  expect_equal(s[!is.na(s)], rep(1, sum(!is.na(s))), tolerance = 1e-8)
})
