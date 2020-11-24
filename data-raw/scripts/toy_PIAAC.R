library(tidyverse)
####bases de datos#####
piaac <- haven::read_dta("data-raw/bases/piaac - n100.dta")

toy_base_piaac <- piaac %>%
  select(CNTRYID_E,AGE_R,GENDER_R,ISCO08_C,ISCO08_L)

save(toy_base_piaac,file = "data/toy_base_piaac.rda")
