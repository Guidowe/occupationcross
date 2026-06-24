#' Cross CNO-SENA 1970 (Colombia) to ISCO 08
#'
#' @param base Dataframe from a colombian survey (e.g. GEIH) including a variable with CNO-SENA 1970 codes, at the 2-digit subgroup level published in the variable OFICIO
#' @param oficio character vector containing CNO-70 (OFICIO) 2-digit codes
#' @param summary If TRUE provides other dataframe counting how many cases where asigned for each origin code to each ISCO 08 code.
#' @param code_titles If TRUE adds classification titles besides from codes.
#' @param allocation How to resolve the ambiguity of 2-digit CNO-70 codes that map
#'   to several ISCO-08 codes: `"uniform"` (default) draws one candidate at random;
#'   `"weighted"` draws proportional to the built-in 2022 GEIH ISCO-08 distribution
#'   (\code{\link{colombia_geih_2022_weights}}), restricted to each origin code's
#'   candidate set, with a uniform fallback when none of the candidates appears in
#'   the reference.
#'
#' @return The function returns the provided dataframe, adding a new variable with the crosswalk to ISCO 08 codes
#' @export
#' @examples
#'
#' base_crossed <- cno70_to_isco08(toy_base_colombia_cno70, oficio = OFICIO)
#'
#' # weighted draw using the built-in 2022 GEIH reference distribution
#' base_weighted <- cno70_to_isco08(toy_base_colombia_cno70, oficio = OFICIO, allocation = "weighted")

cno70_to_isco08<- function(base,
                           oficio,
                           summary = FALSE,
                           code_titles = FALSE,
                           allocation = c("uniform","weighted")){

  allocation <- match.arg(allocation)

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

  base <- base %>%
    dplyr::mutate(cod.origin = dplyr::case_when(is.na(cod.origin) ~ "00",
                                                !is.na(cod.origin) ~ cod.origin))

  # reparto ponderado: sortea el destino segun la distribucion ISCO-08 de la GEIH 2022
  if (allocation == "weighted") {
    w <- stats::setNames(colombia_geih_2022_weights$weight, colombia_geih_2022_weights$isco08.code)
    message("weighted allocation using the 2022 GEIH ISCO-08 distribution (colombia_geih_2022_weights)")

    # CNO-70 (2 digitos) -> ISCO-88 (4 digitos) -> ISCO-08 (4 digitos)
    reach <- crosstable_cno70_isco88 %>%
      dplyr::select(cod.origin = cno70.code, ISCO88 = isco88.code) %>%
      dplyr::add_row(cod.origin = "00", ISCO88 = "0000") %>%
      dplyr::left_join(
        crosstable_isco08_isco88 %>%
          dplyr::transmute(ISCO88 = `ISCO-88 code`, ISCO.08 = `ISCO 08 Code`) %>%
          dplyr::add_row(ISCO88 = "0000", ISCO.08 = "0000") %>%
          dplyr::distinct(),
        by = "ISCO88") %>%
      dplyr::filter(!is.na(ISCO.08)) %>%
      dplyr::distinct(cod.origin, ISCO.08) %>%
      dplyr::group_by(cod.origin) %>%
      tidyr::nest()

    base_join <- base %>%
      dplyr::left_join(reach, by = "cod.origin")

    set.seed(999971)

    draw_one <- function(df) {
      if (is.null(df) || nrow(df) == 0) return("0000")  # no reachable ISCO-08 -> unknown
      pick_one(df$ISCO.08, w)
    }

    base_out <- base_join %>%
      dplyr::mutate(ISCO.08 = purrr::map_chr(data, draw_one),
                    ISCO88  = NA_character_) %>%
      dplyr::select(-data)

    return(base_out)
  }

  # default: uniform two-stage sorteo
  nested.data.isco.cross <- crosstable_cno70_isco88 %>%
    dplyr::select(cod.origin = cno70.code, ISCO88 = isco88.code) %>%
    dplyr::add_row(cod.origin = "00", ISCO88 = "0000") %>%
    dplyr::group_by(cod.origin) %>%
    tidyr::nest()

  base_join  <- base %>%
    dplyr::left_join(nested.data.isco.cross,by = "cod.origin")

  set.seed(999971)

  sample.isco88 <- function(df) {
    sample(df$ISCO88, size = 1)
  }

  base_join_sample <- base_join %>%
    dplyr::mutate(ISCO88 = purrr::map(data, sample.isco88))  %>%
    dplyr::select(-data) %>%
    dplyr::mutate(ISCO88 = as.character(ISCO88))

  # de ISCO-88 a ISCO-08 con el crosswalk ya presentei en el paquete
  base_join_sample <- isco88_to_isco08_ndigit(base = base_join_sample,
                                              isco = ISCO88,
                                              digits = 4,
                                              code_titles = code_titles,
                                              summary = summary)

  return(base_join_sample)

}
