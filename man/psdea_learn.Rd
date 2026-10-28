\name{psdea_learn}
\alias{psdea_learn}
\alias{psdea_learn_data}
\title{Learn the reference set from the data}
\description{
Reconstructs each unit's bundle as a sparse non-negative combination of the
other units' bundles by penalised least squares, solved with cyclic coordinate
descent.  The support of the solution is the peer set.
}
\usage{
psdea_learn(Z, lambda = 0.05, maxit = 500L, tol = 1e-4)

psdea_learn_data(data, vars, lambda = 0.05, by = NULL)
}
\arguments{
  \item{Z}{matrix with units in the columns and standardised inputs and outputs
    in the rows.}
  \item{lambda}{penalty on the sum of the weights.  Larger values give sparser
    peer sets.}
  \item{maxit}{maximum number of coordinate-descent sweeps.}
  \item{tol}{a weight is treated as zero below this value when counting
    peers.}
  \item{data}{a data frame.}
  \item{vars}{names of the variables forming the bundle.}
  \item{by}{optional name of the period variable; the matrix is then built for
    each period and averaged.}
}
\value{
A row-normalised matrix of weights, with attributes \code{n_peers} and
\code{iters}.
}
\details{
The problem is a penalised non-negative reconstruction, not a convex-hull
representation: the weights are not constrained to sum to one and normalising
them afterwards does not change the optimisation problem.  The peer set is
chosen on the same observations that produce the scores, so the matrix is a
selection rule, not an estimate of a technology club.
}
\examples{
set.seed(1)
Z <- matrix(runif(40, 1, 2), 4, 10)
W <- psdea_learn(Z, lambda = 0.05)
attr(W, "n_peers")
}
