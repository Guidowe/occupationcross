library(tidyverse)
####bases de datos#####
available_crosswalks <- tribble(
  ~from        ,   ~to       , ~detail,
  "SINCO2011"  ,  "ISCO08"  ,"complete crosswalk",
  "Census2010" ,  "ISCO08"  ,"complete crosswalk",
  "CNO2001"    ,  "ISCO08"  ,"crosswalk only available to isco digits 1 and 2",
  "CNO2017"    ,  "ISCO08"  ,"crosswalk only available to isco digits 1 and 2",
  "ISCO88"     ,  "ISCO08"  ,"complete crosswalk",
  "ISCO88_3digits",  "ISCO08"  ,"crosswalk designed for databases with ISCO88 containing only 3 digits",
  "ISCO08"     ,  "ISCO88"  ,"complete crosswalk",
  "Census2010",  "SOC2010","complete crosswalk",

)



available_classifications <- data.frame(
  classification =  c(
    "ISCO08",
    "ISCO88",
    "SINCO2011",
    "CNO2001",
    "CNO2017",
    "Census2010",
    "SOC2010"
    ),
  classification_fullname = c(
    "International Standard Classification of Occupations 08",
    "International Standard Classification of Occupations 88",
    "Sistema Nacional de Clasificación de Ocupaciones 2011",
    "Clasificador Nacional de Ocupaciones 2001",
    "Clasificador Nacional de Ocupaciones 2017",
    "2010 Census Occupational Classification",
    "2010 Standard Occupational Classification"
    ),
  country = c(
    "International",
    "International",
    "Mexico",
    "Argentina",
    "Argentina",
    "United States",
    "United States"
    )
  )

save(available_crosswalks,file = "data/available_crosswalks.rda")
save(available_classifications,file = "data/available_classifications.rda")
