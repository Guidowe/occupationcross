library(tidyverse)
####bases de datos#####
toy_base_mexico <- readRDS("data-raw/bases/mexico_T31019.RDS")

scipen(999)
toy_base_mexico <- toy_base_mexico %>%
  rename_all(.funs = tolower) %>%
  select(sex,
         t_loc,
         clase2,
         tue1,
         pos_ocu,
         per,
         fac,p3) %>%
  sample_n(200)

save(toy_base_mexico,file = "data/toy_base_mexico.rda")
