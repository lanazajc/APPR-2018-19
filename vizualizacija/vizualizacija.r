# 3. faza: Vizualizacija podatkov

zemljevid_slovenije <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                                       "SVN_adm1", mapa = "zemljevid_Slovenije", encoding = "UTF-8") %>% fortify()

#Regije <- unique(zemljevid_slovenije$NAME_1)
#Regije <- as.data.frame(Regije, stringsAsFactors=FALSE)

visina.place <- povp_starost %>% filter(Leto==2014) %>% select(-Leto)
#visina.place <- visina.place[c(-2,-3)]
visina.place$Regija[visina.place$Regija == "Posavska"] <- "Spodnjeposavska"
visina.place$Regija[visina.place$Regija == "Primorsko-notranjska"] <- "Notranjsko-kraška"

#združevanje <- left_join(visina.place, Regije, by="Regija")

#zemljevid_slovenije$NAME_1 <- factor(zemljevid_slovenije$NAME_1, levels=levels(povp_starost$Regija))
#zemljevid_slovenije <- fortify(zemljevid_slovenije)

# Uvozimo zemljevid.

zemljevid.place <- zemljevid_slovenije %>% left_join(visina.place, by=c("NAME_1"="Regija"))

map <- ggplot(zemljevid.place, aes(x=long, y=lat, fill=Placa, label=paste0(NAME_1, "\n", Placa))) +
  geom_polygon(aes(group=group)) +
  geom_text(data=zemljevid.place %>% group_by(NAME_1, Placa)  %>% summarise(long=mean(long), lat=mean(lat)), size=3, colour='red') +
  labs(title ="Višina povp. bruto plače po regijah Slovenije") 



# RISANJE GRAFOV: RAZLIKA V BDP IN MIN. PLAČI V 2004 IN 2015

graf1 <- ggplot(graf_place,aes(x=Drzava, y=Vrednost, fill=factor(Leto))) + geom_col(position="dodge")  + coord_flip() +
  guides(fill=guide_legend("Leto")) + xlab("Država") + ggtitle("Min. plače za leto 2004 in 2015 po državah")


graf2 <- ggplot(graf_bdp, aes(x=Drzava, y=Vrednost, fill=factor(Leto))) + geom_col(position="dodge") + coord_flip() +
  guides(fill=guide_legend("Leto")) + xlab("Država") + ggtitle("BDP za leto 2004 in 2015 po državah") 


# Graf razlike v spremembi min. plač in BDP
graf_sprememb <- rast[, c(1, 6, 7)] %>% melt(id.vars="Drzava", variable.name ="Sprememba", value.name = "Odstotek")

graf3 <- ggplot(graf_sprememb, aes(x=Drzava, y=Odstotek, col=Sprememba)) +
  guides(fill=guide_legend("Sprememba")) + coord_flip() + ggtitle("Sprememba min. plač in BDP med letoma 2004 in 2015") +
  geom_point() + xlab('Država')


# GRAF plač po dejavnostih in spolu

graf4 <- ggplot(place_dejavnosti %>% filter(Leto == 2016), aes(x=Oznaka, y=Plača, fill=factor(Spol))) + geom_col(position = "dodge") + 
  guides(fill=guide_legend("Spol")) + coord_flip() + ggtitle("Plače po dejavnostih in spolu v letu 2016") + xlab('Dejavnost') 









