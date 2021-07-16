library(tidyverse)
library(openxlsx)

####bases de datos#####
crosstable_cno2017_isco08 <- read.xlsx("data-raw/cross/cno17-isco08.xlsx")
crosstable_cno2001_isco08 <- readxl::read_xls("data-raw/cross/CONVERSION_CNO-01_CIUO-08.xls",
                                              skip = 1,n_max = 594)

isco.skill.levels <- read.xlsx("data-raw/cross/skill_levels_isco.xlsx") %>%
  mutate(isco.digito.1 = as.character(ISCO.1.digit)) %>%
  select(isco.digito.1,Skill.level,calificacion)

calificaciones.cno<- eph::CNO %>%
  filter(digit == 5) %>%
  rename(cno.digito.5 = value,
         label.cno = label) %>%
  select(2:3)

######Analisis de crosswalks######
cruce.calificacion.skills <- crosstable_cno2017_isco08 %>%
  mutate(cno.digito.5 = str_sub(CNO,5,5),
         isco.digito.1 = str_sub(`CIUO-08`,1,1)) %>%
  group_by(cno.digito.5,isco.digito.1) %>%
  summarise(casos = n()) %>%
  left_join(calificaciones.cno) %>%
  left_join(isco.skill.levels) %>%
  select(label.cno,cno.digito.5,casos,isco.digito.1,Skill.level)

#comparo CNO 2017 y 2001
names(crosstable_cno2001_isco08)[2] <- "CNO"

crosstable_cno2001_isco08 <- crosstable_cno2001_isco08 %>%
  mutate(CNO = str_replace_all(CNO,pattern = "\\.",replacement = ""))

comparo.cno2001.2017 <- crosstable_cno2017_isco08 %>%
  select(-3) %>%
  full_join(cno2001_isco08.check %>% select(2:3))
####Renombrado y guardado######
names(crosstable_cno2017_isco08)[1] <- "cno.2017"
names(crosstable_cno2017_isco08)[2] <- "isco08.2.digit"


names(crosstable_cno2001_isco08)[1] <- "cno.2001.label"
names(crosstable_cno2001_isco08)[2] <- "cno.2001.code"
names(crosstable_cno2001_isco08)[3] <- "isco08.2.digit.code"
names(crosstable_cno2001_isco08)[4] <- "isco08.2.digit.label"

save(crosstable_cno2017_isco08,file = "data/crosstable_cno2017_isco08.rda")
save(crosstable_cno2001_isco08,file = "data/crosstable_cno2001_isco08.rda")
