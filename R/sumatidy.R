#' Make a sorted frequency table for a factor
#'
#' @param x factor
#'
#' @return A tibble
#' @export
#' @examples
#'
#'
sumatidy <- function(base) {
  base %>%
  dplyr::mutate(ESO = 1)
}
