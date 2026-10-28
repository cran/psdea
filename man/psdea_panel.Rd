\name{psdea_panel}
\alias{psdea_panel}
\alias{print.psdea}
\alias{summary.psdea}
\title{Efficiency against an unrestricted and a restricted frontier}
\description{
Estimates a slacks-based measure with undesirable outputs for each period of a
panel, once against all units and, when a weight matrix is supplied, once
against the units selected by that matrix.  Returns the decomposed shortfall.
}
\usage{
psdea_panel(data, y, x, year, id = NULL, bad = NULL, W = NULL,
            rts = c("crs", "vrs"))

\method{print}{psdea}(x, ...)

\method{summary}{psdea}(object, ...)
}
\arguments{
  \item{data}{a data frame in long format, one row per unit and period.}
  \item{y}{name of the single desirable output.}
  \item{x}{for \code{psdea_panel}, a character vector with the names of the inputs; for the \code{print} method, the fitted object.}
  \item{year}{name of the period variable; one frontier is built per period.}
  \item{id}{name of the unit identifier.  When \code{NULL} the row order is
    used and a variable \code{.id} is created.}
  \item{bad}{optional character vector with the names of undesirable outputs.}
  \item{W}{optional square matrix of order equal to the number of units in a
    period.  A non-zero off-diagonal entry means that the column unit may enter
    the frontier of the row unit.  The unit itself is always included.}
  \item{rts}{either \code{"crs"} or \code{"vrs"}.}
  \item{object}{an object returned by \code{psdea_panel}.}
  \item{...}{further arguments, currently ignored.}
}
\value{
A data frame of class \code{psdea} with the columns \code{id}, \code{year},
\code{eff} (unrestricted score), \code{eff_loc} (restricted score),
\code{tgr} (their ratio), \code{s_local} and \code{s_gap} (the two shares of
the shortfall, missing when the unrestricted score is one) and \code{n_peers}
(the size of the reference set).
}
\details{
The shares are \eqn{(1-\rho^N)/(1-\rho^G)} and \eqn{(\rho^N-\rho^G)/(1-\rho^G)};
they sum to one and are undefined on the frontier, where the denominator is
zero.  They are not equal to \eqn{1-\mathrm{TGR}}.
}
\examples{
data(psdea_china_energy)
d <- subset(psdea_china_energy, year == 2015 & code <= 6)
W <- psdea_w_contiguity[1:6, 1:6]
fit <- psdea_panel(d, "gdp_real", c("capital", "energy"), "year",
                   id = "code", bad = "co2", W = W)
fit
fit$s_local + fit$s_gap
}
\seealso{\code{\link{psdea_spw}}, \code{\link{psdea_learn}}}
