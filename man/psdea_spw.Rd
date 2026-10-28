\name{psdea_spw}
\alias{psdea_spw}
\alias{psdea_spw_read}
\title{Build a weight matrix}
\description{
Builds a square weight matrix from a table of links, or reads one from a
comma-separated file.  The matrix is used only through its non-zero pattern.
}
\usage{
psdea_spw(from, to, units, row_standardise = TRUE, directed = FALSE)

psdea_spw_read(file, units = NULL, row_standardise = TRUE)
}
\arguments{
  \item{from, to}{vectors of unit names or indices giving the links.}
  \item{units}{character vector with the unit names, in the order used by the
    data; the row and column names of the result follow this order.}
  \item{row_standardise}{logical; divide each row by its sum.}
  \item{directed}{logical; if \code{FALSE} the links are made symmetric.}
  \item{file}{path to a comma-separated file without header.}
}
\value{
A numeric matrix with row and column names \code{units}.
}
\examples{
units <- c("A", "B", "C")
psdea_spw(c("A", "B"), c("B", "C"), units)
}
