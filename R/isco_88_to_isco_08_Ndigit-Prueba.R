#' Cross ISCO 88 to ISCO 08 - n digit
#'
#' @param base Dataframe from any survey including a variable with ISCO 08 codes
#' @param isco character vector containing ISCO 08 codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each ISCO08 code to each ISCO88 code.
#' @param digits Number of digits for ISCO codes ranging from 1 to 4
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 88 codes
#' @export
#' @examples
#'
#' base_crossed <- isco_88_to_isco_08_4digit()
#'

base <- toy_base_peru
isco <- "p505"
digits <- 3

isco88_to_isco08_4digit <- function(base,isco, digits, summary = FALSE){

  sample.isco <- function(df) {
    sample(df$ISCO08, size = 1)
  }

  cross_isco <- crosstable_isco08_isco88 %>%
    dplyr::mutate(
      ISCO88 = as.integer(stringr::str_sub(string = `ISCO-88 code`,1, as.numeric(digits))),
      ISCO08 = as.integer(stringr::str_sub(string = `ISCO 08 Code`,1, as.numeric(digits)))) %>%
    dplyr::add_row(ISCO88 = 9999) %>%
    dplyr::add_row(ISCO88 = NA) %>%
    select(ISCO88, ISCO08)

  nested.data.isco.cross <- cross_isco %>%
    dplyr::select(ISCO88, ISCO08) %>%
    dplyr::group_by(ISCO88) %>%
    unique() %>%
    tidyr::nest()

  base_join  <- base %>%
    dplyr::rename(ISCO88 = isco) %>%
    dplyr::mutate(ISCO88 = as.integer(ISCO88)) %>%
    dplyr::left_join(nested.data.isco.cross,by = "ISCO88")

  Codigos_error <-  base_join %>%
    dplyr::select(ISCO88) %>%
    dplyr::filter(!(ISCO88 %in% unique(cross_isco$ISCO88))) %>%
    unique()

  assertthat::assert_that(
    all(unique(base_join$ISCO88) %in% unique(cross_isco$ISCO88)),
    msg = paste0("Los siguientes codigos de la base provista no se encuentran en los cross_table: ",
                 list(Codigos_error$ISCO88)))

  set.seed(999971)
  base_join_sample <- base_join %>%
    dplyr::mutate(ISCO.08 = purrr::map(data, sample.isco))  %>%
    dplyr::select(-data) %>% # Elimino la columna loca que había creado para el sorteo
    dplyr::mutate(ISCO.08 = as.numeric(ISCO.08))

  return(base_join_sample)

  if (summary==TRUE) {

    summary_cross <<- base_join_sample %>%
      dplyr::group_by(ISCO88,ISCO.88) %>%      ### VER
      dplyr::summarise(Cases = dplyr::n())

  }


}
