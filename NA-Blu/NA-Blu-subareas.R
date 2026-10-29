#### North Atlantic blue Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#NE OPAREA
NE_OPAREA <- st_read("NA-Sei/georeferenced/Palka2006and2020-ocean.shp") %>% 
  st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "approximate", survey = "NEFSC", large_area = "NA", species = "Blu", source = "georeferenced")
mappingf(NE_OPAREA)

#Faroes-Iceland-NASS15 2015
Blk15Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk15\\Blk15Poly.shp"
Blk15 <- dissolve(shp = Blk15Poly, subareaname = "Faroes-Iceland-NASS15") %>% 
  nngeo::st_remove_holes() %>% 
  st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Blu", source = "derived from data shared by NAMMCO")
mappingf(Blk15)

#Iceland-Faroes 1987 ####
Blk87Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk87\\Blk87Poly.shp"
Blk87 <- dissolve(shp = Blk87Poly, subareaname = "Faroes-Iceland-NASS87") %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Blu", source = "derived from data shared by NAMMCO")
mappingf(Blk87)

#1995
Blk95Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk95\\Blk95Poly.shp"
Blk95 <- Blk95Poly %>% dissolve(subareaname = "Faroes-Iceland-NASS95") %>% 
  st_set_crs(st_crs(Blk87)) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Blu", source = "derived from data shared by NAMMCO")
mappingf(Blk95)

#2001
Blk01Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk01\\Blk01Poly.shp"
Blk01 <- dissolve(shp = Blk01Poly, subareaname = "Faroes-Iceland-NASS01") %>%
  st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Blu", source = "derived from data shared by NAMMCO")
mappingf(Blk01)

# NASS 1989 ####
Blk89Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk89\\Blk89Poly.shp"
Blk89 <- dissolve(shp = Blk89Poly, subareaname = "Faroes-Iceland-NASS89") %>% 
  st_set_crs(st_crs(ne_10m_ocean)) %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Blu", source = "derived from data shared by NAMMCO")
mappingf(Blk89)

# Gulf of st Lawrence ####
gsl <- IHOseas %>% filter(NAME == "Gulf of St. Lawrence") %>%
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Blu", source = "general area derived from World seas IHO v3", subareas = "GsL")
mappingf(gsl)

# combine the polygons and save ####
output <- dplyr::bind_rows(list(NE_OPAREA, Blk15, Blk87, Blk95, Blk01, Blk89,gsl)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
m <- mappingf(output); m
write_sf(output, "NA-Blu\\NA-Blu-subareas.shp")

