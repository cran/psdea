
d <- read.csv(file.path(Sys.getenv("PKGROOT"), "inst", "extdata", "psdea_china_energy.csv"),
              fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)
psdea_china_energy <- d
save(psdea_china_energy, file = file.path(Sys.getenv("PKGROOT"), "data", "psdea_china_energy.rda"), compress = "xz")
rd <- function(f) as.matrix(read.csv(file.path(Sys.getenv("PKGROOT"), "inst", "extdata", f), header = FALSE))
psdea_w_contiguity <- rd("psdea_w_contiguity.csv")
psdea_w_knn4 <- rd("psdea_w_knn4.csv")
psdea_w_distance <- rd("psdea_w_distance.csv")
save(psdea_w_contiguity, psdea_w_knn4, psdea_w_distance,
     file = file.path(Sys.getenv("PKGROOT"), "data", "psdea_weights.rda"), compress = "xz")
cat("rows", nrow(psdea_china_energy), "dims", dim(psdea_w_contiguity), "\n")
