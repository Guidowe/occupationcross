#' Cross CNO 2001 (Arg) to ISCO 08
#'
#' @param base Dataframe from argentinian survey/census including a variable with CNO 2001 (Clasificador Nacional de Ocupaciones 2017) codes
#' @param cno character vector containing CNO 2001 codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each Census 08 code to each ISCO88 code.
#' @param code_titles If TRUE adds classification titles besides from codes.
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 08 codes
#' @export
#' @examples
#'

# 'base <- cno2001_to_isco08(base = toy_base_eph_argentina,cno = PP04D_COD)

cno2001_to_isco08<- function(base,
                             cno,
                             summary = FALSE,
                             code_titles = FALSE){

  base <-  base %>%
    dplyr::mutate(cod.origin = as.character({{cno}}),
                  cod.origin = cod.origin,
                  cod.origin = stringr::str_pad(cod.origin, 5, side = 'left', pad = '0'))

  #}
  Codigos_error <- base %>%
    dplyr::select(cod.origin) %>%
    dplyr::filter(!(cod.origin %in% unique(crosstable_cno2001_isco08$cno.2001.code))) %>%
    unique()

  if(length(Codigos_error$cod.origin)>=1){
    warning(paste0("The following codes from the input variable are not in cross_table and it was not possible to do crosswalk:",
                   list(Codigos_error$cod.origin)))

    base  <- base %>%
      dplyr::mutate(
        cod.origin  = dplyr::case_when(
          cod.origin %in% Codigos_error$cod.origin ~ "0000",
          TRUE~ cod.origin))
  }
  nested.data.isco.cross <- crosstable_cno2001_isco08 %>%
    dplyr::select(cod.origin = cno.2001.code,
                  ISCO.08  = isco08.2.digit.code) %>%
    dplyr::add_row(cod.origin = "0000",
                   ISCO.08 = "0000")


  base_join  <- base %>%
    dplyr::mutate(cod.origin =
                    dplyr::case_when( is.na(cod.origin)  ~"0000",
                                      !is.na(cod.origin)  ~cod.origin)) %>%
    dplyr::left_join(nested.data.isco.cross,by = "cod.origin")

  if (code_titles==TRUE) {

    titles  <- crosstable_cno2001_isco08 %>%
      dplyr::mutate(ISCO.08 = as.character(isco08.2.digit.code)) %>%
      dplyr::select(ISCO.08,isco08.2.digit.label) %>%
      unique()

    base_join <- base_join %>%
      dplyr::left_join(titles)
  }

  return(base_join)

  if (summary==TRUE) {

    summary_cross <<- base_join %>%
      dplyr::group_by(cod.origin,ISCO.08) %>%
      dplyr::summarise(Cases = dplyr::n())

  }

}

