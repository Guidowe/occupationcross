library(occupationcross)

load("data/toy_base_uruguay.rda")

toy2 <- isco08_to_isco88_4digit(toy_base_uruguay, "f71_2")

comparison <- toy2[, c("ISCO4D", "ISCO.88")]