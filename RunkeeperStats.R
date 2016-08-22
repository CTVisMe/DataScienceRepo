

source("DataScience/RFirst.R")


cardio=read.csv('~/DataScience/DataSets/runkeeper/cardioActivities.csv',stringsAsFactors=FALSE,na.strings="")
names(cardio)=qw("dt type routename distance duration pace speed calories climb hr notes gpx")
cardio$dt=parse_date_time(cardio$dt,"ymd_hms")
cardio=mutate(cardio,year=year(cardio$dt))

# count number of events of each type per year:

## first one counts total records by year, separating by type
cardio2=subset(cardio,type %in% qw('Cycling Running'))
g=ggplot(cardio2,aes(x=factor(year),fill=type))
g1=g+
  scale_fill_manual(values=cbPalette) +
  geom_bar(position='dodge') +
  labs(x="Year",y="Total Events",title="Total Events by Year")

### now, we plot total miles by year..
g=ggplot(cardio2,aes(x=factor(year),weight=distance,fill=type))
g2=g+
  scale_fill_manual(values=cbPalette) +
  geom_bar(position='dodge') +
  labs(x="Year",y="Milage",title="Total Milage by Year")

### put both on same page

multiplot(g1,g2,cols=2)

 

