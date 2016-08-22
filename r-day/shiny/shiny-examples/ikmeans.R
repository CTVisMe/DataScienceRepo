ikmeans <- function(x, iter.max = 10,
                    algorithm = c("Hartigan-Wong", "Lloyd", "Forgy",
                                  "MacQueen")) {
  if (!require("shiny"))
    stop("Please install the shiny package and try again")
 
  if (ncol(x) != 2)
    stop("ikmeans only works on 2-dimensional data")
 
  palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
    "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))
 
  shiny::runApp(launch.browser=rstudio::viewer, list(
    ui = basicPage(
      plotOutput("plot", clickId = "newCenter"),
      actionButton("ok", "Accept"),
      actionButton("undo", "Undo"),
      actionButton("cancel", "Cancel")
    ),
    server = function(input, output, session) {
      values <- reactiveValues(centers = matrix(numeric(), 0, 2))
 
      clusters <- reactive({
        if (nrow(values$centers) < 2)
          return(NULL)
        kmeans(x, values$centers)
      })
 
      output$plot <- renderPlot({
        colors <- if(is.null(clusters()))
          9
        else
          clusters()$cluster
 
        plot(x, col = colors, pch = 20, cex = 3)
        points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
        points(values$centers, pch = 3, cex = 1.5, lwd = 1.5)
      })
 
      observe({
        if (is.null(input$newCenter))
          return()
        isolate({
          newCenter <- matrix(c(input$newCenter[['x']], input$newCenter[['y']]),
                              1, 2)
          values$centers <- rbind(values$centers, newCenter)
        })
      })
 
      observe({
        if (input$ok == 0)
          return()
        stopApp(clusters())
      })
 
      observe({
        if (input$cancel == 0)
          return()
        stopApp(NULL)
      })
 
      observe({
        if (input$undo == 0)
          return()
        isolate({
          if (nrow(values$centers) > 2)
            values$centers <- values$centers[-nrow(values$centers),]
          else if (nrow(values$centers) == 2)
            values$centers <- matrix(values$centers[1,], 1, 2)
          else if (nrow(values$centers) == 1)
            values$centers <- matrix(numeric(), 0, 2)
        })
      })
    }
  ))
}
 
# Example:
# print(ikmeans(cars))