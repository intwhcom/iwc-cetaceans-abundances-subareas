#### SH Antarctic Minke whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#SOWER
sower<- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp")%>% filter(species == "AMi") %>% mutate(source = "based on coordinates derived from maps", large_area = "SO")

#### final output ####
output <- sower %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
#save 
write_sf(output, "SH-AMi/SH-AMi-subareas.shp")
