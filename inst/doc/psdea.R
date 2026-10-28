## -----------------------------------------------------------------------------
library(psdea)
X <- matrix(c(1, 1, 1), nrow = 1)
Y <- matrix(c(1, 2, 4), nrow = 1)
round(psdea_sbm(X, Y)$eff, 4)

## -----------------------------------------------------------------------------
W <- matrix(c(0, 1, 0,
              1, 0, 1,
              0, 1, 0), 3, 3, byrow = TRUE)
round(psdea_sbm(X, Y, W = W)$eff_loc, 4)

## -----------------------------------------------------------------------------
data(psdea_china_energy)
d <- subset(psdea_china_energy, year == 2015 & code <= 8)
W <- psdea_w_contiguity[1:8, 1:8]
fit <- psdea_panel(d, "gdp_real", c("capital", "energy"), "year",
                   id = "code", bad = "co2", W = W)
fit

## -----------------------------------------------------------------------------
fit[, c("eff", "eff_loc", "s_local", "s_gap")]

## -----------------------------------------------------------------------------
Wl <- psdea_learn_data(d, c("capital", "energy", "gdp_real"), lambda = 0.05, by = "year")
attr(Wl, "n_peers")
fit_l <- psdea_panel(d, "gdp_real", c("capital", "energy"), "year",
                     id = "code", bad = "co2", W = Wl)
mean(fit_l$tgr, na.rm = TRUE)

