library(tidyverse)

####bases de datos#####

# Gran Encuesta Integrada de Hogares (GEIH) de Colombia.
# El código de ocupacion cambia de variable segun el anio de la encuesta:
#  - 2019: variable OFICIO, CNO-SENA 1970 (CIUO-68 / ISCO-68, pero a 2 digitos)
#  - 2024: variable OFICIO_C8, CNO basada en CIUO-08 A.C. (ISCO-08, esta sí a 4 digitos)

####toy_base_colombia_cno70 (GEIH 2019 - CNO-SENA 1970 / ISCO-68)#####
toy_base_colombia_cno70 <- arrow::read_parquet("data-raw/bases/colombia_2019_completo.parquet")

variables <- c("OFICIO", "RAMA2D", "P6020", "P6040", "P6210", "P6800",
               "INGLABO", "OCI", "AREA", "DPTO", "MES", "fex_c_2011")

set.seed(999971)
toy_base_colombia_cno70 <- toy_base_colombia_cno70 %>%
  select(all_of(variables)) %>%
  sample_n(2000)

save(toy_base_colombia_cno70, file = "data/toy_base_colombia_cno70.rda")

####toy_base_colombia_ciuo08 (GEIH 2024 - CNO basada en CIUO-08 A.C. / ISCO-08)#####
toy_base_colombia_ciuo08 <- arrow::read_parquet("data-raw/bases/colombia_2024_completo.parquet")

variables <- c("OFICIO_C8", "RAMA2D_R4", "P3271", "P6040", "P3042", "P6800",
               "INGLABO", "OCI", "AREA", "DPTO", "MES", "FEX_C18")

set.seed(999971)
toy_base_colombia_ciuo08 <- toy_base_colombia_ciuo08 %>%
  select(all_of(variables)) %>%
  sample_n(2000)

save(toy_base_colombia_ciuo08, file = "data/toy_base_colombia_ciuo08.rda")
