library(dplyr)
library(nycflights13)
library(ggplot2)

flights <- mutate(flights, 
  date = as.Date(ISOdate(year, month, day)))

# Create new sqlite3 database
nycflights_db <- nycflights13_sqlite(".")

# Once you have the data in the database, connect to it, instead of 
# loading data from disk
flights_db <- nycflights_db %>% tbl("flights")
weather_db <- nycflights_db %>% tbl("weather")
planes_db <- nycflights_db %>% tbl("planes")
airports_db <- nycflights_db %>% tbl("airports")

# You can now work with these objects like they're local data frames
flights_db %>% filter(dest == "SFO")
flights_db %>% left_join(planes_db)

# Note that you often won't know how many rows you'll get - that's an expensive
# operation (requires running the complete query) and dplyr doesn't do that
# unless it has to.

# Operations are lazy: they don't do anything until you need to see the data
hourly <- flights_db %>%
  filter(!is.na(hour)) %>%
  group_by(year, month, day, hour) %>%
  summarise(n = n(), arr_delay = mean(arr_delay))

# Use explain to see SQL and get query plan
hourly %>% explain()
hourly

# Use collect to pull down all data locally
hourly_local <- collect(hourly)
hourly_local

flights_db %>% 
  filter(!is.na(dep_delay)) %>%
  group_by(date, hour) %>%
  summarise(
    delay = mean(dep_delay),
    n = n()
  ) %>% 
  filter(n > 10) %>% explain()
