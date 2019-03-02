
# UVOZ 1. TABELE: plače glede gospodarsko dejavnost


stolpci <- c("Dejavnost", "Izobrazba", "Spol", 2010:2015)

place_dejavnost_izobrazba <- read_csv2("podatki/dejavnost_izob.csv", 
                                       col_names = stolpci, 
                                       skip=4, na=c("", "-", " "),
                                       locale=locale(encoding="Windows-1250"))

place_dejavnost_izobrazba <- place_dejavnost_izobrazba  %>% fill(1:2) %>% drop_na(3) %>%
  melt(id.vars=stolpci[1:3], variable.name="Leto", value.name="Placa") 

# podatki/ pred imenom datoteke, ker mamo za directory nastavljen na glavno mapo
#col_names nastavimo imena stolpcev
#skip 4 - izpusti prve 4 vrstice
#znake ""," " in "-" nadomesti z NA, da lahko v nadaljevanju uporabimo drop_na

#fill zapolne prazne vrstice v stolpcu z enako vrednostjo kot v zgornji vrstici, vse do naslednjega polnega polja
#drop_na izpusti/izbriše vse vrstice kjer imamo NA (argument je stolpce kjer išče NA)
#melt spremeni prejšnje stolpce ( 2010:2015 v en stolpec z letom in enim s plačo)

# UVOZ 2. TABELE: Plače po regijah in starosti 2010-2014 

stolpci2 <- c("Regija", "Starost", 2010:2015)

regija_starost <- read_csv2("podatki/regija_leto.csv", col_names = stolpci2, skip=3,
                            n_max=96, na=c(" ", "", "z"), locale=locale(encoding="Windows-1250"))

#names(regija_starost)[3:8] <- c("2010", "2011", "2012", "2013", "2014", "2015")

regija_starost <- regija_starost %>% fill(1) %>% drop_na(2) %>% melt(id.vars=stolpci2[1:2], 
                  variable.name="Leto", value.name = "Placa", na.rm = TRUE) %>%
  mutate(Leto=parse_number(as.character(Leto)))
#regija_starost <- regija_starost[!(regija_starost$Starost=="65 let ali več"), ]
#regija_starost <- regija_starost[!(regija_starost$Leto==2015), ]

povp_starost <- regija_starost %>% filter(Starost=="15-64 let") %>% select(-Starost)
regija_starost <- regija_starost[!(regija_starost$Starost=="15-64 let"), ]

sprememba <- povp_starost %>% filter(Leto==2010 | Leto==2014)

# UVOZ 3. TABELA: Minimalne plače po državah

min_place <- read_html("podatki/minimalne_place.htm") %>% html_node(xpath="//table[@class='infoData']") %>% 
  html_table() %>% melt(id.vars="timegeo", variable.name="leto", value.name="placa") %>%
  mutate(placa=parse_number(placa, na=c(":", ":(z)"), locale=locale(decimal_mark=".", grouping_mark=","))) %>% drop_na(3) 
  
names(min_place)[1:3] <- c("Drzava", "Leto", "Placa")


# UVOZ 4. TABELE:  BDP po državah

stolpci_bdp <- c("Leto", "Drzava", "neki", "neki2", "BDP")
bdp <- read_csv("podatki/bdp.csv", col_names =stolpci_bdp, skip=1, na=c(":"))
bdp$neki <- NULL
bdp$neki2 <- NULL
bdp <- bdp[c(2,1,3)]
bdp <- bdp %>% drop_na(3)


#Združila tabeli BDP in min_place po Drzavah za vsa leta 2004-2015

min_place$Leto <- parse_integer(as.character(min_place$Leto))
primerjava <- inner_join(min_place, bdp, by=c("Drzava", "Leto"))
primerjava$Leto.y <- NULL
names(primerjava)[2] <- c("Leto")

#Nova tabela s podatki o min plačah in bdp v 2004 in 2015 ter razlike za analizo.

l2004 <- primerjava %>% filter(Leto==2004)
l2004$Leto <- NULL
names(l2004)[2:3] <- c("Placa v 2004", "BDP v 2004")
l2015 <- primerjava %>% filter(Leto==2015)
l2015$Leto <- NULL
names(l2015)[2:3] <- c("Placa v 2015", "BDP v 2015")

#Tabela s podatki razlike v plači in BDP 2004, 2015:
  
analiza1 <- inner_join(l2004, l2015, by=c("Drzava")) 
analiza1 <- analiza1[!(analiza1$Drzava=="United States"), ]
analiza1 <- analiza1 %>% melt(id.vars='Drzava', variable.name=('Placa'), value.name =('Vrednost')) %>%
  separate(Placa, c("Namen", "Leto"), " v ") %>% mutate(Leto=parse_number(as.character(Leto)))

razlika_plac$'Sprememba v %' = (razlika_plac$`Placa v 2015` - razlika_plac$`Placa v 2004`)/razlika_plac$`Placa v 2004` *100
razlika_plac$Sprememba <- NULL
names(razlika_plac)[6] <- c("Sprememba plače v %")
razlika_plac$"Sprememba BDP v %" = (razlika_plac$`BDP v 2015` - razlika_plac$`BDP v 2004`)/razlika_plac$`BDP v 2004` *100
razlika_plac$`Sprememba v %` <- NULL


#razlika_plac <- razlika_plac[!(razlika_plac$Drzava=="United States"), ]
#analiza1 <- analiza1[order(analiza1$Drzava),]
#g_analiza1 <- ggplot(analiza1, aes(Drzava, Vrednost)) + geom_bar(stat = "identity") + xlab("Podatki") + ylab("Vrednost")
#print(g_analiza1)


graf_place <- analiza1 %>% filter(Namen == "Placa" )
#graf_place <- arrange(graf_place, graf_place$Vrednost)


graf_bdp <- analiza1 %>% filter(Namen == "BDP") %>% mutate(Vrednost=parse_number(as.character(Vrednost)))

graf_dej15 <- place_dejavnost_izobrazba %>% filter(Leto == 2015)
graf_dej15$Leto <- NULL


  
#analiza1$Razlika_Place <- ((analiza1[4]-analiza1[2])*100)/analiza1[2]
#analiza1$Razlika_BDP <- analiza1[5]/analiza1[3]
#names(analiza1)[6:7] <- c("Faktor razlike v plači", "Faktor razlike v BDP")                                   


# RISANJE GRAFOV: RAZLIKA V BDP IN PLAČI V 2004 IN 2015

ggplot(graf_place,aes(x=Drzava, y=Vrednost, fill=factor(Leto))) + geom_col(position="dodge")  + coord_flip() +
  guides(fill=guide_legend("Leto")) + xlab("Država") + ggtitle("Plače za leto 2004 in 2015 po državah")

ggplot(graf_bdp, aes(x=Drzava, y=Vrednost, fill=factor(Leto))) + geom_col(position="dodge") + coord_flip() +
  guides(fill=guide_legend("Leto")) + xlab("Država") + ggtitle("BDP za leto 2004 in 2015 po državah") 

# Graf razlike v spremembi plač in BDP
graf_sprememb <- razlika_plac[, c(1, 6, 7)] %>% melt(id.vars="Drzava", variable.name ="Sprememba", value.name = "Odstotek")
  
ggplot(graf_sprememb, aes(x=Drzava, y=Odstotek, fill=factor(Odstotek), col=Sprememba)) +
          guides(fill=guide_legend("Sprememba")) + coord_flip() +
  geom_point(show.legend= FALSE)

 

  

# geom_bar() + coord_flip() + ylab("Sprememba v %") +
   #xlab("Država") + ggtitle("Sprememba plač in BDP v %")
  

