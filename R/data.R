## psdea -- data documentation

#' Provincial panel of China, 2003-2024
#'
#' A panel of 30 Chinese provinces with the inputs, output and undesirable
#' output used in the article.  Energy, carbon dioxide and gross domestic
#' product for 2023 and 2024 are provisional; the flag columns record whether a
#' value is observed, official or nowcast.
#'
#' @format A data frame with 660 rows and 22 variables.
#' @source Provincial statistical yearbooks and the CEADs emission inventory.
"psdea_china_energy" <- NULL

#' Spatial weight matrices
#'
#' Matrices of order 30 used in the article: contiguity (land borders, 65 links
#' plus one for Hainan), four nearest neighbours and inverse distance with a
#' median cut-off.  Rows and columns follow the province code.
#'
#' @format A 30 by 30 numeric matrix.
#' @source Own construction from provincial boundaries and capital coordinates.
"psdea_w_contiguity" <- NULL

#' @rdname psdea_w_contiguity
"psdea_w_knn4" <- NULL

#' @rdname psdea_w_contiguity
"psdea_w_distance" <- NULL
