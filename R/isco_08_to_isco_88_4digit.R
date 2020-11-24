#' Cross ISCO 08 a ISCO 88 - 4 digit
#'
#' @param base Dataframe from any survey including a variable with ISCO 08 codes
#' @param isco character vector containing ISCO 08 codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each ISCO08 code to each ISCO88 code.
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 88 codes
#' @export
#' @examples
#'
#' base_crossed <- isco08_to_isco88_4digit(toy_base_piaac,isco = "ISCO08_C",summary = TRUE)
#'
isco08_to_isco88_4digit<- function(base,isco,summary = FALSE){

  sample.isco <- function(df) {
    sample(df$`ISCO-88 code`,size = 1)
  }

  cross_isco_4dig <- crosstable_isco08_isco88 %>%
    dplyr::mutate(
      ISCO4D = as.integer(stringr::str_sub(string = `ISCO 08 Code`,1,4))) %>%
    dplyr::add_row(ISCO4D = 9999) %>%
    dplyr::add_row(ISCO4D = NA)

  nested.data.isco.cross <- cross_isco_4dig %>%
    dplyr::select(ISCO4D,`ISCO-88 code`) %>%
    dplyr::group_by(ISCO4D) %>%
    unique() %>%
    tidyr::nest()

  base_join  <- base %>%
    dplyr::rename(ISCO4D = isco) %>%
    dplyr::mutate(ISCO4D = as.integer(ISCO4D)) %>%
    dplyr::left_join(nested.data.isco.cross,by = "ISCO4D")

  Codigos_error <-  base_join %>%
    dplyr::select(ISCO4D) %>%
    dplyr::filter(!(ISCO4D %in% unique(cross_isco_4dig$ISCO4D))) %>%
    unique()

  assertthat::assert_that(
    all(unique(base_join$ISCO4D) %in% unique(cross_isco_4dig$ISCO4D)),
    msg = paste0("Los siguientes codigos de la base provista no se encuentran en los cross_table: ",
                 list(Codigos_error$ISCO4D)))

  set.seed(999971)
  base_join_sample <- base_join %>%
    dplyr::mutate(ISCO.88 = purrr::map(data, sample.isco))  %>%
    dplyr::select(-data) %>% # Elimino la columna loca que había creado para el sorteo
    dplyr::mutate(ISCO.88 = as.numeric(ISCO.88))

  return(base_join_sample)

  if (summary==TRUE) {

    summary_cross <<- base_join_sample %>%
      dplyr::group_by(ISCO4D,ISCO.88) %>%
      dplyr::summarise(Cases = dplyr::n())

  }


}
