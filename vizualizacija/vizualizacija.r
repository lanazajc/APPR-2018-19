# 3. faza: Vizualizacija podatkov

zemljevid_slovenije <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                                       "SVN_adm1", mapa = "zemljevid_Slovenije", encoding = "UTF-8") %>% fortify()

ggplot() + geom_polygon(data=zemljevid_slovenije, aes(x=long, y=lat, group=group, fill=id)) +
  guides(fill=FALSE) + labs(title ="Regije Slovenije")

# 
Regije <- unique(zemljevid_slovenije$NAME_1)
Regije <- as.data.frame(Regije, stringsAsFactors=FALSE)

visina.place <- povp_starost %>% filter(Leto==2014)
visina.place <- visina.place[c(-2,-3)]

#združevanje <- left_join(visina.place, Regije, by="Regija")

#zemljevid_slovenije$NAME_1 <- factor(zemljevid_slovenije$NAME_1, levels=levels(povp_starost$Regija))
#zemljevid_slovenije <- fortify(zemljevid_slovenije)

# Uvozimo zemljevid.

