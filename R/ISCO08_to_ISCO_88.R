#' Cross ISCO 08 a ISCO 88
#'
#' @param base Dataframe from any survey including a variable with ISCO 08 codes
#' @param isco character vector containing ISCO 08 codes
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 88 codes
#' @export
#' @examples
#'
#' base_crossed <- isco08_to_isco88(toy_base_lfs,isco = "ISCO3D",summary = TRUE)
#'
isco08_to_isco88<- function(base,isco,summary = FALSE){

sample.isco <- function(df) {
    sample(df$`ISCO-88 code`,size = 1)
  }

cross_isco_3dig <- isco08_cross_isco88 %>%
  dplyr::mutate(
    ISCO3D = as.integer(stringr::str_sub(string = `ISCO 08 Code`,1,3))) %>%
  dplyr::add_row(ISCO3D = 999)

nested.data.isco.cross <- cross_isco_3dig %>%
  dplyr::select(ISCO3D,`ISCO-88 code`) %>%
  dplyr::group_by(ISCO3D) %>%
  tidyr::nest()

#ACA
base_lfs_join  <- base %>%
  dplyr::rename(ISCO3D = isco) %>%
  dplyr::left_join(nested.data.isco.cross,by = "ISCO3D")

set.seed(999971)

base_lfs_join_sample <- base_lfs_join %>%
  dplyr::mutate(ISCO.88 = purrr::map(data, sample.isco))  %>%
  dplyr::select(-data) %>% # Elimino la columna loca que había creado para el sorteo
  dplyr::mutate(ISCO.88 = as.numeric(ISCO.88))

return(base_lfs_join_sample)

if (summary==TRUE) {

summary_cross <<- base_lfs_join_sample %>%
  dplyr::group_by(ISCO3D,ISCO.88) %>%
  dplyr::summarise(Cases = dplyr::n())

}


}
