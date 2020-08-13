library(tidyverse)
library(openxlsx)
library(stringr)

####bases de datos#####
census2010_usa_codes <- read.xlsx("data-raw/codigos_ocup_usa.xlsx",sheet = "OCC 2011a2019")
census2010_soc2010 <- read.xlsx("data-raw/codigos_ocup_usa.xlsx",sheet = "SOC CENSO cross para R")
soc2010_isco08 <- read.xlsx("data-raw/codigos_ocup_usa.xlsx",sheet = "SOC ISCO cross para R")

####Crosswalk Census a Soc#####

census2010_cross_soc2010 <- census2010_usa_codes %>%
    full_join(census2010_soc2010 %>% mutate(OCC=as.numeric(`2010.Census.Code`))) %>%
    select(Census = OCC,Census.title = Description,
           SOC.title = `2010.Occupation.Title`,
           SOC = `2010.SOC.Code`) %>%
    mutate(SOC= stringr::str_trim(string = SOC,side = "both"),
           Census= stringr::str_trim(string = Census,side = "both"),
           SOC.title = case_when(is.na(SOC.title)~Census.title,
                                 !is.na(SOC.title)~SOC.title),
           SOC = case_when(Census %in%  c(9840,9830)~"55-3010",
                           Census== 4550~"39-7010",
                           Census== 1000~"15-1131",
                           TRUE~SOC)) %>%
    filter(!is.na(Census))

save(census2010_cross_soc2010,file = "data/census2010_cross_soc2010.rda")

soc2010_cross_isco2008 <-  soc2010_isco08 %>%
    select(SOC = `2010.SOC.Code`,SOC.title = `2010.SOC.Title`,part,
           ISCO = `ISCO-08.Code`,ISCO.title = `ISCO-08.Title.EN`) %>%
    mutate(SOC= stringr::str_trim(string = SOC,side = "both"),
           ISCO= stringr::str_trim(string = ISCO,side = "both"))

save(soc2010_cross_isco2008,file = "data/soc2010_cross_isco2008.rda")

census2010_cross_soc2010_isco08 <- census2010_cross_soc2010 %>%
    mutate(SOC.JOIN = case_when(substring(SOC, nchar(SOC)) %in% c("0","X")~
                                  paste0(substring(SOC,1,nchar(SOC)-1),1),
                                TRUE~ SOC),
           SOC.JOIN = case_when(substring(SOC.JOIN,nchar(SOC.JOIN)-1,nchar(SOC.JOIN)-1) == "X"~
                                  paste0(substring(SOC.JOIN,1,nchar(SOC.JOIN)-2),99),
                                TRUE~ SOC.JOIN),
           SOC.JOIN = case_when(SOC.JOIN == "25-1001"~"25-1011",
                                SOC.JOIN == "25-3001"~"25-3099",
                                SOC.JOIN == "29-9001"~"29-9099",
                                SOC.JOIN == "39-4099"~"39-4011",
                                SOC.JOIN == "53-1001"~"53-1031",
                                SOC.JOIN == "53-1001"~"53-1031",
                                TRUE~ SOC.JOIN)) %>%
    left_join(soc2010_cross_isco2008 %>% rename(SOC.title.2 = SOC.title,
                                          SOC.JOIN = SOC))

save(census2010_cross_soc2010_isco08,file = "data/census2010_cross_soc2010_isco08.rda")



#
# ###Cross a 1 digito sampleado###
#   cross.census.a.soc.a.isco.1.dig  <- cross.census.a.soc.a.isco %>%
#     mutate(ISCO.1.digit = substr(ISCO,1,1),
#            Census = as.numeric(Census)) %>%
#     left_join(skills_isco %>% mutate(ISCO.1.digit = as.character(ISCO.1.digit)))
#
#
#   # casos.analizables  <- cross.census.a.soc.a.isco.1.dig %>%
#   #   select(SOC,SOC.title,subjetividad) %>%
#   #   unique() %>%
#   #   group_by(SOC) %>%
#   #   summarise(soc.a.isco.1.dig.distintos = n()) %>%
#   #   filter(soc.a.isco.1.dig.distintos>1,!is.na(SOC)) %>%
#   #   left_join(cross.census.a.soc.a.isco.1.dig %>%
#   #               select(SOC,SOC.title.2,ISCO.1.digit,ISCO,ISCO.title))
#
#   cross.census.a.soc.a.isco.nested <-  cross.census.a.soc.a.isco.1.dig %>%
#     group_by(Census,SOC,SOC.title) %>%
#     nest()
#
#   ####Aplico Cross####
#   Base_Usa_cruzada <- Base_USA %>%
#     filter(ASECFLAG==1) %>%
#     select(Variables.USA) %>%
#     rename(Census = OCCLY) %>%
#     left_join(cross.census.a.soc.a.isco.nested)
#
#   #Sorteo ocupaciones
#   set.seed(9999)
#   Base_Usa_sampleada <- Base_Usa_cruzada %>%
#     mutate(ISCO.1.digit = map(data, sample.isco)) %>%
#     select(-data) %>%
#     mutate(ISCO.1.digit = as.numeric(ISCO.1.digit)) %>%
#     left_join(skills_isco)
#
#   rm(list = c("Base_USA","Base_Usa_cruzada","cps_ddi"))
#   gc()
#
#   Chequeo.todo.joya <- Base_Usa_sampleada %>%
#     filter(Census!= 0,!(ISCO.1.digit %in% 0:10))
#
