## mapdistance
## https://cran.r-project.org/web/packages/gmapsdistance/gmapsdistance.pdf

#install.packages("gmapsdistance")

library("gmapsdistance")
library(XML) 
library(RCurl)

source("~/Dropbox/temp/mygmapsdistance.R")

myapikey="AIzaSyBEVarjLsY2kfW3wGx7AIkjBQRjXy4Jc64"
## Not run:
#In order to run the following examples
#you will need an API key.

#results=gmapsdistance("50+Olmstead+Road+Morristown+NJ","33+Thomas+Street+NYC","driving",myapikey)

dd=format(Sys.time(),"%Y%m%d.%H%M")
# print(c(results$Time, results$Status))
results=mygmapsdistance("50+Olmstead+Road+Morristown+NJ","33+Thomas+Street+NYC",mode="driving",myapikey)
write(c(dd,results$Time, results$Status),file="~/Dropbox/temp/results.gmaps",append=T,ncol=3)
