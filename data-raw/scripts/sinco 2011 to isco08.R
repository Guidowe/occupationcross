library(tidyverse)
library(openxlsx)
library(stringr)

####bases de datos#####
sinco_2011 <- read.xlsx("data-raw/cross/mexico_sinco_tablas_comparativas.xlsx",
                                  sheet = "SINCO-CIUO",skipEmptyRows = T,cols = 4:7)

names(sinco_2011)[1] <- "cod.origin"
names(sinco_2011)[2] <- "label.origin"
names(sinco_2011)[3] <- "cod.destination"
names(sinco_2011)[4] <- "label.destination"

####Crosswalk Census a Soc#####
for(i in 1:nrow(sinco_2011)){

sinco_2011$cod.origin[i] <- ifelse(is.na(sinco_2011$cod.origin[i]),
                                   yes = sinco_2011$cod.origin[i-1],
                                   no = sinco_2011$cod.origin[i])

sinco_2011$label.origin[i] <- ifelse(is.na(sinco_2011$label.origin[i]),
                                   yes = sinco_2011$label.origin[i-1],
                                   no = sinco_2011$label.origin[i])


}

sinco_2011_isco08 <- sinco_2011 %>%
    filter(str_length(cod.origin)== 4)

sinco_2011_isco08$cod.destination[str_sub(
sinco_2011_isco08$label.destination,1,8) == "No tiene"] <- "0000"

for(i in 1:nrow(sinco_2011_isco08)){

    sinco_2011_isco08$cod.destination[i] <- ifelse(is.na(sinco_2011_isco08$cod.destination[i]),
                                       yes = sinco_2011_isco08$cod.destination[i-1],
                                       no = sinco_2011_isco08$cod.destination[i])

    sinco_2011_isco08$label.destination[i] <- ifelse(is.na(sinco_2011_isco08$label.destination[i]),
                                         yes = sinco_2011_isco08$label.destination[i-1],
                                         no = sinco_2011_isco08$label.destination[i])


}

crosstable_sinco2011_isco08 <- sinco_2011_isco08

save(crosstable_sinco2011_isco08,file = "data/crosstable_sinco2011_isco08.rda")
