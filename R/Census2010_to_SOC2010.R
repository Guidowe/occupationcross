#' Cross Census 2010 to SOC 2010
#'
#' @param base Dataframe from any Survey including a variable with USA Census 2010 codes
#' @param census character vector containing Census 2010 codes
#' @param code_titles logical, if TRUE code_titles are added to dataframe

#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to SOC 2010 codes
#' @export
#' @examples
#'
#'base_crossed <- census2010_to_soc2010(toy_base_ipums_cps_2018,census = "OCC",code_titles = FALSE)
#'
census2010_to_soc2010<- function(base,census,code_titles = FALSE){

  base_census_join <- base %>%
    dplyr::rename(Census = census) %>%
    dplyr::mutate(Census = as.character(Census)) %>%
    dplyr::left_join(crosstable_census2010_soc2010,by = "Census")

  if(code_titles == FALSE){
base_census_join <- base_census_join %>%
  dplyr::select(-Census.title,-SOC.title)
  }

  return(base_census_join)
}
