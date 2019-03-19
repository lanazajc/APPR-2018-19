# 4. faza: Napredna analiza podatkov

#NAPOVED RASTI BRUTO MINIMALNE PLAČE V SLOVENIJI

slo_napoved <- min_place %>% filter(Drzava == 'Slovenia')
prileganje <- lm(data = slo_napoved, Placa ~ Leto)
g <- data.frame(Leto=seq(2016, 2020, 1))
napoved <- mutate(g, Placa=predict(prileganje, g))

graf_regresija <- ggplot(slo_napoved, aes(x=Leto, y=Placa)) + 
  geom_point() + geom_smooth(method=lm, fullrange = TRUE, color = 'blue') + 
  geom_point(data=napoved, aes(x=Leto, y=Placa), color='red', size=2) +
  ggtitle('Napoved nadaljne rasti minimalne bruto plače v Sloveniji') + 
  ylab('Plača')
  

placa_v_2018 <- filter(napoved, Leto == 2018)
placa_v_2019 <- filter(napoved, Leto == 2019)
#Realna min. plača v 2018:  842,79€
#Realna min. plača v 2019: 886,63€

