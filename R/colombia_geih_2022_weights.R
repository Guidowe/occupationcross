#' Reference ISCO-08 distribution from Colombia 2022 GEIH (for weighted crosswalks).
#'
#' The empirical distribution of occupations in Colombia's \emph{Gran Encuesta
#' Integrada de Hogares} (GEIH) 2022, the first year DANE codes occupations
#' natively in CIUO-08 A.C. (the national adaptation of ISCO-08). It is used by the
#' \code{allocation = "weighted"} option of \code{\link{reclassify_to_isco08}} /
#' \code{\link{cno70_to_isco08}} to break the ambiguity of 2-digit CNO-SENA 1970
#' codes that map to several ISCO-08 codes, drawing proportional to how common each
#' ISCO-08 code actually is, instead of the default uniform draw.
#'
#' Built from the employed population (\code{OCI == 1}) by summing the survey
#' expansion factor \code{FEX_C18} within each 4-digit unit group. Only relative
#' magnitudes matter: the crosswalk normalises the weights within each origin
#' code's candidate set.
#'
#' @format A data frame with 446 rows and 2 variables:
#' \describe{
#'   \item{isco08.code}{ISCO-08 (CIUO-08 A.C.) 4-digit unit-group code}
#'   \item{weight}{Summed expansion factors (FEX_C18) of employed records in that unit group; relative weight}
#' }
#' @source Departamento Administrativo Nacional de Estadistica (DANE), Gran
#'   Encuesta Integrada de Hogares (GEIH) 2022.
#'   \url{https://microdatos.dane.gov.co/}
"colombia_geih_2022_weights"
