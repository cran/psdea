\name{psdea_w_contiguity}
\alias{psdea_w_contiguity}
\alias{psdea_w_knn4}
\alias{psdea_w_distance}
\docType{data}
\title{Spatial weight matrices for the Chinese provinces}
\description{
Matrices of order 30 used in the article: land-border contiguity (65 links plus
one for Hainan), four nearest neighbours, and inverse distance with a median
cut-off.  Rows and columns follow the province code.
}
\format{A 30 by 30 numeric matrix, row-standardised.}
\source{Own construction from provincial boundaries and capital coordinates.}
\examples{
data(psdea_w_contiguity)
table(rowSums(psdea_w_contiguity > 0))
}
