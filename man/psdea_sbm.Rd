\name{psdea_sbm}
\alias{psdea_sbm}
\title{Slacks-based measure for one cross-section}
\description{
Computes the slacks-based measure of Tone (2001) with undesirable outputs for
every column of a cross-section, optionally against the restricted reference
technology defined by a weight matrix.
}
\usage{
psdea_sbm(X, Y, B = NULL, vrs = FALSE, W = NULL)
}
\arguments{
  \item{X}{matrix of inputs, rows are inputs and columns are units.}
  \item{Y}{matrix of desirable outputs, same layout.}
  \item{B}{matrix of undesirable outputs, or \code{NULL}.}
  \item{vrs}{logical; variable rather than constant returns to scale.}
  \item{W}{optional square weight matrix; see \code{\link{psdea_panel}}.}
}
\value{
A list with \code{eff}, and, when \code{W} is given, \code{eff_loc},
\code{n_peers}, \code{tgr}, \code{s_local} and \code{s_gap}.
}
\examples{
X <- matrix(c(1, 1, 1), nrow = 1)
Y <- matrix(c(1, 2, 4), nrow = 1)
psdea_sbm(X, Y)$eff            # 0.25 0.50 1.00
W <- matrix(c(0, 1, 0,
              1, 0, 1,
              0, 1, 0), 3, 3, byrow = TRUE)
psdea_sbm(X, Y, W = W)$eff_loc # 0.50 1.00 1.00
}
\references{
Tone, K. (2004) Dealing with undesirable outputs in DEA: a slacks-based
measure approach. \emph{GRIPS Research Report} I-2003-0005.
}
