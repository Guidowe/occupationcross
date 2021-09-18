
library(ipumsr)
library(tidyverse)

ddi <- read_ipums_ddi("C:/Users/Usuario/Documents/Investigación/1. Occupationcross/cps_00001.xml")
cps <- read_ipums_micro(ddi, data_file= "C:/Users/Usuario/Documents/Investigación/1. Occupationcross/cps_2018_occupation_data.dat")

cps2018_occ_genre <- cps %>% filter(YEAR==2018) %>% select(EMPSTAT, SEX, ASECWT, OCC, MONTH)

save(cps2018_occ_genre, file = "data-raw/bases/cps2018_occ_genre.rda")



