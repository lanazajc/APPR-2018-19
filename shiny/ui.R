library(shiny)

fluidPage(
  titlePanel(""),

tabPanel("Graf",
         sidebarPanel(
          selectInput("Leto", label = "Izberi leto", 
                       choices = unique(place_dejavnosti$Leto))),
         mainPanel(plotOutput("graf_dejavnosti")))
)

