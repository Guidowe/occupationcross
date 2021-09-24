#' Cross ISCO 08 a ISCO 88
#'
#' @param base Dataframe from any survey including a variable with ISCO 08 codes
#' @param isco character vector containing ISCO 08 codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each ISCO08 code to each ISCO88 code.
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

cross_isco_3dig <- crosstable_isco08_isco88 %>%
  dplyr::mutate(
    ISCO3D = as.integer(stringr::str_sub(string = `ISCO 08 Code`,1,3))) %>%
  dplyr::add_row(ISCO3D = 999) %>%
  dplyr::add_row(ISCO3D = NA)

nested.data.isco.cross <- cross_isco_3dig %>%
  dplyr::select(ISCO3D,`ISCO-88 code`) %>%
  dplyr::group_by(ISCO3D) %>%
  unique() %>%
  tidyr::nest()

base_lfs_join  <- base %>%
  dplyr::rename(ISCO3D = isco) %>%
  dplyr::left_join(nested.data.isco.cross,by = "ISCO3D")

Codigos_error <-  base_lfs_join %>%
  dplyr::select(ISCO3D) %>%
  dplyr::filter(!(ISCO3D %in% unique(cross_isco_3dig$ISCO3D))) %>%
  unique()

 assertthat::assert_that(
   all(unique(base_lfs_join$ISCO3D) %in% unique(cross_isco_3dig$ISCO3D)),
   msg = paste0("The following codes from the provided database were not found in 'crosstable_isco08_isco88' and it was not possible to crosswalk them:  ",
                list(Codigos_error$ISCO3D)))

set.seed(999971)
base_lfs_join_sample <- base_lfs_join %>%
  dplyr::mutate(ISCO.88 = purrr::map(data, sample.isco))  %>%
  dplyr::select(-data) %>%
  dplyr::mutate(ISCO.88 = as.numeric(ISCO.88))

return(base_lfs_join_sample)

if (summary==TRUE) {

summary_cross <<- base_lfs_join_sample %>%
  dplyr::group_by(ISCO3D,ISCO.88) %>%
  dplyr::summarise(Cases = dplyr::n())

}


}
