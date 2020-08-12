#' Cross ISCO 08 a ISCO 88
#'
#' @param base Dataframe from survey which includes ISCO 08 codes
#' @param isco Vector with isco 08 codes
#'
#' @return Dataframe adding a new variable with crosswalk to ISCO88
#' @export
#' @examples
isco08_to_isco88<- function(base,isco,summary = F){
cross_isco_3dig <- isco08_cross_isco88 %>%
  dplyr::mutate(
    ISCO3D = as.integer(stringr::str_sub(string = `ISCO 08 Code`,1,3))) %>%
  dplyr::add_row(ISCO3D = 999)
}
