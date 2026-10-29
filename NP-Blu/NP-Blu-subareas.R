#### North Pacific Blue whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### Eastern N. Pacific
# north pacific ####
areasNP <- goas %>% filter(name == "North Pacific Ocean" ) %>% st_intersection(ne_10m_ocean) %>% select(geometry) %>% mutate(subareas = "NP")
m <- mappingf(areasNP); m
str1 = c("POLYGON((-60 -10, -180 -10, -180 90, -60 90, -60 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasENP <- st_intersection(st_make_valid(cliparea), areasNP) %>% mutate(subareas = "E.N. Pacific", accuracy = "accurate", large_area = "NP", species = "Blu", survey = "", source = "area derived from GOAS v1 downloaded from https://marineregions.org/sources.php#goas")
mappingf(areasENP)

#### US West Coast
us1 <- eezs %>% filter(UNION == "United States") %>%
  st_make_valid() %>% st_intersection(areasNP) %>% select(geometry) %>%
  mutate(subareas = "US West coast", accuracy = "approximate", large_area = "NP", species = "Blu", survey = "", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")
wcus <- us1
mappingf(wcus)

#### JARPNII - 7+8+9
jarpnii <- "NP-JARPNII/JARPNII.shp"
jarpniipoly <- st_read(jarpnii) %>%
  filter(subareas %in% c('7','8','9'))  %>% summarize() %>% st_intersection(ne_10m_ocean) %>% 
  mutate(species = "Blu", subareas = "7+8+9", accuracy = "accurate", large_area = "NP", survey = "JARPNII", source = "based in coordinates from maps")
mappingf(jarpniipoly)

#### Hawaiian EEZ
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "Blu", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")

#### final output ####
output <- dplyr::bind_rows(list(Hawaii, wcus, areasENP, jarpniipoly)) 
View(output)
#make map
areas_bbox <- st_bbox(output)
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
write_sf(output, "NP-Blu/NP-Blu-subareas.shp",append=FALSE)
