#' Occupations skill level
#'
#' @param base Dataframe from any survey including a variable with occupation codes
#' @param variable Character vector containing occupation codes
#' @param classif_origin Type of occupational classificaction. ISCO08, ISCO88, Census2010, SOC2010 and CNO2017 are supported.
#' @return The function returns the provided dataframe, adding a new variable with the occupation skill level. The new skill_level variable is a factor variable containg the levels 'Low', 'Medium' and 'High'.
#' @export
#' @examples
#'
#'base_uruguay_skill <- skill_level(toy_base_uruguay, f71_2, classif_origin="ISCO08")
#'base_mexico_skill <- skill_level(toy_base_mexico, p3, classif_origin = "SINCO2011")
#'base_eph_skill <- skill_level(toy_base_eph_argentina, PP04D_COD, classif_origin = "CNO2001")
#'base_cps_skill <- skill_level(toy_base_ipums_cps_2018, OCC2010, classif_origin =  "Census2010")
#'
#'


skill_level <- function(base, variable, classif_origin){

  attempt::stop_if_not(.x = {{classif_origin}} %in% c("Census2010","CNO2001","CNO2017","SINCO2011", "ISCO08"),
                       msg = paste0 ("'",classif_origin, "' is not any of the classifications available.ISCO08, ISCO88, Census2010, SOC2010 and CNO2017 are supported."))


  if ({{classif_origin}}=="ISCO08") {

    base <- base %>%
      dplyr::mutate(
        skill_level= factor(dplyr::case_when( {{variable}}  %in% 9000:9999    ~ "Low",
                                            {{variable}}    %in% 4000:8999    ~ "Medium",
                                            {{variable}}    %in% 1000:3999    ~ "High"),
                                            levels= c("Low", "Medium", "High")))
  }

  if ({{classif_origin}}=="SINCO2011"){
    base  <- sinco2011_to_isco08(base = base,
                                 sinco = {{variable}},
                                 code_titles = FALSE,
                                 summary = FALSE)   %>%
      dplyr::mutate(
      skill_level= factor(dplyr::case_when( ISCO.08   %in% 9000:9999        ~ "Low",
                                            ISCO.08   %in% 4000:8999        ~ "Medium",
                                            ISCO.08   %in% 1000:3999        ~ "High"),
                          levels= c("Low", "Medium", "High")))%>%
      dplyr::select(-cod.origin, -label.origin, -ISCO.08)

    return(base)

  }

  if ({{classif_origin}}=="CNO2001"){
    base  <- cno2001_to_isco08(base = base,
                               cno = {{variable}},
                               code_titles = FALSE,
                               summary = FALSE)   %>%
      dplyr::mutate(
        skill_level= factor(dplyr::case_when( ISCO.08   %in% 90:99        ~ "Low",
                                              ISCO.08   %in% 40:89        ~ "Medium",
                                              ISCO.08   %in% 10:39       ~ "High"),
                            levels= c("Low", "Medium", "High"))) %>%
      dplyr::select(-cod.origin, -ISCO.08)

  }

  if ({{classif_origin}}=="CNO2017"){
    base  <- cno2017_to_isco08(base = base,
                               cno = {{variable}},
                               code_titles = FALSE,
                               summary = FALSE)  %>%
      dplyr::mutate(
        skill_level= factor(dplyr::case_when( ISCO.08   %in% 90:99        ~ "Low",
                                              ISCO.08   %in% 40:89        ~ "Medium",
                                              ISCO.08   %in% 10:39       ~ "High"),
                            levels= c("Low", "Medium", "High"))) %>%
      dplyr::select(-cod.origin, -ISCO.08)

  }

  if ({{classif_origin}}=="Census2010"){
    base  <- census2010_to_isco08(base = base,
                                  census = {{variable}},
                                  code_titles = FALSE,
                                  summary = FALSE) %>%
      dplyr::mutate(
        skill_level= factor(dplyr::case_when( ISCO.08   %in% 9000:9999        ~ "Low",
                                              ISCO.08   %in% 4000:8999        ~ "Medium",
                                              ISCO.08   %in% 1000:3999        ~ "High"),
                            levels= c("Low", "Medium", "High"))) %>%
      dplyr::select(-ISCO.08, -Census, -SOC)
  }

  return(base)}


