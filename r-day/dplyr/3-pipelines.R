library(dplyr)
library(nycflights13)
library(ggplot2)

flights <- mutate(flights, 
  date = as.Date(ISOdate(year, month, day)))

hourly_delay <- filter(
  summarise(
    group_by(
      filter(flights, !is.na(dep_delay)), 
      date, hour), 
    delay = mean(dep_delay), 
    n = n()), 
  n > 10
)

hourly_delay <- flights %>% 
  filter(!is.na(dep_delay)) %>%
  group_by(date, hour) %>%
  summarise(
    delay = mean(dep_delay),
    n = n()
  ) %>% 
  filter(n > 10)


# Challenges -------------------------------------------------------------------

flights %>%
  group_by(dest) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE), n = n()) %>%
  arrange(desc(arr_delay))

# You'll learn this shortly
.Last.value %>%
  left_join(airports, c("dest" = "faa"))

flights %>% 
  group_by(carrier, flight, dest) %>% 
  tally(sort = TRUE) %>%
  filter(n == 365)

flights %>% 
  group_by(carrier, flight, dest) %>% 
  filter(n() == 365)

per_hour <- flights %>%
  filter(!is.na(dep_delay)) %>%
  mutate(time = hour + minute / 60) %>%
  group_by(time) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE), n = n())

qplot(time, arr_delay, data = per_hour)
qplot((time - arr_delay / 60) %% 24, arr_delay, data = per_hour)

qplot(time, arr_delay, data = per_hour, size = n) + scale_size_area()
qplot(time, arr_delay, data = filter(per_hour, n > 30), size = n) + scale_size_area()

ggplot(filter(per_hour, n > 30), aes(time, arr_delay)) + 
  geom_vline(xintercept = 5:24, colour = "white", size = 2) +
  geom_point()
