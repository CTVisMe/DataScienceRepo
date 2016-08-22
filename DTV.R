
# explore my DTV data using dplyr
# data comes from Siva email - ctv_ams_Pgm_vw_events_dtl
library(shiny)
library(dplyr)
library(lubridate)

read_data_dtv=function(){
  dtv=read.csv("~/Google\ Drive/DTV-CTV.csv",header=T,stringsAsFactors=FALSE)
  attach(dtv)
  mydtv=data.frame(
   index=ams_event_seq_num,
   event.type=as.factor(ams_event_type),
   channel=as.factor(ams_chan_obj_id),
   event.source=as.factor(ams_event_source),
   channel.name=as.factor(chan_name),
   duration=as.numeric(pgm_vw_dur_sec),
   view.start=parse_date_time(pgm_vw_bgn_time,"%m/%d/%y %H:%M"),
   view.end=parse_date_time(pgm_vw_end_time,"%m/%d/%y %H:%M"),
   title=as.character(pgm_title_name),
   prog.type=as.factor(pgm_type_desc),
   genre.prim=as.character(prim_genre_cat_desc),
   ppv=ppv_flag
  )
return(mydtv)
}

mydtv=read_data_dtv()

mydtv %>%
  group_by(title) %>%
  summarize(n=n(),meandur=mean(duration,na.rm=TRUE)) %>%
  filter(desc(meandur)) %>%
  print(n=50)

mydtv %>% 
  filter(duration > 80000)
