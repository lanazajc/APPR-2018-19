# 3. faza: Vizualizacija podatkov

zemljevid_regij <- uvozi.zemljevid("https://biogeo.ucdavis.edu/data/gadm3.6/gpkg/gadm36_SVN_gpkg.zip", "gadm36_SVN_gpkg", pot.zemljevida ="gadm36_SVN_gpkg",
                                   encoding="Windows-1250")








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

