#### SH Fin whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#Circumpolar-S of 60S
FMAs <- st_read("SH-Franciscana/georeferenced/FRA subareas v2.shp") %>% 
  select(geometry, subarea) %>% 
  rename(subareas = subarea) %>%
  mutate(source = "georeferenced",large_area = "SH", accuracy = "approximate", survey = "", species = "Fra",)



#### final output ####
output <- dplyr::bind_rows(list(FMAs)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
#save 
write_sf(output, "SH-Franciscana/SH-Fra-subareas.shp")
