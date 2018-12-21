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
  melt(id.vars=stolpci[1:3], variable.name="Leto", value.name="Placa") 
  

# mutate(Leto=parse_number(Leto)) izbrisala ukaz ker ni deloval
#fill zapolne prazne vrstice v stolpcu z enako vrednostjo kot v zgornji vrstici, vse do naslednjega polnega polja
#drop_na izpusti/izbriše vse vrstice kjer imamo NA (argument je stolpce kjer išče NA)
#melt spremeni prejšnje stolpce ( 2010:2015 v en stolpec z letom in enim s plačo)

# Uvoz 2. tabela: 

stolpci2 <- c("Regija", "Starost", 2010:2015)

regija_starost <- read.csv2("podatki/regija_leto.csv", col.names = stolpci2,skip=3, 
                            header = FALSE, na=c(" ", ""))

names(regija_starost)[3:8] <- c("2010", "2011", "2012", "2013", "2014", "2015")

regija_starost <- regija_starost %>% fill(1) %>% drop_na(2) %>% melt(id.vars=stolpci2[1:2], 
                                variable.name="Leto", value.name = "Placa") 
  

# Uvoz 3. tabela: 

min_place <- read_html("podatki/minimalne_place.htm") %>% html_node(xpath="//table[@class='infoData']") %>% 
  html_table() %>% melt(id.vars="timegeo", variable.name="leto", value.name="placa") %>%
  mutate(placa=parse_number(placa, na=c(":", ":(z)"), locale=locale(decimal_mark=".", grouping_mark=","))) %>% drop_na(3) 
  
names(min_place)[1:3] <- c("Drzava", "Leto", "Placa")


# Uvoz 4. tabela: BDP 

stolpci_bdp <- c("Leto", "Drzava", "neki", "neki2", "BDP")
bdp <- read_csv("podatki/bdp.csv", col_names =stolpci_bdp, skip=1, na=c(":"))
bdp$neki <- NULL
bdp$neki2 <- NULL
bdp <- bdp[c(2,1,3)]
bdp <- bdp %>% drop_na(3)


