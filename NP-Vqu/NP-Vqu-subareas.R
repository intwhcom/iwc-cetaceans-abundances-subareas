# vaquita #
#~~~~~~~~~#

source("set up and functions.R")

vqu <- allmms %>% filter(sci_name == "Phocoena sinus") %>% select(geometry) %>% mutate(species = "Vqu", accuracy = "approximate", large_area="NP", subareas = "Upper Gulf of California", source = "derived from IUCN distribution maps: https://www.iucnredlist.org/resources/spatial-data-download")

View(vqu)
m <- mappingf(vqu); m
write_sf(vqu, "NP-Vqu/Vqu-subareas.shp")
