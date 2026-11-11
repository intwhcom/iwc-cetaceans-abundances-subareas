#### North Atlantic Sperm Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### subareas ####
#Iceland-Faroes ####
#2001
Blk01Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk01\\Blk01Poly.shp"
Blk01 <- dissolve(shp = Blk01Poly, subareaname = "Faroes-Iceland-NASS01") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Spr", source = "derived from data shared by NAMMCO")
mappingf(Blk01)

#2007
Blk07Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk07\\Blk07Poly.shp"
Blk07 <- dissolve(shp = Blk07Poly, subareaname = "Faroes-Iceland-NASS07") %>%nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", large_area = "NA", species = "Spr", source = "derived from data shared by NAMMCO") %>% mutate(survey = list(c("NASS","T-NASS"))) %>% unnest(survey)
mappingf(Blk07)

#2015
Blk15Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk15\\Blk15Poly.shp"
Blk15 <- dissolve(shp = Blk15Poly, subareaname = "Faroes-Iceland-NASS15") %>% nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Spr", source = "derived from data shared by NAMMCO")
mappingf(Blk15)

# Norwegian & Barents Seas ####
#Norwegian & adjacent Seas 1995
a3 <- "NA-Spr/georeferenced/Norway 1995 without NVS.shp"
n95 <- read_sf(a3) %>% mutate(subareas = "Norwegian & adjacent Seas 1995", accuracy = "approximate", large_area = "NA", species = "Spr", source = "georeferenced") %>% mutate(survey = list(c("NASS","NILS"))) %>% unnest(survey)
mappingf(n95)
#Norwegian & adjacent Seas 1996-2001
a4 <- "NA-Hbk/georeferenced/Norway 1996-2001.shp"
n9601 <- read_sf(a4) %>% mutate(subareas = "Norwegian & adjacent Seas 1996-2001", accuracy = "approximate", large_area = "NA", species = "Spr", source = "georeferenced") %>% mutate(survey = list(c("NILS","NASS"))) %>% unnest(survey)
mappingf(n9601)
#Norwegian & adjacent Seas 2002-2007
a1 <- "NASS and NILS effort\\fromhino\\polygon-blocks-0207-wgs84\\polygon-blocks-0207-wgs84.shp"
n27 <- read_sf(a1) %>% st_union() %>%  st_sf() %>% mutate(subareas = "Norwegian & adjacent Seas 2002-2007", accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Spr", source = "derived from data shared by NAMMCO and Havforskningsinstituttet")
#Norwegian & adjacent Seas 2008
a2 <- "NASS and NILS effort\\fromhino\\polygon_blocks_0813\\polygon_blocks_0813_refinedCopy.shp"
n8 <- read_sf(a2) %>% st_union() %>%  st_sf() %>% mutate(subareas = "Norwegian & adjacent Seas 2008", accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Spr", source = "made of polygons received from NAMMCO and Havforskningsinstituttet")
mappingf(n8)

#NASS extension 2015
#originally noted as CM1a+CM3
p1 <- read_sf("NASS and NILS effort\\fromhino\\polygon_blocks_0813\\polygon_blocks_0813_refinedCopy.shp") %>% filter(ET_ID %in% c("CM3", "EW1", "EW2", "EW3"))
p2 <- read_sf("NASS and NILS effort\\NASS and NILS effort\\NASS 2015 blocks and transects\\NASS_blokker_transekter\\CM1_ost.shp") %>% st_transform(st_crs(p1))  
NASSext2015 <- dplyr::bind_rows(list(p1,p2)) %>% st_union() %>% st_as_sf() %>% mutate(subareas = "NASS extension 2015", accuracy = "accurate", large_area = "NA", species = "Spr", source = "made of polygons received from NAMMCO and Havforskningsinstituttet") %>% mutate(survey = list(c("NILS","NASS","NILS+NASS"))) %>% unnest(survey)
mappingf(NASSext2015)

#Mediterranean - ASI2018
m1 <- "NA-Spr/georeferenced/Med ASI 2018.shp"
med1 <- read_sf(m1)  %>% st_union() %>%  st_sf() %>% mutate(subareas = "Mediterranean - ASI2018", accuracy = "approximate", survey = "ASI", large_area = "NA", species = "Spr", source = "georeferenced")
mappingf(med1)

#### output ####
output <- dplyr::bind_rows(list(med1, NASSext2015, Blk01, Blk07, Blk15, n95, n9601, n27, n8)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
#save 
write_sf(output, "NA-Spr/NA-Spr-subareas.shp")
