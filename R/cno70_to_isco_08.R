#' Cross CNO-SENA 1970 (Colombia) to ISCO 08
#'
#' @param base Dataframe from a colombian survey (e.g. GEIH) including a variable with CNO-SENA 1970 codes, at the 2-digit subgroup level published in the variable OFICIO
#' @param oficio character vector containing CNO-70 (OFICIO) 2-digit codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each origin code to each ISCO 08 code.
#' @param code_titles If TRUE adds classification titles besides from codes.
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 08 codes
#' @export
#' @examples
#'
#' base_crossed <- cno70_to_isco08(toy_base_colombia_cno70, oficio = OFICIO)

cno70_to_isco08<- function(base,
                           oficio,
                           summary = FALSE,
                           code_titles = FALSE){

  base <-  base %>%
    dplyr::mutate(cod.origin = stringr::str_pad(as.character({{oficio}}), 2, side = 'left', pad = '0'))

  Codigos_error <- base %>%
    dplyr::select(cod.origin) %>%
    dplyr::filter(!(cod.origin %in% unique(crosstable_cno70_isco88$cno70.code))) %>%
    unique()

  if(length(Codigos_error$cod.origin)>=1){
    warning(paste0("The following codes from the provided database were not found in 'crosstable_cno70_isco88' and it was not possible to crosswalk them:  ",
                   list(Codigos_error$cod.origin)))

    base  <- base %>%
      dplyr::mutate(
        cod.origin  = dplyr::case_when(
          cod.origin %in% Codigos_error$cod.origin ~ "00",
          TRUE~ cod.origin))
  }

  nested.data.isco.cross <- crosstable_cno70_isco88 %>%
    dplyr::select(cod.origin = cno70.code, ISCO88 = isco88.code) %>%
    dplyr::add_row(cod.origin = "00", ISCO88 = "0000") %>%
    dplyr::group_by(cod.origin) %>%
    tidyr::nest()

  base_join  <- base %>%
    dplyr::mutate(cod.origin =
                    dplyr::case_when( is.na(cod.origin)  ~"00",
                                      !is.na(cod.origin)  ~cod.origin)) %>%
    dplyr::left_join(nested.data.isco.cross,by = "cod.origin")

  set.seed(999971)

  sample.isco88 <- function(df) {
    sample(df$ISCO88, size = 1)
  }

  base_join_sample <- base_join %>%
    dplyr::mutate(ISCO88 = purrr::map(data, sample.isco88))  %>%
    dplyr::select(-data) %>%
    dplyr::mutate(ISCO88 = as.character(ISCO88))

  # de ISCO-88 a ISCO-08 con el crosswalk ya presente en el paquete
  base_join_sample <- isco88_to_isco08_ndigit(base = base_join_sample,
                                              isco = ISCO88,
                                              digits = 4,
                                              code_titles = code_titles,
                                              summary = summary)

  return(base_join_sample)

}
