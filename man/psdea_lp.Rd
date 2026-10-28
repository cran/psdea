\name{psdea_lp}
\alias{psdea_lp}
\title{Two-phase revised simplex}
\description{
Solves \eqn{\min c'x} subject to \eqn{Ax=b} and \eqn{x\ge 0} with a two-phase
revised simplex and Bland's rule for pricing.
}
\usage{
psdea_lp(A, b, c, maxit = 20000L, tol = 1e-10)
}
\arguments{
  \item{A}{constraint matrix, \eqn{m \times n}.}
  \item{b}{right-hand side, length \eqn{m}.}
  \item{c}{objective coefficients, length \eqn{n}.}
  \item{maxit}{maximum number of pivots.}
  \item{tol}{tolerance used in the pricing and ratio tests.}
}
\value{
A list with \code{x} (the solution), \code{obj}, \code{it} (pivots) and
\code{status}: 0 optimal, 1 infeasible, 2 iteration limit reached.
}
\examples{
A <- matrix(c(1, 2, -1, 0,
              3, 1,  0, -1), 2, 4, byrow = TRUE)
psdea_lp(A, c(4, 6), c(1, 1, 0, 0))$obj   # 2.8
}
