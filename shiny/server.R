library(shiny)

function(input, output) {
  
  output$graf_dejavnosti <- renderPlot({
    graf_dejavnosti <- ggplot(place_dejavnosti %>% filter(Leto == input$Leto)) + aes(x=Oznaka, y=Plača, fill=Spol) +
      geom_col(position = "dodge") + guides(fill=guide_legend("Leto")) +
      labs(title = "Plače po dejavnosti in spolu") + theme(plot.title = element_text(hjust = 0.5)) +
      ylab("Plača") + xlab("Dejavnosti") + coord_flip()
    print(graf_dejavnosti)
  })
  output$legenda <- renderTable(place_dejavnosti %>%
                                  select(Oznaka, Dejavnost) %>% unique())
}

