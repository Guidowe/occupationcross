#' Random sample of cases from Colombia 2024 GEIH (CNO based on CIUO-08 / ISCO-08).
#'
#' A dataset containing random cases from the Colombian \emph{Gran Encuesta
#' Integrada de Hogares} (GEIH) 2024, restricted to the employed population,
#' with a selection of 12 variables. The occupation variable \code{OFICIO_C8}
#' is coded with the Colombian CNO based on the \emph{Clasificacion Internacional
#' Uniforme de Ocupaciones} adaptada para Colombia (CIUO-08 A.C.), the national
#' adaptation of ISCO-08, at the 4-digit unit-group level. This is the ISCO-08
#' era counterpart of \code{\link{toy_base_colombia_cno70}} (CNO-SENA 1970 /
#' ISCO-68).
#'
#' @format A data frame with 2000 rows and 12 variables:
#' \describe{
#'   \item{OFICIO_C8}{Occupation code, CNO based on CIUO-08 A.C. (ISCO-08 4-digit unit group)}
#'   \item{RAMA2D_R4}{Branch of economic activity (CIIU Rev. 4, 2-digit)}
#'   \item{P3271}{Sex (1 = male, 2 = female)}
#'   \item{P6040}{Age in completed years}
#'   \item{P3042}{Highest level of education attained}
#'   \item{P6800}{Hours usually worked per week}
#'   \item{INGLABO}{Monthly labour income}
#'   \item{OCI}{Employed indicator (equals 1 for every record)}
#'   \item{AREA}{Metropolitan area code}
#'   \item{DPTO}{Department code}
#'   \item{MES}{Survey month}
#'   \item{FEX_C18}{Survey expansion factor (weight)}
#' }
#' @source Departamento Administrativo Nacional de Estadistica (DANE), Gran
#'   Encuesta Integrada de Hogares (GEIH) 2024.
#'   \url{https://microdatos.dane.gov.co/}
"toy_base_colombia_ciuo08"
