\name{psdea-package}
\alias{psdea-package}
\alias{psdea}
\docType{package}
\title{Data Envelopment Analysis with User-Defined and Learned Reference Sets}
\description{
Slacks-based data envelopment analysis for panel data in which the reference
set is an explicit argument.  A weight matrix, supplied by the user or learned
from the data, selects the units that may enter each decision-making unit's
frontier.  The package reports the unrestricted and the restricted score, the
ratio of the two, and an exact decomposition of the shortfall into the part the
restricted technology can remove and the part it cannot.
}
\details{
The main function is \code{\link{psdea_panel}}.  Weight matrices are built with
\code{\link{psdea_spw}} or learned with \code{\link{psdea_learn}}; scores can be
inspected with \code{\link{psdea_moran}}.  Every linear program is solved by a
two-phase revised simplex implemented in R (\code{\link{psdea_lp}}), so the
package has no compiled code and no dependencies beyond base R.
}
\references{
Tone, K. (2001) A slacks-based measure of efficiency in data envelopment
analysis. \emph{European Journal of Operational Research} 130, 498--509.
}
\keyword{package}
