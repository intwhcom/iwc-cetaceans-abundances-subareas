# Long-finned pilot whale #

source("set up and functions.R")

#### Hawaiian EEZ - SPlt
nass89 <- st_read("NA-NP-Plt/georeferenced/NASS89.shp")
nass89a <- nass89 %>% select(geometry) %>% mutate(species = "LPlt", accuracy = "approximate", large_area="NA", subareas = "NASS-89", source = "georeferenced from original paper", survey = "NASS")

View(nass89a)
m <- mappingf(nass89a); m
write_sf(nass89a, "NA-NP-Plt/NA-LPlt-subareas.shp")

