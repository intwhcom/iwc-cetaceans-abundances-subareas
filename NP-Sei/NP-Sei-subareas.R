#### North Pacific Sei whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### JARPNII areas ####
jarpnii <- "NP-JARPNII/JARPNII.shp"
jarpniipoly <- st_read(jarpnii) %>% 
  st_intersection(ne_10m_ocean) %>%
  filter(subareas %in% c('7','8','9','7CN','7CS','7E','7WRN','7WRS','9-N','9-S',"N of 35N, 140E-170E")) %>% mutate(species = "Sei", source = "based in coordinates from maps") %>% mutate(survey = list(c("","JARPNII"))) %>% unnest(survey)
m <- mappingf(jarpniipoly); m

#### POWER ####
#2010-2012 survey area
str1 = c("POLYGON((-130 40,-130 62, -180 62, -180 40, -130 40))","POLYGON((180 40,170 40, 170 55, 180 55, 180 40))")
subareas1 = c("Central & Eastern NP", "Central & Eastern NP")
subas <- st_as_sf(data.frame(subareas = subareas1, geometry=str1,accuracy = "approximate", survey = "POWER"),wkt="geometry", crs = 4326)
power1 <- st_intersection(st_make_valid(subas), ne_10m_ocean)
m <- mappingf(power1); m

Bering <- IHOseas %>% filter(NAME %in% c("Bering Sea"))
power2 <- st_difference(power1, Bering) %>% select(subareas,accuracy,survey,geometry) %>% mutate(species = "Sei", large_area = "NP", source = "derived from World Seas IHO v2 and known coordinates of the POWER survey area")
m <- mappingf(power2); m

#### Eastern N. Pacific ####
# north pacific ####
areasNP <- goas %>% filter(name == "North Pacific Ocean" ) %>% select(geometry) %>% mutate(subareas = "NP")
m <- mappingf(areasNP); m
str1 = c("POLYGON((-60 -10, -180 -10, -180 90, -60 90, -60 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasENP <- st_intersection(st_make_valid(cliparea), areasNP) %>% mutate(subareas = "E.N. Pacific", accuracy = "accurate", large_area = "NP", species = "Sei", survey = "", source = "derived from marineregions GOAS v1 and known coordinates")
m <- mappingf(areasENP); m

#### US West coast ####
us1 <- eezs %>% filter(UNION == "United States") %>%
st_make_valid() %>% st_intersection(areasENP) %>% select(geometry) %>%
  mutate(subareas = "US West coast", accuracy = "approximate", large_area = "NP", species = "Sei", survey = "", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")
wcus <- us1[1,]
m <- mappingf(wcus); m

#### Hawaiian EEZ ####
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "Sei", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")

#### final output ####
output <- dplyr::bind_rows(list(Hawaii, wcus, areasENP, power2, jarpniipoly)) 
View(output)
areas_bbox <- st_bbox(output)
#make map
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
write_sf(output, "NP-Sei/NP-Sei-subareas.shp",append=FALSE)
