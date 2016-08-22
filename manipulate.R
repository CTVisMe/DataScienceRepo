# testing usage of the manipulate function

# manipulate used to change colors on plot
# try and do a smooth parameter with manipulate

library(manipulate)
library(lubridate)
library(ggplot2)
source("~/DataScience/RFirst.R")

datafile="~/DataScience/DataSets/LatestWeight.csv"
weight=read.csv(datafile,header=T)
names(weight)=qw("ts wt fat comments")
#weight$ts = parse_date_time(weight$ts,"%Y-%m-%d %H:%M %p")
weight$ts = parse_date_time(weight$ts,"%m/%d/%y %H:%M")


plot(weight$ts,weight$wt,type='p',pch=21,bg="orange")

## this works
manipulate(
  plot(weight$ts,weight$wt,type='p',pch=21,bg=col),
  col=picker("b" = "blue",
                "y" = "yellow",
                "r" = "red")
)
###

manipulate(
  plot(weight$ts,weight$wt,type='p',subset=1:10,pch=21,bg=col),
  col=picker("b" = "blue",
             "y" = "yellow",
             "r" = "red")
)



plot(weight$ts,weight$wt,type='p',pch=21,bg="orange")

  
p=ggplot(weight,aes(ts,wt),main="Plot") + 
  geom_point(alpha=0.8) + 
  stat_smooth(method="loess",size=2,se=FALSE,span=0.03) 

## this does not seem to load the sliders

manipulate(
  ggplot(weight,aes(ts,wt),main="Plot") + 
    geom_point(alpha=alpha_pick) + 
    xlab("") + ylab("Daily Weight") +
    stat_smooth(method="loess",size=2,se=FALSE,span=span_pick),
  span_pick = slider(0.01,2,0.1,"Span of Smoother"),
  alpha_pick = slider(0.01,1,0.4,"Transparency")
  )

