library(tidyverse)
####bases de datos#####
available_crosswalks <- tribble(
  ~from        ,   ~to       , ~detail,
  "cno 2001"   ,  "isco 08"  ,"crosswalk only available to isco digits 1 and 2",
  "sinco 2011" ,  "isco 08"  ,"complete crosswalk",
  "isco 08"    ,  "isco 88"  ,"complete crosswalk",
  "census 2010",  "soc 2010","complete crosswalk",
  "census 2010",  "isco 08"  ,"complete crosswalk",

)



available_classifications <- data.frame(
  classification =  c(
    "isco 08",
    "isco 88",
    "sinco 2011",
    "cno 2001",
    "census 2010",
    "soc 2010"
    ),
  classification_fullname = c(
    "International Standard Classification of Occupations 08",
    "International Standard Classification of Occupations 88",
    "Sistema Nacional de Clasificación de Ocupaciones 2011",
    "Clasificador Nacional de Ocupaciones 2001",
    "2010 Census Occupational Classification",
    "2010 Standard Occupational Classification"
    ),
  country = c(
    "International",
    "International",
    "Mexico",
    "Argentina",
    "United States",
    "United States"
    )
  )

save(available_crosswalks,file = "data/available_crosswalks.rda")
save(available_classifications,file = "data/available_classifications.rda")
