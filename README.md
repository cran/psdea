# psdea

Reference-set data envelopment analysis for panel data.

An efficiency score is a distance to a frontier, and the frontier is built from
peers.  `psdea` makes the peer set an argument: a weight matrix, supplied by
the user or learned from the data, selects which units may enter each unit's
frontier.  The package returns the unrestricted and the restricted score, their
ratio, and an exact split of the shortfall.

## Install

    R CMD INSTALL psdea_1.0.0.tar.gz

## Use

    library(psdea)
    data(psdea_china_energy); data(psdea_w_contiguity)
    d <- subset(psdea_china_energy, year <= 2022)
    fit <- psdea_panel(d, "gdp_real", c("capital", "energy"), "year",
                       id = "code", bad = "co2", W = psdea_w_contiguity)
    fit

## Design

- Only the pattern of the matrix is used; weights are read as indicators.
- The unit itself is always in its own reference set.
- Shares are `NA` on the frontier rather than zero.
- No compiled code, no dependencies outside base R.
