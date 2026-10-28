test_that("the panel matches the matrix by identifier, not by row order", {
  set.seed(5)
  n <- 6
  d <- data.frame(id = rep(1:n, 2), year = rep(1:2, each = n),
                  y = runif(2 * n, 1, 3), x = runif(2 * n, 1, 3))
  W <- matrix(0, n, n)
  for (i in 1:n) W[i, ifelse(i < n, i + 1, 1)] <- 1
  rownames(W) <- colnames(W) <- as.character(1:n)
  a <- psdea_panel(d, "y", "x", "year", id = "id", W = W)
  d2 <- d[sample(nrow(d)), ]
  b <- psdea_panel(d2, "y", "x", "year", id = "id", W = W)
  a <- a[order(a$id, a$year), ]; b <- b[order(b$id, b$year), ]
  expect_equal(a$eff_loc, b$eff_loc, tolerance = 1e-10)
  expect_equal(a$eff, b$eff, tolerance = 1e-10)
})

test_that("duplicated id-year combinations are refused", {
  d <- data.frame(id = c(1, 1), year = c(1, 1), y = c(1, 2), x = c(1, 1))
  expect_error(psdea_panel(d, "y", "x", "year", id = "id"))
})
