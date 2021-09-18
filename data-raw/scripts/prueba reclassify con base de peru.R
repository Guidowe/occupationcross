

base <- PER
isco <- "p505"
digits=3

PER <- reclassify_to_isco08(PER, p505, classif_origin = "ISCO88_3digits")

PER <- PER %>% mutate(
#Calificación del puesto
CALIF2= factor(case_when( 
  #1. Baja
  ISCO.08 %in% 900:999        ~ "Baja",                  ## CIOU-88 a tres digitos         
  #2. Media
  ISCO.08 %in% 400:899        ~ "Media", 
  #3. Alta
  ISCO.08 %in% 100:399        ~ "Alta", 
  TRUE                     ~  "Ns/Nc"), 
  levels= c("Baja", "Media", "Alta", "Ns/Nc")))

Tabla <- PER %>%
  group_by(CALIF) %>%
  summarise(abs=sum(WEIGHT)) %>% 
  ungroup() %>% 
  mutate(per=abs/sum(abs)) %>% 
  select(CALIF, per)

Tabla2 <- PER %>%
  group_by(CALIF2) %>%
  summarise(abs=sum(WEIGHT)) %>% 
  ungroup() %>% 
  mutate(per2=abs/sum(abs),
         CALIF=CALIF2) %>% 
  select(CALIF, per2)

Tabla3 <- Tabla %>% left_join(Tabla2, by=c("CALIF"))

prueba <- PER %>% select(CALIF, CALIF2, p505, ISCO.08, ISCO88)

