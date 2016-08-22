# ui.R

shinyUI(fluidPage(
  
  titlePanel("What's in a name?"),
  
  fluidRow(
    column(4,
      wellPanel(
        textInput("name", "Name:", value = "Garrett"))),
    column(4,
      wellPanel(
        h1(textOutput("total")),
        "people have had this name")),
    column(4, 
      wellPanel(
        h1(textOutput("peak")),
        "peak year"))),
  
  fluidRow(plotOutput("trend"))
))
