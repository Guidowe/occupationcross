#' Occupations complexity level
#'
#' @param base Dataframe from any survey including a variable with occupation codes
#' @param isco Character vector containing occupation codes
#' @param iscotype Type of occupational classificaction. ISCO08, ISCO88, Census2010, SOC2010 and CNO2017 are supported.
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each occupation code to each complexity level.
#' @return The function returns the provided dataframe, adding a new variable with the occupation complexity level. The new complexity_level variable is a factor variable containg the levels 'Low', 'Medium' and 'High'.
#' @export
#' @examples
#'
#' base_complexity <- complexity_level(toy_base_ipums_cps_2018, OCC, iscotype="Census2010")
#' load("data/toy_base_uruguay.rda")
#' base_complexity <- complexity_level(toy_base_uruguay, f71_2, iscotype="ISCO08")
#'
complexity_level <- function(base, isco, iscotype, summary = FALSE){

  if ({{iscotype}}=="ISCO08") {

    base <- base %>%
      dplyr::mutate(
        complexity_level= factor(dplyr::case_when( {{isco}}  %in% 9000:9999         ~ "Low",
                                            {{isco}}  %in% 4000:8999        ~ "Medium",
                                            {{isco}}  %in% 1000:3999        ~ "High"),
                                            levels= c("Low", "Medium", "High")))
  }

  if ({{iscotype}}=="Census2010") {

    base <-  base %>%
      dplyr::mutate(Census = {{isco}})

    Codigos_error <- base %>%
      dplyr::select(Census) %>%
      dplyr::filter(!(Census %in% unique(crosstable_census2010_soc2010$Census))) %>%
      unique()

    if(length(Codigos_error$Census)>=1){
      warning(paste0("The following codes of the provided dataframe are not in our cross_table and it was not possible to crosswalk: ",
                     list(Codigos_error$Census)))

      base  <- base %>%
        dplyr::mutate(
            Census = dplyr::case_when(
              Census %in% Codigos_error$Census ~ 0,
              TRUE                           ~ Census))

    }


    sample.isco <- function(df) {
      sample(df$ISCO,size = 1)
    }

    nested.data.isco.cross <- crosstable_census2010_soc2010_isco08 %>%
      dplyr::group_by(Census,SOC) %>%
      tidyr::nest()

    base_join  <- base %>%
      dplyr::mutate(Census = as.character(Census)) %>%
      dplyr::left_join(nested.data.isco.cross,by = "Census")

    set.seed(999971)

    base_join_sample <- base_join %>%
      dplyr::mutate(ISCO.08 = purrr::map(data, sample.isco))  %>%
      dplyr::select(-data) %>% # Elimino la columna loca que habia creado para el sorteo
      dplyr::mutate(ISCO.08 = as.numeric(ISCO.08))

    base <- base_join_sample %>%
      dplyr::mutate(
        complexity_level= factor(dplyr::case_when( ISCO.08  %in% 9000:9999        ~ "Low",
                                            ISCO.08  %in% 4000:8999        ~ "Medium",
                                            ISCO.08  %in% 1000:3999        ~ "High"),
                                 levels= c("Low", "Medium", "High"))) %>%
      dplyr::select(-Census, -SOC, -ISCO.08) # Elimino otras columnas generadas que no son complexity_level



  }

  if (!{{iscotype}} %in% c("ISCO08", "Census2010")) {
    return("No complexity level classication avaiable for this classificatier type. Try using 'ISCO08', 'Census2010',... ")

  }

  return(base)}


