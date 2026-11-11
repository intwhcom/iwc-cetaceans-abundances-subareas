# Long-finned pilot whale #

source("set up and functions.R")

# NASS 1980
nass89 <- st_read("NA-NP-Plt/georeferenced/NASS89.shp")
nass89a <- nass89 %>% select(geometry) %>% mutate(species = "LPlt", accuracy = "approximate", large_area="NA", subareas = "NASS-89", source = "georeferenced from original paper", survey = "NASS")
View(nass89a)
mappingf(nass89a)

# WG - EG 2024
WG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/West_all_together.shp", subareaname = "WG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "LPlt", source = "personal communication with Heide-Jørgensen")
st_crs(WG24) <- 4326 # Set the CRS
mappingf(WG24)

EG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/East_all_together.shp", subareaname = "EG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "LPlt", source = "personal communication with Heide-Jørgensen")
st_crs(EG24) <- 4326 # Set the CRS
mappingf(EG24)

# output
output <- dplyr::bind_rows(list(nass89a, EG24, WG24)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
write_sf(output, "NA-NP-Plt/NA-LPlt-subareas.shp")

