#### North Atlantic bowhead Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#WG 1998 ####
shp2 <- "NA-Bow/georeferenced/WG ALT 1998.shp"
wg98 <- st_read(shp2) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "GL", large_area = "NA", species = "Bow", source = "georeferenced", subareas = "WG-98")
mappingf(wg98)

#WG 2006 april ####
shp1 <- "NA-Bow/georeferenced/WG-06.shp"
wg06 <- st_read(shp1) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "GL", large_area = "NA", species = "Bow", source = "georeferenced", subareas = "WG-06")
mappingf(wg06)

#WG 2012 ####
shp3 <- "NA-Bow/georeferenced/WG-2012.shp"
wg12 <- st_read(shp3) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "GL", large_area = "NA", species = "Bow", source = "georeferenced", subareas = "WG-2012")
mappingf(wg12)

#WG-Feeding area ####
shp4 <- "NA-Bow/georeferenced/WG-feed.shp"
wgf <- st_read(shp4) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Bow", source = "georeferenced", subareas = "WG-feeding area")
mappingf(wgf)

#Baffin Bay-Davis Strait ####
shp1a <- st_read("NA-Bow/georeferenced/Prince Regent GoBoothis 2002.shp")
shp2a <- st_read("NA-Bow/georeferenced/eclispe sound 2002.shp")
BBDS <-  dplyr::bind_rows(list(shp1a, shp2a)) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Bow", source = "georeferenced", subareas = "BB-DS")
mappingf(BBDS)

#Foxe Basin – Hudson Bay ####
shp5 <- "NA-Bow/georeferenced/FB-HF 2003.shp"
FBHB<- dissolve(shp5,"FB-HB") %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Bow", source = "georeferenced", subareas = "FB-HB")
mappingf(FBHB)

#Isabella Bay ####
shp6 <- "NA-Bow/georeferenced/isabella bay hand drawn.shp"
IB <- st_read(shp6) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Bow", source = "hand drawn based on map in the paper", subareas = "Isabella Bay")
mappingf(IB)

# Svaldbard
shp7 <- "NA-Bow/georeferenced/svaldbardN.shp"
NSLDB <- st_read(shp7) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Bow", source = "georeferenced", subareas = "Svalbard N.")
mappingf(NSLDB)

#east canada - west greenland
shp8 <- "NA-Bow/georeferenced/ECWG.shp"
ECWG<- st_read(shp8) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Bow", source = "build from survey points by taking their convex hull and adding a 1DD buffer", subareas = "EC-WG")
mappingf(ECWG)

#final output:
output <- dplyr::bind_rows(list(wg98, wg06, wg12, wgf, IB, FBHB, BBDS, ECWG, NSLDB)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
write_sf(output, "NA-Bow/NA-Bow-subareas.shp", delete_dsn=T)

