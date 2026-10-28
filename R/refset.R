## psdea -- building and learning the reference set

## Weight matrix from a long table of links.
psdea_spw <- function(from, to, units, row_standardise = TRUE, directed = FALSE) {
  units <- as.character(units)
  n <- length(units)
  W <- matrix(0, n, n, dimnames = list(units, units))
  fi <- match(as.character(from), units)
  ti <- match(as.character(to), units)
  ok <- !is.na(fi) & !is.na(ti)
  W[cbind(fi[ok], ti[ok])] <- 1
  if (!directed) W <- pmax(W, t(W))
  if (row_standardise) {
    rs <- rowSums(W); rs[rs == 0] <- 1
    W <- W / rs
  }
  W
}

## Read an N x N matrix from a comma-separated file without header.
psdea_spw_read <- function(file, units = NULL, row_standardise = TRUE) {
  W <- as.matrix(read.csv(file, header = FALSE))
  if (!is.null(units)) {
    if (nrow(W) != length(units)) stop("matrix rows do not match the number of units")
    dimnames(W) <- list(units, units)
  }
  if (row_standardise) {
    rs <- rowSums(W); rs[rs == 0] <- 1
    W <- W / rs
  }
  W
}

## Sparse non-negative reconstruction of each unit's bundle.
psdea_learn <- function(Z, lambda = 0.05, maxit = 500L, tol = 1e-4) {
  Z <- as.matrix(Z)
  p <- nrow(Z); n <- ncol(Z)
  W <- matrix(0, n, n)
  iters <- integer(n)
  gram <- colSums(Z^2)
  for (i in seq_len(n)) {
    y <- Z[, i]
    w <- numeric(n)
    for (it in seq_len(maxit)) {
      delta <- 0
      Zw <- as.vector(Z %*% w)
      for (j in seq_len(n)) {
        if (j == i) next
        r <- y - Zw + w[j] * Z[, j]
        new <- max(0, (sum(Z[, j] * r) - lambda / 2) / gram[j])
        delta <- max(delta, abs(new - w[j]))
        w[j] <- new
        Zw <- as.vector(Z %*% w)
      }
      if (delta < 1e-6) break
    }
    iters[i] <- it
    W[i, ] <- w
  }
  W[W < tol] <- 0
  rs <- rowSums(W); rs[rs == 0] <- 1
  W <- W / rs
  attr(W, "n_peers") <- mean(rowSums(W > 0))
  attr(W, "threshold") <- tol
  attr(W, "iters") <- mean(iters)
  W
}

## Wrapper that builds the bundle from a data frame, optionally by period.
psdea_learn_data <- function(data, vars, lambda = 0.05, by = NULL) {
  if (is.null(by)) {
    Z <- t(as.matrix(data[, vars, drop = FALSE]))
    Z <- Z / rowMeans(Z)
    return(psdea_learn(Z, lambda))
  }
  Ws <- lapply(sort(unique(data[[by]])), function(g) {
    d <- data[data[[by]] == g, , drop = FALSE]
    Z <- t(as.matrix(d[, vars, drop = FALSE])); Z <- Z / rowMeans(Z)
    psdea_learn(Z, lambda)
  })
  W <- Reduce("+", Ws) / length(Ws)
  W[W < 1e-4] <- 0
  rs <- rowSums(W); rs[rs == 0] <- 1
  W <- W / rs
  attr(W, "n_peers") <- mean(rowSums(W > 0))
  W
}
