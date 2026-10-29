#### SH various whales - Circumpolar ####

source("set up and functions.R")

#SOWER
sower<- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp")

Sei <- sower %>% filter(subareas == "Circumpolar-S of 60S", species == "AMi") %>% mutate(species = "Sei") %>% mutate(source = "based on coordinates derived from maps", large_area = "SO")
HuDol <- sower %>% filter(subareas == "Circumpolar-S of 60S", species == "AMi") %>% mutate(species = "HuDol") %>% mutate(source = "based on coordinates derived from maps", large_area = "SO")
KiWa <- sower %>% filter(subareas == "Circumpolar-S of 60S", species == "AMi") %>% mutate(species = "KiWa") %>% mutate(source = "based on coordinates derived from maps", large_area = "SO")
SoBottlW <- sower %>% filter(subareas == "Circumpolar-S of 60S", species == "AMi") %>% mutate(species = "SoBottlW") %>% mutate(source = "based on coordinates derived from maps", large_area = "SO")

#### final output ####
output <- dplyr::bind_rows(list(Sei, HuDol, KiWa, SoBottlW)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)

#save 
write_sf(output, "SH-Sei-HuDol-KiWa-SoBottlW/SH-various-circumpolar-subareas.shp")
