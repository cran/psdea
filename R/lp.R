## psdea -- two-phase revised simplex
##
## Solves   min c'x   subject to   A x = b,  x >= 0
## Returns the solution, the objective value, the number of pivots and a
## status code (0 = optimal, 1 = infeasible, 2 = iteration limit).

psdea_lp <- function(A, b, c, maxit = 20000L, tol = 1e-10) {
  A <- as.matrix(A); b <- as.numeric(b); c <- as.numeric(c)
  m <- nrow(A); n <- ncol(A)
  if (length(b) != m || length(c) != n) stop("dimension mismatch in A, b or c")
  flip <- b < 0
  if (any(flip)) { A[flip, ] <- -A[flip, , drop = FALSE]; b[flip] <- -b[flip] }
  T <- cbind(A, diag(m), b)
  basis <- (n + 1L):(n + m)
  ncol <- n + m
  cost <- c(rep(0, n), rep(1, m))
  simplex <- function(T, cost, basis, price_max) {
    it <- 0L
    repeat {
      it <- it + 1L
      if (it > maxit) return(list(T = T, basis = basis, it = it, status = 2L))
      cb <- cost[basis]
      d <- cost - as.vector(cb %*% T[, 1:ncol, drop = FALSE])
      cand <- which(d[1:price_max] < -tol)
      if (!length(cand)) return(list(T = T, basis = basis, it = it, status = 0L))
      j <- cand[1]
      col <- T[, j]
      rr <- which(col > tol)
      if (!length(rr)) return(list(T = T, basis = basis, it = it, status = 3L))
      rat <- T[rr, ncol + 1] / col[rr]
      mu <- min(rat)
      ties <- which(abs(rat - mu) < 1e-12)
      r <- if (length(ties) > 1) rr[ties[which.min(basis[rr[ties]])]] else rr[ties[1]]
      T[r, ] <- T[r, ] / T[r, j]
      cc <- T[, j]; cc[r] <- 0
      T <- T - cc %o% T[r, ]
      basis[r] <- j
    }
  }
  s1 <- simplex(T, cost, basis, ncol)
  T <- s1$T; basis <- s1$basis
  if (s1$status == 2L) return(list(x = rep(NA_real_, n), obj = NA_real_, it = s1$it, status = 2L))
  art <- sum(T[basis > n, ncol + 1])
  if (art > 1e-7) return(list(x = rep(NA_real_, n), obj = NA_real_, it = s1$it, status = 1L))
  keep <- rep(TRUE, m)
  for (k in seq_len(m)) {
    if (basis[k] > n) {
      cand <- which(abs(T[k, 1:n]) > 1e-9)
      if (length(cand)) {
        j <- cand[1]
        T[k, ] <- T[k, ] / T[k, j]
        cc <- T[, j]; cc[k] <- 0
        T <- T - cc %o% T[k, ]
        basis[k] <- j
      } else keep[k] <- FALSE
    }
  }
  T <- T[keep, , drop = FALSE]; basis <- basis[keep]
  cost2 <- c(c, rep(0, m))
  s2 <- simplex(T, cost2, basis, n)
  if (s2$status == 2L) return(list(x = rep(NA_real_, n), obj = NA_real_, it = s1$it + s2$it, status = 2L))
  x <- rep(0, n)
  for (k in seq_along(s2$basis)) if (s2$basis[k] <= n) x[s2$basis[k]] <- s2$T[k, ncol + 1]
  x[x < 0] <- 0
  list(x = x, obj = sum(c * x), it = s1$it + s2$it, status = 0L)
}
