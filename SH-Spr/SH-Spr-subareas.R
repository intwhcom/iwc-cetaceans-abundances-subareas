#### SH sperm whales ####
#~~~~~~~~~~#

source("set up and functions.R")

# Circumpolar-S of 60S
c60s1 <- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp") %>% 
  filter(subareas %in% c("Circumpolar-S of 60S"), species == "Spr") %>% 
  mutate(source = "based on known coordinates derived from maps")

#### final output ####
output <- c60s1 %>% select(subareas, geometry, accuracy, survey, large_area, species,source)
mappingf(output)
View(output)
#save 
write_sf(output, "SH-Spr/SH-Spr-subareas.shp")
