#' Reclassify ocupational codes to International Standard Classification of Occupations 08
#'
#' @param base Dataframe including a variable with occupational codes contained in "available_classifications"
#' @param variable  variable containing occupational codes
#' @param classif_origin character vector specifying the Classification. "Census2010" (United States), "CNO2017" (Argentina), "SINCO2011" (Mexico) are supported.
#' @param add_skill If TRUE adds a new variable with the occupation skill level based on ISCO 08 skill levels. The new skill_level variable is a factor variable containg the levels 'Low', 'Medium' and 'High'.
#' @param add_major_groups If TRUE adds a new variable with the major groups of each occupation based on the 1-digit ISCo-08 classification structure. The major gruops structure has 9 levels, where level 1 means the highest skill level needed to perform the job and level 9 refers ti the lowest skill level.
#' @param code_titles If TRUE adds classification titles besides from codes.
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each Census 08 code to each ISCO88 code.
#' @details disclaimer: This script uses crosswalks provided by different statistical offices arround the world.
#'  It is not an official product of any of them
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 08 codes
#' @export
#' @examples
#'
#'
#'
#' USA_database_with_isco08 <- reclassify_to_isco08(toy_base_ipums_cps_2018, OCC, classif_origin="Census2010")
#' MEX_database_with_isco08 <- reclassify_to_isco08(toy_base_mexico, p3, classif_origin="SINCO2011")
#' ARG_database_with_isco08 <- reclassify_to_isco08(toy_base_eph_argentina, PP04D_COD, classif_origin="CNO2001")

reclassify_to_isco08 <- function(base,
                                 variable,
                                 classif_origin,
                                 add_skill = F,
                                 add_major_groups = F,
                                 code_titles = F,
                                 summary = F){

  attempt::stop_if_not(.x = classif_origin %in% c("Census2010","CNO2001","CNO2017","SINCO2011"),
                       msg = paste0 ("'",classif_origin, "' is not any of the classifications available"))

  if (classif_origin=="SINCO2011"){
    base  <- sinco2011_to_isco08(base = base,
                                 sinco = {{variable}},
                                 code_titles = code_titles,
                                 summary = summary)
  }

  if (classif_origin=="CNO2001"){
    base  <- cno2001_to_isco08(base = base,
                               cno = {{variable}},
                               code_titles = code_titles,
                               summary = summary)

  }

  if (classif_origin=="CNO2017"){
    base  <- cno2017_to_isco08(base = base,
                               cno = {{variable}},
                               code_titles = code_titles,
                               summary = summary)

  }

  if (classif_origin=="Census2010"){
    base  <- census2010_to_isco08(base = base,
                                  census = {{variable}},
                                  code_titles = code_titles,
                                  summary = summary)
  }

  if (add_skill==T){

    base <- base %>%
      dplyr::mutate(
        skill_level= factor(dplyr::case_when(
          stringr::str_sub(ISCO.08,1,1)  %in% 9          ~ "Low",
          stringr::str_sub(ISCO.08,1,1)  %in% 4:8        ~ "Medium",
          stringr::str_sub(ISCO.08,1,1)  %in% 1:3        ~ "High"),
          levels= c("Low", "Medium", "High")))


  }

  if (add_major_groups==T){

    base <- base %>%
      dplyr::mutate(
        major_group= factor(dplyr::case_when(
          stringr::str_sub(ISCO.08,1,1)  %in% 9        ~ "9. Elementary Occupations Low complexity occupations",
          stringr::str_sub(ISCO.08,1,1)  %in% 8        ~ "8. Plant and Machine Operators and Assemblers",
          stringr::str_sub(ISCO.08,1,1)  %in% 7        ~ "7. Craft and Related Trades Workers",
          stringr::str_sub(ISCO.08,1,1)  %in% 6        ~ "6. Skilled Agricultural, Forestry and Fishery Workers",
          stringr::str_sub(ISCO.08,1,1)  %in% 5        ~ "5. Services and Sales Workers",
          stringr::str_sub(ISCO.08,1,1)  %in% 4        ~ "4. Clerical Support Workers Medium complexity occupations",
          stringr::str_sub(ISCO.08,1,1)  %in% 3        ~ "3. Technicians and Associate Professionals",
          stringr::str_sub(ISCO.08,1,1)  %in% 2        ~ "2. Professionals",
          stringr::str_sub(ISCO.08,1,1)  %in% 1        ~ "1. Managers"),
          levels= c(  "1. Managers",
                      "2. Professionals",
                      "3. Technicians and Associate Professionals",
                      "4. Clerical Support Workers Medium complexity occupations",
                      "5. Services and Sales Workers",
                      "6. Skilled Agricultural, Forestry and Fishery Workers",
                      "7. Craft and Related Trades Workers",
                      "8. Plant and Machine Operators and Assemblers",
                      "9. Elementary Occupations Low complexity occupations")))

  }

  return(base)

}
