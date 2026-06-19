library(tidyverse)

# CNO-70 (para la variable OFICIO de la GEIH hasta 2021 inclusive, que es a 2 digitos)
# a ISCO-88, desde la correlativa oficial del DANE publicada en la CIUO-88 A.C. (2005).
# Cada grupo primario trae un bloque de 3 columnas (CIUO88OIT | CNO70 | SENA2003) que
# se lee con pdftotext -layout y se separa por la posicion de cada columna.

pdf <- "data-raw/cross/CIUO-88AC.pdf"
txt <- tempfile(fileext = ".txt")
system2("pdftotext", c("-layout", shQuote(pdf), shQuote(txt))) # llama a la CLI (interfaz de línea de comandos)
lineas <- readLines(txt, warn = FALSE)

corte  <- function(s) grepl("^\\s*(Subgrupo|SUBGRUPO|GRAN GRUPO|Gran grupo|Correlativa:)", s) |
                      grepl("^\\s*[0-9]{4}\\s+[A-Za-z]", s)
ignorar <- function(s) grepl("^\\s*$", s) | grepl("^\\s*[0-9]{1,3}\\s*$", s) | grepl("CIUO-88 A\\.C\\.", s)

####bloques de correlativa#####
encabezados <- which(grepl("CIUO88OIT:.*CNO70:.*SENA2003:", lineas))

pares <- map_dfr(encabezados, function(h) {
  col <- c(regexpr("CIUO88OIT:", lineas[h]), regexpr("CNO70:", lineas[h]), regexpr("SENA2003:", lineas[h]))
  oit <- character(); cno <- character(); i <- h + 1
  while (i <= length(lineas) && !corte(lineas[i]) && i <= h + 15) {
    if (!ignorar(lineas[i])) {
      pos <- gregexpr("[0-9]{4,5}", lineas[i])[[1]]
      if (pos[1] != -1) {
        cod <- regmatches(lineas[i], gregexpr("[0-9]{4,5}", lineas[i]))[[1]]
        oit <- c(oit, cod[pos <  col[2]])                # columna ISCO-88
        cno <- c(cno, cod[pos >= col[2] & pos < col[3]]) # columna CNO-70
      }
    }
    i <- i + 1
  }
  if (!length(oit)) oit <- NA_character_                  # "XXXX": sin equivalente
  expand_grid(cno70 = cno, isco88 = oit)
})

####limpieza y armado a 2 digitos (OFICIO)#####
load("data/crosstable_isco08_isco88.rda")
isco88_validos <- unique(as.character(crosstable_isco08_isco88$`ISCO-88 code`))

crosstable_cno70_isco88 <- pares %>%
  filter(str_length(cno70) == 5, !is.na(isco88), isco88 %in% isco88_validos) %>%
  transmute(cno70.code = str_sub(cno70, 1, 2), isco88.code = isco88) %>%
  distinct() %>%
  arrange(cno70.code, isco88.code)

save(crosstable_cno70_isco88, file = "data/crosstable_cno70_isco88.rda")
