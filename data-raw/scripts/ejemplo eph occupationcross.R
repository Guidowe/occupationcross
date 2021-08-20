library(occupationcross)
clasificadores_trabajados<- available_classifications
crosswalks_disponibles <- available_crosswalks

base_2t_2019<- eph::get_microdata(
  year = 2019,
  trimester = 2,
  vars = c("CH04","ESTADO","CAT_OCUP","P21","PP04D_COD"))

base_2t_2019_isco08<- occupationcross::reclassify_to_isco08(
  base = base_2t_2019,
  variable = PP04D_COD,
  classif_origin = "CNO2001",
  code_titles = T,
  add_complexity = T
)

que_cruzo <- base_2t_2019_isco08 %>%
  dplyr::group_by(PP04D_COD,ISCO.08) %>%
  dplyr::summarise(Cases = dplyr::n())

complejidad <- base_2t_2019_isco08 %>%
  eph::organize_labels() %>%
  eph::calculate_tabulates(x = "CH04",
                      y = "complexity_level",
                      weights = "PONDERA",add.percentage = "row")
