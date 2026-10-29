#Hectors#
#~~~~~~~#

source("set up and functions.R")

# Maui
mauishp <- "../../thirdpartydata/Maui_s_Dolphin-Annual_Distribution/Maui_s_Dolphin_(North_Island_Hector_s_Dolphin)_-_Annual_Distribution.shp"
mauipoly <- st_read(mauishp)

mau1 <- mauipoly %>% filter(OBJECTID %in% c(32,42,109)) %>% select(geometry) %>% st_union() %>% st_sf() %>% mutate(species = "Maui", accuracy = "accurate", large_area="SP", subareas = "North Island", source = "derived from https://catalogue.data.govt.nz/dataset/mauis-dolphin-north-island-hectors-dolphin-annual-distribution1/resource/b7b76c3b-64d6-4c92-8a81-d830e28e4283")
mappingf(mau1)

write_sf(mau1, "SH-Hectors/SP-Maui-subareas.shp")
