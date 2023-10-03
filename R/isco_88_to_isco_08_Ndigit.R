#' Cross ISCO 88 to ISCO 08 - n digit
#'
#' @param base Dataframe from any survey including a variable with ISCO 88 codes
#' @param isco character vector containing ISCO 88 codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each ISCO88 code to each ISCO08 code.
#' @param digits Digits number (ranging from 1 to 4) for ISCO codes in input data
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 08 codes
#' @export
#' @examples
#'
#'
#' toy_base_peru_isco08 <- isco88_to_isco08_ndigit(toy_base_peru,isco = p505,digits = 3)



isco88_to_isco08_ndigit <- function(base,isco, digits, summary = FALSE, code_titles = FALSE){

  sample.isco <- function(df) {
    sample(df$ISCO08, size = 1)
  }

base <- base %>%
  dplyr::mutate(ISCO88 = as.character({{isco}}))


  cross_isco <- crosstable_isco08_isco88 %>%
    dplyr::mutate(
      ISCO88 = stringr::str_sub(string = `ISCO-88 code`,1, digits),
      ISCO08 = stringr::str_sub(string = `ISCO 08 Code`,1, digits)) %>%
    dplyr::add_row(ISCO88 = "9999") %>%
    dplyr::add_row(ISCO88 = NA) %>%
    dplyr::add_row(ISCO88 = "0000",
                   ISCO08 = "0000") %>%
    dplyr::select(ISCO88, ISCO08)

  nested.data.isco.cross <- cross_isco %>%
    dplyr::select(ISCO88, ISCO08) %>%
    dplyr::group_by(ISCO88) %>%
    unique() %>%
    tidyr::nest()


  Codigos_error <-  base %>%
    dplyr::select(ISCO88) %>%
    dplyr::filter(!(ISCO88 %in% unique(cross_isco$ISCO88))) %>%
    unique()

  # assertthat::assert_that(
  #   all(unique(base_join$ISCO88) %in% unique(cross_isco$ISCO88)),
  #   msg = paste0("Los siguientes codigos de la base provista no se encuentran en los cross_table: ",
  #                list(Codigos_error$ISCO88)))

  if(length(Codigos_error$ISCO88)>=1){
    warning(paste0("The following codes from the provided database were not found in 'crosstable_isco08_isco88' and it was not possible to crosswalk them: ",
                   list(Codigos_error$ISCO88)))

    base  <- base %>%
      dplyr::mutate(
        ISCO88  = dplyr::case_when(
          ISCO88 %in% Codigos_error$ISCO88 ~ "0000",
          TRUE~ ISCO88))
  }

  base_join  <- base %>%
    dplyr::left_join(nested.data.isco.cross,by = "ISCO88")

    set.seed(999971)

base_join_sample <- base_join %>%
    dplyr::mutate(ISCO.08 = purrr::map(data, sample.isco))  %>%
    dplyr::select(-data) %>%
    dplyr::mutate(ISCO.08 = as.numeric(ISCO.08))

  return(base_join_sample)

  if (summary==TRUE) {

    summary_cross <<- base_join_sample %>%
      dplyr::group_by(ISCO88,ISCO.88) %>%
      dplyr::summarise(Cases = dplyr::n())

  }


}
