####funciones y librerias#####
  knitr::opts_chunk$set(echo = FALSE,warning = FALSE,message = FALSE)
  knitr::opts_chunk$set(fig.width = 10)
  
  
  
  library(ipumsr)
  library(eph)
  library(ggthemes)
  library(ggalt)
  library(tidyverse)
  library(kableExtra)
  library(formattable)
  library(openxlsx)
  library(Weighted.Desc.Stat)
  library(stringr)
  # Funcion de redondeo para presentación (queda como character)
  formato_porc <- function(numero, dec = 1){
    format(round(numero, digits = dec), nsmall = dec, decimal.mark = ",")
  }
  
  formato_pesos <- function(numero, dec = 2){
    paste0("$", format(round(numero, digits = dec), nsmall = dec, big.mark = ".", decimal.mark = ","))
  }
  
  formato_cantidad <- function(numero, dec = 0){
    format(round(numero, digits = dec), nsmall = dec, big.mark = ".", decimal.mark = ",")
  }
  
  sample.isco <- function(df) {
    sample(df$ISCO.1.digit,size = 1)
  }
  
####bases de datos#####
  
  ocup_usa <- read.xlsx("data/Codigos Ocup USA.xlsx",sheet = "OCC 2011a2019")
  ramas_usa <- read.xlsx("data/Codigos Ocup USA.xlsx",sheet = "IND 2014a2019")
  soc_census <- read.xlsx("data/Codigos Ocup USA.xlsx",sheet = "SOC CENSO cross para R")
  soc_isco <- read.xlsx("data/Codigos Ocup USA.xlsx",sheet = "SOC ISCO cross para R")
  skills_isco <- read.xlsx("data/Codigos Ocup USA.xlsx",sheet = "Skill levels ISCO")
  
  
  # cps_ddi_file <- "../bases/cps_00005.xml"
  # cps_data_file <- "../bases/cps_00005.dat"
  # cps_ddi <- read_ipums_ddi(cps_ddi_file) 
  # Base_USA <- ipumsr::read_ipums_micro(ddi = cps_ddi_file,
  #                                  data_file =  cps_data_file)
  # 
  ####Crosswalk USA#####
  
  cross.census.a.soc <- ocup_usa %>% 
    full_join(soc_census %>% mutate(OCC=as.numeric(`2010.Census.Code`))) %>% 
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
  
  cross.soc.a.isco <-  soc_isco %>% 
    select(SOC = `2010.SOC.Code`,SOC.title = `2010.SOC.Title`,part, 
           ISCO = `ISCO-08.Code`,ISCO.title = `ISCO-08.Title.EN`) %>% 
    mutate(SOC= stringr::str_trim(string = SOC,side = "both"),
           ISCO= stringr::str_trim(string = ISCO,side = "both"))
  
  
  cross.census.a.soc.a.isco <- cross.census.a.soc %>% 
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
    left_join(cross.soc.a.isco %>% rename(SOC.title.2 = SOC.title,
                                          SOC.JOIN = SOC))
  
  
  
  
  
###Cross a 1 digito sampleado###
  cross.census.a.soc.a.isco.1.dig  <- cross.census.a.soc.a.isco %>% 
    mutate(ISCO.1.digit = substr(ISCO,1,1),
           Census = as.numeric(Census)) %>% 
    left_join(skills_isco %>% mutate(ISCO.1.digit = as.character(ISCO.1.digit))) 
  
  
  # casos.analizables  <- cross.census.a.soc.a.isco.1.dig %>% 
  #   select(SOC,SOC.title,subjetividad) %>% 
  #   unique() %>% 
  #   group_by(SOC) %>% 
  #   summarise(soc.a.isco.1.dig.distintos = n()) %>% 
  #   filter(soc.a.isco.1.dig.distintos>1,!is.na(SOC)) %>% 
  #   left_join(cross.census.a.soc.a.isco.1.dig %>% 
  #               select(SOC,SOC.title.2,ISCO.1.digit,ISCO,ISCO.title))
  
  cross.census.a.soc.a.isco.nested <-  cross.census.a.soc.a.isco.1.dig %>% 
    group_by(Census,SOC,SOC.title) %>% 
    nest()
  
  ####Aplico Cross####
  Base_Usa_cruzada <- Base_USA %>% 
    filter(ASECFLAG==1) %>% 
    select(Variables.USA) %>% 
    rename(Census = OCCLY) %>%  
    left_join(cross.census.a.soc.a.isco.nested)
  
  #Sorteo ocupaciones
  set.seed(9999)
  Base_Usa_sampleada <- Base_Usa_cruzada %>% 
    mutate(ISCO.1.digit = map(data, sample.isco)) %>% 
    select(-data) %>% 
    mutate(ISCO.1.digit = as.numeric(ISCO.1.digit)) %>% 
    left_join(skills_isco) 
  
  rm(list = c("Base_USA","Base_Usa_cruzada","cps_ddi"))
  gc()
  
  Chequeo.todo.joya <- Base_Usa_sampleada %>% 
    filter(Census!= 0,!(ISCO.1.digit %in% 0:10))
  
  