# Short-finned pilot whale #

source("set up and functions.R")

#### Hawaiian EEZ - SPlt
Hawaii3 <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "SPlt", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")

View(Hawaii3)
m <- mappingf(Hawaii3); m
write_sf(Hawaii3, "NA-NP-Plt/NP-SPlt-subareas.shp")

