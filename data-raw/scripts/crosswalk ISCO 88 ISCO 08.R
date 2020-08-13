####funciones y librerias#####
library(tidyverse)
library(readxl)
library(stringr)
library(foreign)

#Funcion propia para aleatorizar. Específica para esto, la voy a aplicar al final
sample.isco <- function(df) {
    sample(df$`ISCO-88 code`,size = 1)
  }
  
####Carga de Base LFS y Crosswalk#####
cross_isco <- read_excel("data/corrtab88-08.xls")
base_lfs <- read.csv("Bases/IT2014_y.csv")

toy_base_lfs<- base_lfs %>% 
   select(YEAR,SEX,AGE,WSTATOR,ILOSTAT,COUNTRYB,ISCO3D,ISCO1D,COEFF,HAT11LEV,SIZEFIRM) %>% 
   sample_n(size = 2000)

save(toy_base_lfs,file = "Bases/toybase_lfs_ita2014.rda")

###Substraigo a 3 digitos el ISCO 08 en el crosswalk (asi aparece en LFS)
cross_isco_3dig <- cross_isco %>% 
  mutate(ISCO3D = as.integer(str_sub(string = `ISCO 08 Code`,1,3))) %>% 
  add_row(ISCO3D = 999) # Agrego fila para los casos 999 (lo necesito para cruzar con algo)

###Creo un  dataframe con una fila por ISCO 08 a 3 digitos, 
###y todos sus cruces posibles con ISCO 88
nested.data.isco.cross <- cross_isco_3dig %>% 
  select(ISCO3D,`ISCO-88 code`) %>% 
  group_by(ISCO3D) %>% 
  nest()

#Es un tipo de dataframe particular de R

###Joineo la base LFS al dataframe anterior del crosswalk###
base_lfs_con_join  <- base_lfs %>% 
    left_join(nested.data.isco.cross) 

# Seteo una semilla, para que en caso de quererlo pueda repetir a futuro
# la aleatorización con mismos resultados
set.seed(999971)

base_lfs_sampleada <- base_lfs_con_join %>% 
    mutate(ISCO.88.sorteado = map(data, sample.isco)) # Acá estoy sorteando


base_lfs_sampleada <- base_lfs_sampleada %>% 
  select(-data) %>% # Elimino la columna loca que había creado para el sorteo
  mutate(ISCO.88.sorteado = as.numeric(ISCO.88.sorteado))

#Cuento cuantos casos de ISCO3D fueron a parar a cada ISCO.88 a 4 dígitos 
Conteo_de_cruces <- base_lfs_sampleada %>% 
  group_by(ISCO3D,ISCO.88.sorteado) %>% 
  summarise(Casos = n())

#Exportación de base
# Con esta función se puede exportar en .dta si necesitas

#write.dta(base_lfs_sampleada,"base_sampleada.dta") 

