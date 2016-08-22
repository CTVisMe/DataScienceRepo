# ui.R

shinyUI(fluidPage(
  
  titlePanel("What's in a name?"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("name", "Name:", value = "Garrett"),
      h1(textOutput("total")),
      "people have had this name",
      h1(textOutput("peak")),
      "peak year"
    ),
    
    mainPanel(plotOutput("trend"))
  )
))
