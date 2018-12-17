# 2. faza: Uvoz podatkov


# Uvoz 1. tabela: plače glede gospodarsko dejavnost



stolpci <- c("Dejavnost", "Izobrazba", "Spol", 2010:2015)

place_dejavnost_izobrazba <- read_csv2("podatki/dejavnost_izob.csv", 
                                       col_names = stolpci, 
                                       skip=4, na=c("", "-", " "),
                                       locale=locale(encoding="Windows-1250"))

# podatki/ pred imenom datoteke, ker mamo za directory nastavljen na glavno mapo
#col_names nastavimo imena stolpcev
#skip 4 - izpusti prve 4 vrstice
#znake ""," " in "-" nadomesti z NA, da lahko v nadaljevanju uporabimo drop_na

place_dejavnost_izobrazba <- place_dejavnost_izobrazba  %>% fill(1:2) %>% drop_na(3) %>%
  melt(id.vars=stolpci[1:3], variable.name="Leto", value.name="Placa") %>% mutate(Leto=parse_number(Leto))
  

#fill zapolne prazne vrstice v stolpcu z enako vrednostjo kot v zgornji vrstici, vse do naslednjega polnega polja
#drop_na izpusti/izbriše vse vrstice kjer imamo NA (argument je stolpce kjer išče NA)
#melt

# Uvoz 2. tabela: 

regija_starost <- read.csv2("podatki/regija_leto.csv", col.names = c("Regija", "Starost", 2010:2015),skip=3, header = FALSE)

regija_starost <- regija_starost %>% fill(1)




# Uvoz 3. tabela: 

min_place <- read_html("podatki/minimalne_place.htm") %>% html_node(xpath="//table[@class='infoData']") %>%
  html_table() %>% melt(id.vars="timegeo", variable.name="leto", value.name="placa") %>%
  mutate(leto=parse_number(leto),
         placa=parse_number(placa, na=c(":", ":(z)"), locale=locale(decimal_mark=".", grouping_mark=","))) %>%
  drop_na(placa) 



