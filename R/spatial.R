## psdea -- spatial autocorrelation diagnostics

## Moran's I with a permutation p-value.
psdea_moran <- function(x, W, nperm = 499L, seed = 1L) {
  x <- as.numeric(x); n <- length(x)
  W <- as.matrix(W)
  if (nrow(W) != n) stop("W does not match the length of x")
  Ws <- W / pmax(rowSums(W), 1e-300)
  diag(Ws) <- 0
  s0 <- sum(Ws)
  z <- x - mean(x)
  I <- (n / s0) * as.numeric(crossprod(z, Ws %*% z)) / sum(z^2)
  set.seed(seed)
  cnt <- 0
  for (b in seq_len(nperm)) {
    zp <- z[sample.int(n)]
    Ip <- (n / s0) * as.numeric(crossprod(zp, Ws %*% zp)) / sum(zp^2)
    if (Ip >= I) cnt <- cnt + 1
  }
  c(observed = I, p_value = (cnt + 1) / (nperm + 1))
}

## Local indicators with conditional permutation p-values.
psdea_lisa <- function(x, W, nperm = 499L, seed = 1L) {
  x <- as.numeric(x); n <- length(x)
  W <- as.matrix(W)
  Ws <- W / pmax(rowSums(W), 1e-300)
  diag(Ws) <- 0
  m2 <- sum((x - mean(x))^2) / n
  z <- x - mean(x)
  Ii <- z * as.numeric(Ws %*% z) / m2
  set.seed(seed)
  p <- numeric(n)
  for (i in seq_len(n)) {
    others <- setdiff(seq_len(n), i)
    cnt <- 0
    for (b in seq_len(nperm)) {
      zp <- z
      zp[others] <- z[sample(others)]
      if (z[i] * sum(Ws[i, ] * zp) / m2 >= Ii[i]) cnt <- cnt + 1
    }
    p[i] <- (cnt + 1) / (nperm + 1)
  }
  nm <- names(x)
  if (is.null(nm)) nm <- as.character(seq_len(n))
  data.frame(unit = nm, local_i = Ii, p_value = p, stringsAsFactors = FALSE)
}
