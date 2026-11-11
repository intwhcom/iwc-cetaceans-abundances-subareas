#### SH Blue whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#Madagascar Plateau
g1 <- "POLYGON ((40 -25, 45 -25, 45 -35, 40 -35, 40 -25))"
#S of Sri Lanka
g2 <- "POLYGON ((80 5.88333, 80 5.466667, 80.33333 5.466667,80.33333 5.88333, 80 5.88333))"
#W. Australia
g3 <- "POLYGON ((112 -18, 112 -33, 117 -33, 117 -18, 112 -18))"
#W. Australia (Perth Canyon)
g4 <- "POLYGON ((114.053029 -31.121913, 116.085499 -30.999568, 116.476341 -33.175748, 114.037413 -32.974474, 114.053029 -31.121913))"
#Isla Grande de Chiloe
g5 <- "POLYGON ((-71.147968 -39.532223, -71.618841 -44.350203, -75.661810 -44.350203, -75.661810 -39.532223, -71.147968 -39.532223))"
#S. Australia
g6 <- "POLYGON ((115 -35, 115 -45, 125 -45, 125 -35, 115 -35))"
g <- c(g1, g2, g3, g4, g5, g6)
s <- c(
  'Madagascar Plateau',
  'S of Sri Lanka',
  'W. Australia',
  'W. Australia (Perth Canyon)',
  'Isla Grande de Chiloe',
  'S. Australia'
)
out1 <- wktfunction(GEOM = g, Subareas = s) %>% select(subareas, geometry) %>% mutate(accuracy = "approximate", survey = "", large_area = c("IO","IO","IO","IO","SEP","SH"), species = "Blu", source = "made from approximate coordinates")
mappingf(out1)

#Chilean Northern Patagonia
CNP <- st_read("SH-Blu/georeferenced/Chilean Northern Patagonia.shp") %>% select(geometry) %>%
  mutate(accuracy = "approximate", survey = "", large_area = "SEP", species = "Blu", subareas = c("Chilean Northern Patagonia"), source = "georeferenced")
mappingf(CNP)
#coast of Chile	IDCR/SOWER
CoC <- st_read("SH-Blu/georeferenced/coast of Chile.shp") %>% select(geometry) %>%
  mutate(accuracy = "approximate", survey = "IDCR/SOWER", large_area = "SEP", species = "Blu", subareas = c("coast of Chile"), source = "georeferenced")
mappingf(CoC)

#New Zealand
NZ <- eezs  %>% filter(UNION %in% c("New Zealand")) %>%
  st_intersection(goas) %>% select(geometry) %>%
  mutate(accuracy = "approximate", survey = "", large_area = "SP", species = "Blu", subareas = c("New Zealand"), source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")
mappingf(NZ)

#JARPA/JARPAII
jj2 <- st_read("SH-JARPA-JARPAII/JARPA-JARPAII-areas.shp")%>% filter(subareas %in% c("Areas IIIE+IV+V+VIW", "Area IV", "Area V"), species == "Ablu", survey == "JARPA/JARPAII") %>% mutate(source = "based on known coordinates derived from maps", survey = "JARPA+JARPAII")

#Area III SOWER
a3s<- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp")%>% filter(subareas %in% c("Area III"), species == "Ablu") %>% mutate(source = "based on coordinates derived from maps")

#Circumpolar-S of 60S
c60s1 <- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp") %>% filter(subareas %in% c("Circumpolar-S of 60S"), species == "Ablu") %>% mutate(source = "based on coordinates derived from maps", large_area = "SO")
c60s2 <- c60s1 %>% mutate(survey = "")

# Sri Lanka
sl18 <- st_read("SH-Blu/georeferenced/srilanka2018.shp") %>% st_union() %>% st_sf() %>% mutate(subareas="Sri Lanka", accuracy = "approximate", survey="", large_area="IO", species = "Blu", source = "georeferenced")
mappingf(sl18)

#### final output ####
output <- dplyr::bind_rows(list(out1, CNP, CoC, NZ, jj2, a3s, c60s1, c60s2, sl18)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
#save 
write_sf(output, "SH-Blu/SH-Blu-subareas.shp")

