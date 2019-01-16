# 3. faza: Vizualizacija podatkov

zemljevid_slovenije <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                                       "SVN_adm1", mapa = "zemljevid_Slovenije", encoding = "Windows-1250") %>% fortify()

ggplot() + geom_polygon(data=zemljevid_slovenije, aes(x=long, y=lat, group=group, fill=id)) +
  guides(fill=FALSE) + labs(title ="Regije Slovenije")

# 
Regije <- unique(zemljevid_slovenije$NAME_1)
Regije <- as.data.frame(regije, stringsAsFactors=FALSE)

visina.place <- povp_starost %>% filter(Leto==2014)
visina.place <- visina.place[c(-2,-3)]

#združevanje <- left_join(visina.place, Regije, by="Regija")

#zemljevid_slovenije$NAME_1 <- factor(zemljevid_slovenije$NAME_1, levels=levels(povp_starost$Regija))
#zemljevid_slovenije <- fortify(zemljevid_slovenije)

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
                             pot.zemljevida="OB", encoding="Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
zemljevid <- fortify(zemljevid)

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))

