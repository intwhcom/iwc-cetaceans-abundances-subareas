#### Southern right whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#Australia southwest coast
SWAustralianCoast <- st_read("SH-Srht/georeferenced-drawn/SWAustralianCoast.shp") %>% 
  select(geometry, subareas) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "SH", species = "Srht", source = "georeferenced")
mappingf(SWAustralianCoast)

#SE Australian coast
SEAustralianCoast <- st_read("SH-Srht/georeferenced-drawn/SEAustralianCoast.shp") %>% select(geometry) %>% mutate(subareas = "SE Australian coast", accuracy = "approximate", survey = "", large_area = "SH", species = "Srht", source = "drawn based on a map derived from the original paper")
mappingf(SEAustralianCoast)

#Brazil coast
g1 <- "POLYGON ((-49.763 -29.396, -48.533 -29.396, -48.533 -27.797, -49.763 -27.797, -49.763 -29.396))"
#New Zealand - 140W,140E,28S,60S
g2 <- "MULTIPOLYGON (((-140 -28, -140 -60, -180 -60, -180 -28, -140 -28)), ((140 -28, 140 -60, 180 -60, 180 -28, 140 -28)))"
#Sub-Antarctic New Zealand
g3 <- "POLYGON ((166.341061 -50.481370, 166.341061 -50.586608, 166.150733 -50.586608, 166.150733 -50.481370, 166.341061 -50.481370))"
g <- c(g1, g2, g3)
s <- c(
  'Brazil coast',
  'New Zealand - 140W,140E,28S,60S',
  'Sub-Antarctic New Zealand'
)
out1 <- wktfunction(GEOM = g, Subareas = s) %>% select(subareas, geometry) %>% mutate(accuracy = "approximate", survey = "", large_area = "SH", species = "Srht", source = "based on approximate coordinates derived from maps")
mappingf(out1)

#central S. Atlantic (Tristan da Cunha)
TdC<- ihoeezs %>% filter(GEONAME %in% c("British Exclusive Economic Zone (Tristan da Cunha)")) %>% select(geometry) %>%
  mutate(accuracy = "approximate", survey = "", large_area = "SH", species = "Srht", subareas = c("central S. Atlantic (Tristan da Cunha)"), source = "derived from Maritime Boundaries Geodatabase: Maritime Boundaries and Exclusive Economic Zones (200NM), version 12, www.marineregions.org")
mappingf(TdC)

#South African waters
SAw<- ihoeezs %>% filter(GEONAME %in% c("South African Exclusive Economic Zone")) %>% select(geometry) %>%
  mutate(accuracy = "approximate", survey = "", large_area = "SH", species = "Srht", subareas = c("South African waters"), source = "derived from Maritime Boundaries Geodatabase: Maritime Boundaries and Exclusive Economic Zones (200NM), version 12, www.marineregions.org")
mappingf(SAw)

#southwestern Atlantic Ocean
SWAtl <- st_read('SH-Srht/georeferenced-drawn/SWAtl.shp') %>% select(geometry) %>%
  mutate(accuracy = "accurate", survey = "", large_area = "SH", species = "Srht", subareas = c("southwestern Atlantic Ocean"), source = "georeferenced")
mappingf(SWAtl)

#SW Atlantic
#Península Valdés + Southern Brazil (27°-29°S)
PV <- st_read('SH-Srht/georeferenced-drawn/PeninsulaValdes.shp') %>% select(geometry)
SB <- out1 %>% filter(subareas == 'Brazil coast') %>% select(geometry)
out2 <- dplyr::bind_rows(list(PV,SB)) %>% st_union() %>% st_sf() %>%
  mutate(accuracy = "approximate", survey = "", large_area = "SH", species = "Srht", subareas = "SW Atlantic", source = "georeferenced and approximate locations")
mappingf(out2)

#IDCR/SOWER
#IV V I II III VI circumpolar
sower<- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp")%>% filter(species == "Srht") %>% mutate(source = "based on coordinates derived from maps")

#JARPA
#Area IV, Area V
j <- st_read("SH-JARPA-JARPAII/JARPA-JARPAII-areas.shp") %>% 
  filter(subareas %in% c("Area IV", "Area V"), species == "Srht", survey == "JARPA") %>% 
  mutate(source = "based on known coordinates derived from maps")

#JARPA/JARPAII
jj2 <- st_read("SH-JARPA-JARPAII/JARPA-JARPAII-areas.shp") %>% 
  filter(subareas %in% c( "Area IV", "Area V", "Area IIIE", "Area VIW"), species == "Srht", survey == "JARPA/JARPAII") %>% 
  mutate(source = "based on known coordinates derived from maps", survey = "JARPA+JARPAII")

#S.Hem.
SH <- dplyr::bind_rows(list(out1, out2, SWAtl, SWAustralianCoast, TdC,SAw)) %>% st_union() %>% st_sf() %>%
  mutate(accuracy = "approximate", survey = "", large_area = "SH", species = "Srht", subareas = "SH", source = "georeferenced, EEZs and approximate locations")

#### final output ####
output <- dplyr::bind_rows(list(out1, out2, SWAtl, SWAustralianCoast, TdC,SAw, SH, SEAustralianCoast, sower, jj2)) %>% select(subareas, geometry, accuracy, survey, large_area, species,source)
mappingf(output)
View(output)
#save 
write_sf(output, "SH-Srht/SH-Srht-subareas.shp")
