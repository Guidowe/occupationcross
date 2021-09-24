#' Cross SINCO 2011 (Mexico) to ISCO 08
#'
#' @param base Dataframe from mexican survey including a variable with "Sistema Nacional de Clasificacion de Ocupaciones 2011" (SINCO 2011) codes
#' @param sinco character vector containing SINCO 2011 codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each Census 08 code to each ISCO88 code.
#' @param code_titles If TRUE adds classification titles besides from codes.
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 08 codes
#' @export
#' @examples
#'
#'base_crossed <- sinco2011_to_isco08(
#'  base = toy_base_mexico,
#'  sinco = p3,
#'  summary = FALSE,
#'  code_titles = TRUE)

sinco2011_to_isco08<- function(base,
                               sinco,
                               summary = FALSE,
                               code_titles = FALSE){

  base <-  base %>%
    dplyr::mutate(cod.origin = as.character({{sinco}}))

#}
  Codigos_error <- base %>%
    dplyr::select(cod.origin) %>%
    dplyr::filter(!(cod.origin %in% unique(crosstable_sinco2011_isco08$cod.origin))) %>%
    unique()

  if(length(Codigos_error$cod.origin)>=1){
    warning(paste0("The following codes from the provided database were not found in 'crosstable_sinco2011_isco08' and it was not possible to crosswalk them:  ",
                   list(Codigos_error$cod.origin)))

    base  <- base %>%
      dplyr::mutate(
        cod.origin  = dplyr::case_when(
          cod.origin %in% Codigos_error$cod.origin ~ "0000",
          TRUE~ cod.origin))
  }



  nested.data.isco.cross <- crosstable_sinco2011_isco08 %>%
    dplyr::mutate(cod.origin = as.character(cod.origin)) %>%
    dplyr::add_row(cod.origin = "0000",
                   cod.destination = "0000") %>%
    dplyr::group_by(cod.origin,label.origin) %>%
    tidyr::nest()


  base_join  <- base %>%
    dplyr::mutate(cod.origin =
    dplyr::case_when( is.na(cod.origin)  ~"0000",
                       !is.na(cod.origin)  ~cod.origin)) %>%
    dplyr::left_join(nested.data.isco.cross,by = "cod.origin")

  set.seed(999971)

sample.isco <- function(df) {
    sample(df$cod.destination,size = 1)

  }

  base_join_sample <- base_join %>%
    dplyr::mutate(ISCO.08 = purrr::map(data, sample.isco))  %>%
    dplyr::select(-data) %>%
    dplyr::mutate(ISCO.08 = as.character(ISCO.08))


  if (code_titles==TRUE) {

    titles  <- crosstable_sinco2011_isco08 %>%
      dplyr::mutate(ISCO.08 = as.character(cod.destination)) %>%
      dplyr::select(ISCO.08,label.destination) %>%
      dplyr::distinct(ISCO.08,.keep_all = T)

    base_join_sample <- base_join_sample %>%
      dplyr::left_join(titles)
  }



  return(base_join_sample)

  if (summary==TRUE) {

    summary_cross <<- base_join_sample %>%
      dplyr::group_by(cod.origin,ISCO.08) %>%
      dplyr::summarise(Cases = dplyr::n())

  }


}
