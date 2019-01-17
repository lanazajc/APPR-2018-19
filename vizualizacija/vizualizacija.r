# 3. faza: Vizualizacija podatkov

zemljevid_slovenije <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                                       "SVN_adm1", mapa = "zemljevid_Slovenije", encoding = "UTF-8") %>% fortify()


# 
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

ggplot(zemljevid.place, aes(x=long, y=lat, fill=Placa, label=paste0(NAME_1, "\n", Placa))) +
  geom_polygon(aes(group=group)) +
  geom_text(data=zemljevid.place %>% group_by(NAME_1, Placa) %>% summarise(long=mean(long), lat=mean(lat))) +
  labs(title ="Regije Slovenije")
