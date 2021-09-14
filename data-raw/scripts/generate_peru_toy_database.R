library(tidyverse)
####bases de datos#####
toy_base_peru <- haven::read_dta("data-raw/bases/Peru_3T2019.dta")

variables <- c("p507", "p510", "fac500", "p507", "ocu500", "p513t", "p521a", "p510a1", "p521",
               "p511a", "p512a", "p512b", "p505", "p523", "p524e1", "estrato", "p558a1", "p558a2",
               "p558a3", "p558a4", "p558a5", "p530a")

toy_base_peru  <- toy_base_peru  %>%
  select(variables)

save(toy_base_peru,file = "data/toy_base_peru.rda")
