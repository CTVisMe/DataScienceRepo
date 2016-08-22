# server.R

library(babynames)
library(dplyr)
library(ggplot2)


shinyServer(function(input, output) {
  
  names <- reactive({
    filter(babynames, name == input$name)
  })

  output$trend <- renderPlot({
    qplot(year, n, data = names(), geom ="line", color = sex) + theme_bw()
  })
  
  output$total <- renderText({
    sum(names()$n)
  })
  
  output$peak <- renderText({
    names()$year[which.max(names()$n)]
  })
  
})

