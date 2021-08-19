library(tidyverse)

####bases de datos#####

#Fue previamente transformada a data frame porque la version original pesaba mucho
#  uruguay_P_2019_Terceros <- read.delim("data-raw/bases/uruguay_P_2019_Terceros.dat", 
#                                     header = TRUE, sep="\t")
#
#  save(uruguay_P_2019_Terceros, file="data-raw/bases/uruguay_P_2019_Terceros.rda")

load("data-raw/bases/uruguay_P_2019_Terceros.rda")

variables <- c("f73", "pesomen", "pobpcoac", "f82", "f77", "f71_2", "PT2", "f85", "f102", "f103", "region_4",
               "e45_1", "e45_2", "e45_3", "e45_4", "e45_5", "e45_6", "e45_7", "f263")                                            

toy_base_uruguay <- uruguay_P_2019_Terceros %>% 
  select(variables) %>% 
  sample_n(2000)

save(toy_base_uruguay,file = "data/toy_base_uruguay.rda")