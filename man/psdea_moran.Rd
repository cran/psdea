\name{psdea_moran}
\alias{psdea_moran}
\alias{psdea_lisa}
\title{Spatial autocorrelation diagnostics}
\description{
Moran's \eqn{I} and local indicators of spatial association for a vector of
scores, with permutation inference.  These are diagnostics: \eqn{I} is the
slope of the spatial lag on the score, not a share of variance.
}
\usage{
psdea_moran(x, W, nperm = 499L, seed = 1L)

psdea_lisa(x, W, nperm = 499L, seed = 1L)
}
\arguments{
  \item{x}{numeric vector of scores, one per unit.}
  \item{W}{square weight matrix.}
  \item{nperm}{number of permutations.}
  \item{seed}{seed for the permutations.}
}
\value{
\code{psdea_moran} returns a named vector with the observed statistic and its
p-value; \code{psdea_lisa} returns a data frame with the local statistic and
its conditional p-value for each unit.
}
\examples{
x <- c(1, 2, 3, 4)
W <- psdea_spw(c(1, 2, 3), c(2, 3, 4), 1:4)
psdea_moran(x, W, nperm = 99)
}
