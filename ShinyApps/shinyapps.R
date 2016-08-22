### shinyapps ###
install.packages("devtools")

devtools::install_github('rstudio/shinyapps')
shinyapps::setAccountInfo(name='statpumpkin', 
                          token='37DE14B5B52FD626FDF34BE2C9C15C65', 
                          secret='4dg+RKCX8W7NuJUe6vcPBVoIXJY5bQmXmLhbrBwv')

library(shinyapps)
shinyapps::deployApp('/Users/volinsky/DataScience/ShinyApps')


