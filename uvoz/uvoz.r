# 2. faza: Uvoz podatkov
library(readr)
library(reshape2)
library(dplyr)

# Uvoz 1. tabela: plače glede gospodarsko dejavnost



stolpci <- c("Dejavnost", "Izobrazba", "Spol", 2010:2015)

place_dejavnost_izobrazba <- read.csv2("dejavnost_izob.csv", 
                                       header= FALSE, 
                                       skip=3, na=c("", "-", " "))
           



# Uvoz 2. tabela: 

regija_starost <- read.csv2("regija_leto.csv", col.names = c("Statistična regija", "Starost", 2010:2015),skip=3, header = FALSE)





# Uvoz 3. tabela: 




