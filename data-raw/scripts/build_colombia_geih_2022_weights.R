library(tidyverse)
library(arrow)

# distribucion de referencia ISCO-08 para el reparto ponderado de Colombia (CNO70).
# se arma de la GEIH 2022 (primer anio nativo en CIUO-08 A.C.): ocupados (OCI == 1),
# sumando el factor de expansion FEX_C18 por grupo primario OFICIO_C8.

colombia_geih_2022_weights <- open_dataset("data-raw/bases/colombia_2022.parquet") %>%
  select(OFICIO_C8, OCI, FEX_C18) %>%
  filter(OCI == "1") %>%
  collect() %>% # comando clave para trabajar con arrow y tidyverse eficientemente
  transmute(isco08.code = OFICIO_C8, weight = as.numeric(FEX_C18)) %>% # combinación copada de mutate y select
  group_by(isco08.code) %>%
  summarise(weight = sum(weight), .groups = "drop") %>%
  as.data.frame()

save(colombia_geih_2022_weights, file = "data/colombia_geih_2022_weights.rda")
