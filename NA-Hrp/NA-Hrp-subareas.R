# Harbor porpoise #

source("set up and functions.R")

# WG - EG 2024
WG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/West_all_together.shp", subareaname = "WG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "Hrp", source = "personal communication with Heide-Jørgensen")
st_crs(WG24) <- 4326 # Set the CRS
mappingf(WG24)

EG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/East_all_together.shp", subareaname = "EG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "Hrp", source = "personal communication with Heide-Jørgensen")
st_crs(EG24) <- 4326 # Set the CRS
mappingf(EG24)

# output
output <- dplyr::bind_rows(list(EG24, WG24)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
write_sf(output, "NA-Hrp/NA-Hrp-subareas.shp")
