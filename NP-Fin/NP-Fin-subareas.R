#### North Pacific Fin whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### Eastern N. Pacific
# north pacific ####
areasNP <- goas %>% filter(name == "North Pacific Ocean" ) %>% 
  select(geometry) %>% mutate(subareas = "NP")
str1 = c("POLYGON((-60 -10, -180 -10, -180 90, -60 90, -60 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasENP <- st_intersection(st_make_valid(cliparea), areasNP) %>% 
  mutate(subareas = "E.N. Pacific", accuracy = "accurate", large_area = "NP", species = "Fin", survey = "", source = "area derived from GOAS v1 downloaded from https://marineregions.org/sources.php#goas")
mappingf(areasENP)

#### Hawaiian EEZ
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>% select(subareas,geometry) %>% mutate(species = "Fin", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")

#7+8+9 ####
sen <- st_read("NP-Mi/NP-minkes-subareas.shp") %>% 
  select(subareas, geometry) %>% filter(subareas == "7+8+9") %>% 
  distinct() %>% st_intersection(ne_10m_ocean) %>%
  mutate(subareas = "7+8+9", species = "Fin",accuracy = "accurate", large_area = "NP", source = "original coordinates derived from IWC maps and corrected manually in QGIS") %>% 
  mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(sen)

#Gulf of Alaska
goa <- IHOseas %>% filter(NAME == "Gulf of Alaska") %>% 
  select(geometry) %>% 
  mutate(subareas = "Gulf of Alaska", species = "Fin",accuracy = "approximate", large_area = "NP", source = "polygons derived from World Seas IHO (version 3) from https://marineregions.org", survey = "") 
mappingf(goa)

#eastern Bering Sea shelf
ebs <- st_read("NP-Fin/georeferenced-drawn/east bering sea.shp") %>% 
  select(geometry) %>% 
  mutate(survey = "", species = "Fin", accuracy = "approximate", large_area="NP", subareas = "eastern Bering Sea shelf", source = "drawn in QGIS based on maps and on the polygons derived from World Seas IHO (version 3) from https://marineregions.org")
mappingf(ebs)

#US West coast
uswc <- st_read("NP-Fin/georeferenced-drawn/US West coast.shp") %>% 
  select(geometry) %>% 
  mutate(species = "Fin", accuracy = "approximate", large_area="NP", subareas = "US West coast", source = "derived by intersecting the US EEZ with the NP; polygons derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) and World Seas IHO (version 3) https://marineregions.org", survey = "")
mappingf(uswc)

#Canadian continental shelf
ccs <- st_read("NP-Fin/georeferenced-drawn/canadian continental shelf.shp") %>% 
  select(geometry) %>% 
  mutate(species = "Fin", accuracy = "approximate", large_area="NP", subareas = "Canadian continental shelf", source = "derived by intersecting the US EEZ with the NP; polygons derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) and World Seas IHO (version 3) https://marineregions.org", survey = "")
mappingf(ccs)

#### final output ####
output <- dplyr::bind_rows(list(Hawaii, areasENP, sen, goa, ebs, uswc, ccs)) 
View(output)
#make map
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
write_sf(output, "NP-Fin/NP-Fin-subareas.shp",append=FALSE)
