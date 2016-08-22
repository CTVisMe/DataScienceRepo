library(dplyr)
library(nycflights13)
library(ggplot2)

flights <- mutate(flights, 
  date = as.Date(ISOdate(year, month, day)))

# Motivation: plotting delays on map -------------------------------------------

location <- airports %>% 
  select(dest = faa, name, lat, lon)

delays <- flights %>%
  group_by(dest) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE), n = n()) %>%
  arrange(desc(arr_delay)) %>%
  inner_join(location)

ggplot(delays, aes(lon, lat)) + 
  borders("state") + 
  geom_point(aes(colour = arr_delay), size = 5, alpha = 0.9) + 
  scale_colour_gradient2() +
  coord_quickmap()

delays %>% filter(arr_delay < 0)


# What weather condition is most related to delays? ----------------------------

weather <- mutate(weather, 
  date = as.Date(ISOdate(year, month, day)))

hourly_delay <- flights %>% 
  group_by(date, hour) %>%
  filter(!is.na(dep_delay)) %>%
  summarise(
    delay = mean(dep_delay),
    n = n()
  ) %>% 
  filter(n > 10)
delay_weather <- hourly_delay %>% left_join(weather)

arrange(delay_weather, desc(delay))

qplot(temp, delay, data = delay_weather)
qplot(wind_speed, delay, data = delay_weather)
qplot(wind_gust, delay, data = delay_weather)
qplot(is.na(wind_gust), delay, data = delay_weather, geom = "boxplot")
qplot(precip, delay, data = delay_weather)
qplot(visib, delay, data = delay_weather)
qplot(visib, delay, data = delay_weather, geom = "boxplot", group = visib)

# What plane conditions are most related to delays? ----------------------------

planes %>% group_by(type) %>% tally()
planes %>% group_by(engine) %>% tally()
planes %>% group_by(type, engine) %>% tally()

qplot(year, data = planes, binwidth = 1)
planes %>% filter(year <= 1960) %>% View()

qplot(seats, data = planes, binwidth = 10)

plane_delay <- flights %>% 
  group_by(tailnum) %>%
  summarise(
    n = n(),
    distance = mean(distance),
    delay = mean(dep_delay, na.rm = TRUE)
  )
anti_join(plane_delay, planes) %>% arrange(desc(n)) %>% View()
# What's the common pattern?

plane_delay <- plane_delay %>% left_join(planes)

plane_delay %>% arrange(n)
qplot(n, data = plane_delay, binwidth = 1)
qplot(n, data = plane_delay, binwidth = 1) + xlim(0, 250)

plane_delay <- plane_delay %>% filter(n > 50)
qplot(distance, delay, data = plane_delay)

qplot(year, delay, data = plane_delay)
qplot(year, delay, data = plane_delay) + 
  xlim(1990, 2011) + 
  geom_smooth(span = 0.5, method = "loess")
