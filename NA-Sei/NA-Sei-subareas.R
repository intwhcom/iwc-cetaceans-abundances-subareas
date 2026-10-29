#### NA Sei whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#E.Greenland	
#W.Greenland
EWGrl <- st_read("NA-Sei/georeferenced/HeideJeyal2007-ocean.shp") %>%
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Sei", source = "georeferenced")
mappingf(EWGrl)
#Faroes/Iceland	NASS
#1987
Blk87Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk87\\Blk87Poly.shp"
Blk87 <- dissolve(shp = Blk87Poly, subareaname = "Faroes-Iceland-NASS87") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Sei", source = "derived from data shared by NAMMCO")
mappingf(Blk87)
#1989
Blk89Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk89\\Blk89Poly.shp"
Blk89 <- dissolve(shp = Blk89Poly, subareaname = "Faroes-Iceland-NASS89") %>% st_set_crs(st_crs(Blk87)) %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Sei", source = "derived from data shared by NAMMCO")
mappingf(Blk89)
#1995
Blk95Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk95\\Blk95Poly.shp"
Blk95 <- Blk95Poly %>% dissolve(subareaname = "Faroes-Iceland-NASS95") %>% st_set_crs(st_crs(Blk87)) %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Sei", source = "derived from data shared by NAMMCO")
mappingf(Blk95)
#2001
Blk01Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk01\\Blk01Poly.shp"
Blk01 <- dissolve(shp = Blk01Poly, subareaname = "Faroes-Iceland-NASS01") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Sei", source = "derived from data shared by NAMMCO")
mappingf(Blk01)
#2007
Blk07Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk07\\Blk07Poly.shp"
Blk07 <- dissolve(shp = Blk07Poly, subareaname = "Faroes-Iceland-NASS07") %>%
  mutate(accuracy = "accurate", large_area = "NA", species = "Sei", source = "derived from data shared by NAMMCO") %>% mutate(survey = list(c("NASS","T-NASS"))) %>%  # Add list column with same values
  unnest(survey)  # Expand into multiple rows
mappingf(Blk07)
#2015
Blk15Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk15\\Blk15Poly.shp"
Blk15 <- dissolve(shp = Blk15Poly, subareaname = "Faroes-Iceland-NASS15") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Sei", source = "derived from data shared by NAMMCO")
mappingf(Blk15)
#NE OPAREA	
NE_OPAREA <- st_read("NA-Sei/georeferenced/Palka2006and2020-ocean.shp") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "approximate", survey = "NEFSC", large_area = "NA", species = "Sei", source = "georeferenced")
mappingf(NE_OPAREA)

#### output ####
output <- dplyr::bind_rows(list(EWGrl,Blk01,Blk07,Blk15,Blk87,Blk89,Blk95,NE_OPAREA)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
m <- mappingf(output); m
#save 
write_sf(output, "NA-Sei/NA-Sei-subareas.shp")
