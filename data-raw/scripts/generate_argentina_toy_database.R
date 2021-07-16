library(eph)
library(tidyverse)

####bases de datos#####
toy_base_eph_argentina <- eph::get_microdata(year = 2019,trimester = 1)

toy_base_eph_argentina <- toy_base_eph_argentina %>%
  sample_n(2000)

save(toy_base_eph_argentina,file = "data/toy_base_eph_argentina.rda")
