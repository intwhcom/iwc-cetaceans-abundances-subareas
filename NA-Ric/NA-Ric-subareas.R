#### North Atlantic ric Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#US Gulf of Mexico
gom <- st_read("NA-Ric/georeferenced/USGulfMexico.shp") %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Ric", source = "georeferenced", subareas = "US GoMex")
mappingf(gom)

#save####
output <- dplyr::bind_rows(list(gom)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
m <- mappingf(output); m
write_sf(output, "NA-Ric\\NA-Ric-subareas.shp")
