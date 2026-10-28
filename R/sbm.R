## psdea -- slacks-based measure with undesirable outputs

## One decision-making unit.  X is m x n, Y is s x n, B is k x n with the
## reference units in the columns; x0, y0, b0 are the evaluated unit.
psdea_sbm1 <- function(X, Y, B, x0, y0, b0, vrs = FALSE) {
  X <- as.matrix(X); Y <- as.matrix(Y)
  B <- if (is.null(B) || length(B) == 0) matrix(0, 0, ncol(X)) else as.matrix(B)
  m <- nrow(X); s <- nrow(Y); k <- nrow(B); n <- ncol(X)
  nv <- n + m + s + k + 1L
  nr <- 1L + m + s + k + as.integer(vrs)
  A <- matrix(0, nr, nv); rhs <- numeric(nr)
  sk <- max(s + k, 1L)
  if (s > 0) A[1, (n + m + 1):(n + m + s)] <- 1 / (sk * as.numeric(y0))
  if (k > 0) A[1, (n + m + s + 1):(n + m + s + k)] <- 1 / (sk * as.numeric(b0))
  A[1, nv] <- 1; rhs[1] <- 1
  for (i in seq_len(m)) { A[1 + i, 1:n] <- X[i, ]; A[1 + i, n + i] <- 1; A[1 + i, nv] <- -x0[i] }
  for (r in seq_len(s)) {
    A[1 + m + r, 1:n] <- -Y[r, ]; A[1 + m + r, n + m + r] <- 1; A[1 + m + r, nv] <- y0[r]
  }
  for (q in seq_len(k)) {
    A[1 + m + s + q, 1:n] <- B[q, ]; A[1 + m + s + q, n + m + s + q] <- 1
    A[1 + m + s + q, nv] <- -b0[q]
  }
  if (vrs) { A[nr, 1:n] <- 1; A[nr, nv] <- -1 }
  cc <- numeric(nv)
  cc[(n + 1):(n + m)] <- -1 / (m * as.numeric(x0))
  cc[nv] <- 1
  out <- psdea_lp(A, rhs, cc)
  if (out$status != 0L) NA_real_ else out$obj
}

## All units of one cross-section.
## W: optional n x n matrix; its non-zero off-diagonal entries define peers.
## The diagonal is always included (see the paper, equation 3).
psdea_sbm <- function(X, Y, B = NULL, vrs = FALSE, W = NULL) {
  X <- as.matrix(X)
  if (is.null(dim(Y))) Y <- matrix(Y, nrow = 1) else Y <- as.matrix(Y)
  n <- ncol(X)
  if (is.null(B) || length(B) == 0) {
    B <- matrix(0, 0, n)
  } else {
    if (is.null(dim(B))) B <- matrix(B, nrow = 1) else B <- as.matrix(B)
  }
  ## scale by column means: SBM is invariant, the tableau is better conditioned
  Xs <- X / rowMeans(X)
  Ys <- if (nrow(Y)) Y / mean(Y) else Y
  Bs <- if (nrow(B)) B / mean(B) else B
  eff <- vapply(seq_len(n), function(i)
    psdea_sbm1(Xs, Ys, Bs, Xs[, i], Ys[, i], Bs[, i], vrs), numeric(1))
  out <- list(eff = eff, eff_loc = NULL, n_peers = NULL, tgr = NULL,
              s_local = NULL, s_gap = NULL)
  if (!is.null(W)) {
    W <- as.matrix(W)
    if (nrow(W) != n || ncol(W) != n) stop("W must be n x n, n = number of units")
    M <- (W != 0) | diag(n) > 0
    el <- vapply(seq_len(n), function(i) {
      keep <- M[i, ]
      psdea_sbm1(Xs[, keep, drop = FALSE], Ys[, keep, drop = FALSE],
                 Bs[, keep, drop = FALSE], Xs[, i], Ys[, i], Bs[, i], vrs)
    }, numeric(1))
    out$eff_loc <- el
    out$n_peers <- rowSums(M)
    out$tgr <- eff / el
    gap <- 1 - eff
    out$s_local <- ifelse(gap > 1e-9, (1 - el) / gap, NA_real_)
    out$s_gap <- ifelse(gap > 1e-9, (el - eff) / gap, NA_real_)
  }
  out
}

## Panel driver: one frontier per year.
psdea_panel <- function(data, y, x, year, id = NULL, bad = NULL,
                        W = NULL, rts = c("crs", "vrs")) {
  rts <- match.arg(rts)
  stopifnot(is.data.frame(data))
  yv <- data[[y]]; if (is.null(yv)) stop("variable ", y, " not found")
  if (is.null(id)) { data$.id <- seq_len(nrow(data)); id <- ".id" }
  yrs <- sort(unique(data[[year]]))
  out <- data.frame(id = data[[id]], year = data[[year]],
                    eff = NA_real_, eff_loc = NA_real_, tgr = NA_real_,
                    s_local = NA_real_, s_gap = NA_real_, n_peers = NA_integer_)
  if (anyDuplicated(paste(data[[id]], data[[year]]))) stop("duplicated id-year combinations")
  for (ty in yrs) {
    ix <- which(data[[year]] == ty)
    ids <- as.character(data[[id]][ix])
    Wi <- W
    if (!is.null(W)) {
      if (!is.null(rownames(W))) {
        pos <- match(ids, rownames(W))
        if (anyNA(pos)) stop("units in the data are not in the weight matrix")
        Wi <- W[pos, pos, drop = FALSE]
      } else if (nrow(W) != length(ix)) {
        stop("the weight matrix does not match the number of units in ", ty)
      }
    }
    X <- t(as.matrix(data[ix, x, drop = FALSE]))
    Y <- t(as.matrix(data[ix, y, drop = FALSE]))
    B <- if (is.null(bad)) matrix(0, 0, length(ix)) else t(as.matrix(data[ix, bad, drop = FALSE]))
    r <- psdea_sbm(X, Y, B, vrs = rts == "vrs", W = Wi)
    out$eff[ix] <- r$eff
    if (!is.null(W)) {
      out$eff_loc[ix] <- r$eff_loc
      out$tgr[ix] <- r$tgr
      out$s_local[ix] <- r$s_local
      out$s_gap[ix] <- r$s_gap
      out$n_peers[ix] <- r$n_peers
    }
  }
  attr(out, "rts") <- rts
  attr(out, "W") <- W
  structure(out, class = c("psdea", "data.frame"))
}

print.psdea <- function(x, ...) {
  cat("\nReference-set DEA\n")
  cat("  observations :", nrow(x), "\n")
  cat("  returns      :", attr(x, "rts"), "\n")
  cat("  mean eff (unrestricted):", format(mean(x$eff, na.rm = TRUE), digits = 4), "\n")
  if (!is.null(x$eff_loc)) {
    cat("  mean eff (restricted)  :", format(mean(x$eff_loc, na.rm = TRUE), digits = 4), "\n")
    cat("  mean gap ratio         :", format(mean(x$tgr, na.rm = TRUE), digits = 4), "\n")
    cat("  mean local share       :", format(mean(x$s_local, na.rm = TRUE), digits = 4), "\n")
  }
  cat("  units on the frontier  :", sum(abs(x$eff - 1) < 1e-9), "\n")
  invisible(x)
}

summary.psdea <- function(object, ...) {
  out <- list(
    n = nrow(object),
    eff = summary(object$eff),
    eff_loc = if (is.null(object$eff_loc)) NULL else summary(object$eff_loc),
    tgr = if (is.null(object$tgr)) NULL else summary(object$tgr),
    s_local = if (is.null(object$s_local)) NULL else summary(object$s_local),
    n_peers = if (is.null(object$n_peers)) NULL else summary(object$n_peers)
  )
  class(out) <- "summary.psdea"
  out
}
