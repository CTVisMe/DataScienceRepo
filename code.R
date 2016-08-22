# open by getting packages and functions
setwd("/Users/volinsky/DataScience")
source("RFirst.R")
load(".RData")

### runkeeper data

cardio=read.csv('~/DataScience/DataSets/runkeeper/cardioActivities.csv',stringsAsFactors=FALSE,na.strings="")
names(cardio)=qw("dt type routename distance duration pace speed calories climb hr notes gpx")
cardio$dt=parse_date_time(cardio$dt,"ymd_hms")

measurements=read.csv('~/DataScience/DataSets/runkeeper/measurements.csv')

## babynames



### going to import data sets and play with ggobi2 and dplyr
### Withings Weight File
#datafile="DataSets/Withings.Weight.20150904.csv"
datafile="DataSets/LatestWeight.csv"
weight=read.csv(datafile,header=T)
names(weight)=qw("ts weight fat lean comments")
#weight$ts = parse_date_time(weight$ts, "mdy_hm")
weight$ts = parse_date_time(weight$ts,"%Y-%m-%d %H:%M %p")

plot(weight$weight)

### Health Blood File
datafile="DataSets/CTVBlood.csv"
blood=read.csv(datafile,header=T)
blood$ts=fixyear(mdy(blood$X))


# have to change dates with lubridate functions
weight$ts = parse_date_time(weight$ts, "mdy_hm")
## basic use of qplot

qplot(ts,weight,data=weight)
qplot(ts,Total.Cholesterol,data=blood)


# KML of foursquare data
# see http://stackoverflow.com/questions/20822212/how-to-use-rs-xpathapply-to-extract-kml-coordinates-and-put-them-in-a-dataframe
# and http://gis.stackexchange.com/questions/58131/how-to-efficiently-read-a-kml-file-into-r
require(rgdal)
attach(XML)
kmlfile="DataSets/Foursquare.Checkins.20150904.kml"
system(paste("ogrinfo", "DataSets/Foursquare.Checkins.20150904.kml")) 
  ##  tells me the layer name "foursquare checkin history for Chris V."
map <- readOGR(dsn="DataSets/Foursquare.Checkins.20150904.kml",layer="foursquare checkin history for Chris V.")
# extract coordinates
map.coords = map@coords

doc2<-xmlInternalTreeParse(kmlfile)
# the following prints out the datetimes
doc <- xmlTreeParse(kmlfile, handlers = list(
  published=function(x, attrs) {
    print(xmlValue(x[[1]])); TRUE
  }), asTree=TRUE)
## hey this works too!
## http://stackoverflow.com/questions/20822212/how-to-use-rs-xpathapply-to-extract-kml-coordinates-and-put-them-in-a-dataframe
geodate=unlist(xpathApply(doc2,"/kml//published",xmlValue))
## get gsub right to make this dataset then stop!! 
#Thu, 03 Sep 15 21:41:25 +0000"

date1=gsub("\\w+, (\\d+) (\\w+) (\\d+) (\\d\\d:\\d\\d:\\d\\d) \\+\\d+","\\1 \\2 \\3 \\4",geodate)
date2=parse_date_time(date1,"%d %b %y hms")


## attempt at xml parse that gets names out of the list - need to understand lists better. 
data=xmlParse(kmlfile)
xml_data=xmlToList(data)
namevec=unlist(lapply(xml_data$Folder[3:length(xml_data$Folder)],function(x) {x[["name"]]}))


### Maps and mapping?  OS
foursq=data.frame(longitude=map.coords[,1],latitude=map.coords[,2],name=namevec,dt=date2)

# lets edit out only NAmerica for now:
foursq = foursq[foursq$lon<0,]

## OSM and leaflet??


## coppy from ggmap home page
# osmar is for looking at the underlying data (nodes, roads, etc)
library(ggmap)

# step 1 - download map raster
latr=range(foursq$lat)
lonr=range(foursq$lon)

llvec=c(lonr[1],latr[1],lonr[2],latr[2])

mymap=get_map(location=llvec,source="google",maptype="roadmap", zoom=6,crop=FALSE)

m=ggmap(mymap,extent='normal') 
m + geom_point(data=foursq,aes(x=longitude,y=latitude),alpha=0.4,color='blue')

## random subsetting
ss=month(foursq$dt)==4 # febr
latr=range(foursq[ss,]$lat)
lonr=range(foursq[ss,]$lon)

llvec=c(lonr[1],latr[1],lonr[2],latr[2])
mymap=get_map(location=llvec,source="google",maptype="terrain",zoom=4,crop=FALSE)
m=ggmap(mymap,extent='device')
m + 
    geom_point(data=foursq[ss,],aes(x=longitude,y=latitude),alpha=0.4,color='blue')



qplot(dt,speed,data=cardio,na.rm=T,shape=type)
qplot(dt,speed,data=cardio,na.rm=T) +
  facet_grid(type~.)
qplot(dt,speed,data=cardio,na.rm=T) +
  facet_wrap(~type)

# dplyr
# filter select arrange mutate summarize

library(dplyr)
name.chris=filter(babynames,name=="Christopher")
qplot(year,total, data=name.chris,color=sex,geom="line")

summarize(name.chris,min=min(total),max=max(total),mn=mean(total))
head(arrange(babynames,desc(total)))

# total boys and girls for each year
name.year=group_by(babynames,year,sex)
s=summarize(name.year,tot=sum(total))
arrange(s,desc(tot))
qplot(year,tot,data=s,color=sex,geom='line')

# calculate the rank of each name in each year
ranks=mutate(name.year,rank=rev(order(total))
crank=filter(ranks,name=="Christopher" & sex=="M")
qplot(year,-rank,data=crank,geom="line")

# reshape into names by ranks
library(reshape2)
r2=filter(ranks,sex=="F")
retest=dcast(r2,name~year,value=rank)

filter(babynames,grepl("zia",babynames$name,ignore.case=TRUE)) %>%
  filter(year==2014) %>%
  select(-year)

nameplot=function(inputname,inputsex="M") {
  dd=filter(babynames,name==inputname & sex==inputsex)
  qplot(year,total,data=dd,geom='line',color=name,main="total births by year")
}

paul=filter(babynames,(name %in% qw("Deirdre Alice Carla") & sex=="F") | (name=="Chuck" & sex=="M"))
kids=filter(babynames,name %in% qw("Kezia Keziah Vienna") & sex=="F")
ann=filter(babynames,grepl("^Chris",babynames$name)) %>% filter(total >= 500 & sex=="M")
qplot(year,total,data=ann,color=name,geom="point",shape=name)
## more than 6 types of line - nice job!! 
gp <- ggplot(ann,aes(x=year, y=total, group=name,color=name, shape=name)) +
  scale_shape_manual(values=1:length(unique(ann$name))) +
  labs(title = "Anns", x="Year", y="Total") +
  geom_line() + 
  geom_point(size=3)

gp

qplot(year,total,data=kids,geom='line',color=name,main="total births by year")
nqplot(year,total,data=paul,geom='line',color=name,main="total births by year") 

ggplot(paul,aes(x=year,y=total)) +
  geom_line(aes(color=name)) +
  scale_color_brewer(palette="Spectral")

## use Lahman data
# Lahman
# most all star players?
filter(Alls)
group_by(AllstarFull,yearID,teamID,gameNum) %>% 
  tally(sort=T) %>%   # tally is same as summarize (n=n())
  ungroup() %>% 
  arrange(desc(n))



group_by(AllstarFull,yearID,teamID,gameNum) %>% summarize(n=n())
  tally(sort=TRUE) %>%
  ungroup() %>%
  arrange(desc(n)) %>% View()

filter(AllstarFull,teamID=="PIT",yearID==1960)


### Weight data - using ggplot qplot, and magrittr/dplyr

yrwt=weight %>% 
  group_by(year(ts)) %>%
  summarize(mean(weight))
names(yrwt)=qw("year wt")
qplot(year,wt,data=yrwt,geom="bar",stat="identity",fill=year) 
qplot(year,wt,data=yrwt,geom="line")



ggplot(yrwt,aes(x=year,y=wt)) + geom_bar(stat="identity") + ylim(150,190)

mowt=weight %>% 
  group_by(interaction(month(ts),year(ts))) %>%
  summarize(mean(weight))
names(mowt)=qw("month wt")
qplot(1:nrow(mowt),wt,data=mowt,geom="point")
