#' Cross Census 2010 (USA) to ISCO 08
#'
#' @param base Dataframe from any survey including a variable with Standard Occupational Codes (SOC) 2010
#' @param census character vector containing Census 2010 codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each Census 08 code to each ISCO88 code.
#' @param code_titles If TRUE adds classification titles besides from codes.
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 08 codes
#' @export
#' @examples
#'
#' base_crossed <- census2010_to_isco08(toy_base_ipums_cps_2018,census = "OCC",summary = TRUE)
#'
census2010_to_isco08<- function(base,census,summary = FALSE,code_titles = FALSE){

  sample.isco <- function(df) {
    sample(df$ISCO,size = 1)
  }

  nested.data.isco.cross <- crosstable_census2010_soc2010_isco08 %>%
    dplyr::group_by(Census,SOC) %>%
    tidyr::nest()

 #   toy_base_ipums_cps_2018  <- labelled::remove_labels(base)
 # save(toy_base_ipums_cps_2018,file = "data/toy_base_ipums_cps_2018.rda")

base_join  <- base %>%
    dplyr::rename(Census = census) %>%
    dplyr::mutate(Census = as.character(Census)) %>%
    dplyr::left_join(nested.data.isco.cross,by = "Census")

set.seed(999971)

  base_join_sample <- base_join %>%
    dplyr::mutate(ISCO.08 = purrr::map(data, sample.isco))  %>%
    dplyr::select(-data) %>% # Elimino la columna loca que había creado para el sorteo
    dplyr::mutate(ISCO.08 = as.numeric(ISCO.08))

  if (code_titles==TRUE) {

    titles  <- crosstable_census2010_soc2010_isco08 %>%
      dplyr::mutate(ISCO.08 = as.numeric(ISCO)) %>%
      dplyr::select(ISCO.08,ISCO.title) %>%
      unique()

    base_join_sample <- base_join_sample %>%
      dplyr::left_join(titles)
  }



return(base_join_sample)

  if (summary==TRUE) {

    summary_cross <<- base_join_sample %>%
      dplyr::group_by(Census,ISCO.08) %>%
      dplyr::summarise(Cases = dplyr::n())

  }


}
