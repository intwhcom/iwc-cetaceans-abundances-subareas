#### North Pacific Beluga Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#EBS
EBS <- st_read("NP-Bdu/georeferenced/EBS.shp") %>%
  mutate(accuracy = "approximate", survey = "", large_area = "NP", source = "georeferenced", species = "Bdu", subareas = "EBS")
mappingf(EBS)

#W and NE Okhotsk
wneos <- st_read("NP-Bdu/georeferenced/OKseav1.shp") %>%
  mutate(accuracy = "approximate", survey = "", large_area = "NP", source = "georeferenced", species = "Bdu")
mappingf(wneos)

#ECS
ECS <- st_read("NP-Bdu/georeferenced/ECS.shp") %>%
  mutate(accuracy = "approximate", survey = "ASAMM", large_area = "NP", source = "georeferenced", species = "Bdu", subareas = "ECS")
mappingf(ECS)

#Okhotsk
os <- st_read("NP-Bdu/georeferenced/OkhotskSea.shp") %>%
  mutate(accuracy = "approximate", survey = "", large_area = "NP", source = "georeferenced", species = "Bdu", subareas = "Okhotsk Sea")
mappingf(os)

#### output ####
output <- dplyr::bind_rows(list(EBS, wneos,ECS, os)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
mappingf(output)
View(output)
#save 
write_sf(output, "NP-Bdu/NP-Bdu-subareas.shp")
