library(shiny)

function(input, output) {
  
  output$dejavnosti <- renderPlot({
    graf_dejavnosti <- ggplot(place_dejavnosti %>% filter(Leto == input$Leto)) + aes(x=Dejavnost, y=Plača, color=Spol) +
      geom_col(position = "dodge") + guides(fill=guide_legend("Leto")) +
      labs(title = "Plače po dejavnosti in spolu") + theme(plot.title = element_text(hjust = 0.5)) +
      ylab("Plača") + xlab("Dejavnosti")
    print(graf_dejavnosti)
  })
  
 
  
  
  
}

