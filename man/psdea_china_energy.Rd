\name{psdea_china_energy}
\alias{psdea_china_energy}
\docType{data}
\title{Provincial panel of China, 2003--2024}
\description{
A panel of 30 Chinese provinces with the inputs, output and undesirable output
used in the article.  Energy, carbon dioxide and gross domestic product for
2023 and 2024 are provisional; the columns whose names begin with
\code{flag_} record whether a value is observed, official or nowcast.
}
\format{
A data frame with 660 rows and 22 variables.  The variables used in the
examples are \code{code} (1--30, matching the weight matrices), \code{prov},
\code{year}, \code{energy} (10\,000 tonnes of coal equivalent), \code{capital}
(100 million yuan at constant 2003 prices), \code{gdp_real} (same units) and
\code{co2} (million tonnes).
}
\source{
Provincial statistical yearbooks and the CEADs emission inventory.
}
\examples{
data(psdea_china_energy)
str(psdea_china_energy[1:5, c("prov", "year", "energy", "gdp_real")])
}
