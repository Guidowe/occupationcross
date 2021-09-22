library(tidyverse)
####bases de datos#####
toy_base_ipums_cps_2018 <- readRDS("data-raw/bases/Base_USA2018.RDS")

scipen(999)
toy_base_ipums_cps_2018 <- toy_base_ipums_cps_2018 %>%
  select(YEAR,
         MONTH,
         SEX,
         AGE,
         EDUC,
         LABFORCE,
         WKSTAT,
         EMPSTAT,
         OCC2010) %>%
  sample_n(2000)

save(toy_base_ipums_cps_2018,file = "data/toy_base_ipums_cps_2018.rda")
