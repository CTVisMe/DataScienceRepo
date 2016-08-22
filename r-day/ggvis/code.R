library(shiny)
library(ggvis)

## ====================================================================
## Basics
## ====================================================================

# Scatter plot
mtcars %>%
  ggvis(x = ~wt, y = ~mpg) %>%
  layer_points()

# loess smoothing curve
mtcars %>%
  ggvis(x = ~wt, y = ~mpg) %>%
  layer_points() %>%
  layer_smooths()

# Use a linear model instead of loess
mtcars %>%
  ggvis(x = ~wt, y = ~mpg) %>%
  layer_points() %>%
  layer_model_predictions(model = "lm")

# Map another variable to fill color
mtcars %>%
  ggvis(x = ~wt, y = ~mpg, fill = ~cyl) %>%
  layer_points()

# Treat 'cyl' as a categorical variable
mtcars %>%
  ggvis(x = ~wt, y = ~mpg, fill = ~factor(cyl)) %>%
  layer_points()


# Lines
pressure %>%
  ggvis(~temperature, ~pressure) %>%
  layer_lines() %>%
  layer_points()

pressure %>%
  ggvis(~temperature, ~pressure)


# Histograms
cocaine %>% ggvis(x = ~potency) %>% layer_histograms()

cocaine %>% ggvis(~potency)

# =========

iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length) %>%
  layer_points()

iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill = ~Species) %>%
  layer_points()

iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill = ~Species) %>%
  layer_points()


## Basic and compound layers

# Grouping
mtcars %>%
  ggvis(x = ~wt, y = ~mpg, fill = ~factor(cyl)) %>%
  layer_points() %>%
  layer_model_predictions(model = "lm")

mtcars %>%
  group_by(cyl) %>%
  ggvis(x = ~wt, y = ~mpg, fill = ~factor(cyl)) %>%
  layer_points() %>%
  layer_model_predictions(model = "lm")


## Scaled and unscaled values

iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill = ~Species) %>%
  layer_points()

# Mapping "red" to fill
iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill = "red") %>%
  layer_points()

# Setting "red"
iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill := "red") %>%
  layer_points()


# Compare these: how does the output differ, and why?
cocaine %>%
  ggvis(~weight, ~price) %>%
  layer_smooths(stroke = "smooth") %>%
  layer_model_predictions(model = "lm", stroke = "lm")

cocaine %>%
  ggvis(~weight, ~price) %>%
  layer_smooths(stroke := "red") %>%
  layer_model_predictions(model = "lm", stroke := "blue")


# Use ~ to evaluate in the context of the data
Species <- "xyz"
iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill = ~Species) %>%
  layer_points()

# Without ~
Species <- "xyz"
iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill = Species) %>%
  layer_points()

# Setting constant value
iris %>%
  ggvis(x = ~Sepal.Width, y = ~Sepal.Length, fill := ~"red") %>%
  layer_points()



# %>% operator
subset(mtcars, cyl == 6)
mtcars %>% subset(cyl == 6)

summary(subset(mtcars, cyl == 6), digits=2)
mtcars %>% subset(cyl == 6) %>% summary(digits=2)


## ====================================================================
## Reactivity and interactivity
## ====================================================================

## Reactive computation parameters
faithful %>%
  ggvis(x = ~waiting) %>%
  layer_histograms(width = input_slider(min=1, max=20, value=11))

## Reactive properties
mtcars %>%
  ggvis(x = ~wt, y = ~mpg) %>%
  layer_points(
    size := input_slider(10, 400, value=50, label="size"),
    fill := input_select(c("red", "blue"), label="color")
  )

## Reactive data source
dat <- data.frame(time = 1:10, value = runif(10))
# Add a new data point every 2 seconds
ddat <- reactive({
  invalidateLater(2000, NULL)
  dat$time  <<- c(dat$time[-1], dat$time[length(dat$time)] + 1)
  dat$value <<- c(dat$value[-1], runif(1))
  dat
})
ddat %>% ggvis(x = ~time, y = ~value, key := ~time) %>%
  layer_points() %>%
  layer_paths()


## Direct interaction
# This function receives information about the hovered
# point and returns a string to display
all_values <- function(x) {
  if(is.null(x))
    return(NULL)
  paste0(names(x), ": ", format(x), collapse = "<br />")
}

mtcars %>% ggvis(x = ~wt, y = ~mpg) %>%
  layer_points() %>%
  add_tooltip(all_values, "hover")
