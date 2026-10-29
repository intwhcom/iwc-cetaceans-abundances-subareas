#### North Pacific Sperm whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### Hawaiian EEZ - DwSpr
Hawaii1 <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "DwSpr", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")

#### Hawaiian EEZ - PySpr
Hawaii2 <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "PySpr", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")

#### JARPNII areas ####
jarpnii <- "NP-JARPNII/JARPNII.shp"
jarpniipoly <- st_read(jarpnii) %>% st_intersection(ne_10m_ocean) %>%
  filter(subareas %in% c("N of 35N, 140E-170E")) %>% mutate(species = "Spr", accuracy = "accurate", large_area="NP", source = "based in coordinates from maps", survey = "JARPNII")
mappingf(jarpniipoly)

#### final output ####
output <- dplyr::bind_rows(list(Hawaii1, Hawaii2,jarpniipoly)) 
View(output)
m <- mappingf(output); m
write_sf(output, "NP-Spr/NP-Spr-subareas.shp")
