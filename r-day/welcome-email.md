The course is hands on, so make sure to bring a laptop with recent versions of R, RStudio and some important packages:
    
        # Make sure you have a recent version of R
        # http://cran.r-project.org/
        stopifnot(getRversion() >= '3.1.0')

        # If you're using RStudio, please make sure you have the latest version
        # http://www.rstudio.com/products/rstudio/download/preview/
        if (identical(.Platform$GUI, "RStudio")) {
          stopifnot(packageVersion("rstudio") >= "0.98.1028")
        }

        # Install the packages you'll need
        install.packages(c("dplyr", "ggvis", "shiny", "knitr", "rmarkdown",
          "nycflights13", "babynames", "forecast", "devtools"))

You'll be able to get slides, code and data from http://bit.ly/rday-strata14 (we're still loading it up, but it'll all be there by Thursday!)

If you have any problems getting set up, please email me (hadley@rstudio.com), or come in a few minutes early on Wednesday and we'll troubleshoot in person.

Hadley
