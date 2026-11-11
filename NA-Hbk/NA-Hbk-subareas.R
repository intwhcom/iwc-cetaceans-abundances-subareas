#### North Atlantic humpback Whales ####
 #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### subareas ####
#NE OPAREA
NE_OPAREA <- st_read("NA-Sei/georeferenced/Palka2006and2020-ocean.shp") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "approximate", survey = "NEFSC", large_area = "NA", species = "Hbk", source = "georeferenced")
mappingf(NE_OPAREA)

#### YoNAH ####
#gulf of main
GOM <- st_read("NA-Hbk\\YoNAH\\YoNAH survey areas - ocean.shp") %>% filter(subareas == "GOM") %>% st_transform(st_crs(NE_OPAREA))  %>% st_make_valid() %>% group_by() %>% dplyr::summarize()  %>% mutate(accuracy = "approximate", large_area = "NA", species = "Hbk", subareas = "GOM", source = "polygons delineated from YoNAH encounters derived from GBIF")%>% mutate(survey = list(c("YoNAH", "","NEFSC"))) %>% unnest(survey)
mappingf(GOM)
#East CAN
EastCAN <- st_read("NA-Hbk\\YoNAH\\YoNAH survey areas - ocean.shp") %>% filter(subareas %in% c("GsL","S.NFL","N.NFL")) %>% st_transform(st_crs(NE_OPAREA))  %>% st_make_valid() %>% group_by() %>% dplyr::summarize()  %>% mutate(accuracy = "approximate", survey = "YoNAH", large_area = "NA", species = "Hbk", subareas = "East CAN", source = "polygons delineated from YoNAH encounters derived from GBIF")
mappingf(EastCAN)

#### NAISS ####
#BOF-Scotia-GsL
tnass <- st_read("NASS and NILS effort\\NASS and NILS effort\\TNASS 2007 blocks\\tnass_blocks_all.shp") %>% st_set_crs(st_crs(NE_OPAREA))
ScotiaToGsL <- tnass %>% filter(PRIMARY %in% c('GULF', 'SCOTIA')) %>% st_make_valid() %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "NAISS", large_area = "NA", species = "Hbk", subareas = "BOF-Scotia-GsL", source = "derived from data shared by NAMMCO")
mappingf(ScotiaToGsL)

#Newfoundld / Labrador
NFLLAB <- tnass %>% filter(PRIMARY %in% c('NL-S', 'NL-E','NL-LAB')) %>% st_make_valid() %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Hbk", subareas = "NFL-LAB", source = "derived from data shared by NAMMCO")
mappingf(NFLLAB)

#W.Greenland ####
wg87 <- st_read("NA-Hbk/georeferenced/wg87.shp") %>% mutate(accuracy = "approximate", large_area = "NA", species = "Hbk", subareas = "WG-87", source = "georeferenced") %>% mutate(survey = list(c("","NASS","GL"))) %>% unnest(survey)
wg88 <- st_read("NA-Hbk/georeferenced/wg88.shp") %>% mutate(accuracy = "approximate", survey = "GL", large_area = "NA", species = "Hbk", subareas = "WG-88", source = "georeferenced")
wg89 <- st_read("NA-Hbk/georeferenced/wg89.shp") %>% mutate(accuracy = "approximate", large_area = "NA", species = "Hbk", subareas = "WG-89", source = "georeferenced") %>% mutate(survey = list(c("","NASS","GL"))) %>% unnest(survey)
wg93 <- st_read("NA-Hbk/georeferenced/Larsen 93 ocean.shp") %>% mutate(accuracy = "accurate", large_area = "NA", species = "Hbk", subareas = "WG-93", source = "georeferenced") %>% mutate(survey = list(c("NAISS", "","NASS","T-NASS","GL","IC"))) %>% unnest(survey)
wg05 <-  st_read("NA-Sei\\georeferenced\\HeideJeyal2007-ocean.shp") %>% filter(subareas == "WG-05") %>% 
mutate(accuracy = "approximate", large_area = "NA", species = "Hbk", source = "georeferenced") %>% mutate(survey = list(c("","NASS","T-NASS","GL","IC"))) %>% unnest(survey)
wgnass07 <- st_read("NASS and NILS effort\\NASS and NILS effort\\TNASS 2007 blocks\\tnass_blocks_all.shp") %>% 
  st_set_crs(st_crs(ne_10m_ocean)) %>% 
  filter() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Hbk", subareas = "WG-NASS07", source = "derived from data shared by NAMMCO")

#E. Greenland ####
eg05<- st_read("NA-Sei\\georeferenced\\HeideJeyal2007-ocean.shp") %>% filter(subareas == "EG-05") %>% mutate(accuracy = "approximate", large_area = "NA", species = "Hbk", source = "georeferenced") %>% mutate(survey = list(c("","NASS","T-NASS","GL","IC"))) %>% unnest(survey)
mappingf(eg05)
eg15 <- st_read("NA-Hbk\\georeferenced\\EG.shp") %>% mutate(subareas = "EG-15", accuracy = "approximate", survey = "NASS", large_area = "NA", species = "Hbk", source = "georeferenced")
mappingf(eg15)

# Iceland ####
Blk95Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk95\\Blk95Poly.shp"
iceS95 <- st_read(Blk95Poly) %>% filter(Primary %in% c('2F','3','4','5F','5P','6F','7','8','8F','9','9X')) %>% st_set_crs(st_crs(NE_OPAREA))  %>%  st_union() %>%  st_sf() %>% st_intersection(ne_10m_ocean)%>% 
  mutate(accuracy = "approximate", survey = "NASS", large_area = "NA", species = "Hbk",subareas = "Iceland-S95", source = "derived from data shared by NAMMCO")
mappingf(iceS95)
icea95 <- st_read(Blk95Poly) %>% filter(Primary %in% c('2F','5F','6F','8F')) %>% st_set_crs(st_crs(NE_OPAREA))  %>%  st_union() %>%  st_sf() %>% nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "approximate", large_area = "NA", species = "Hbk",subareas = "Iceland-A87", source = "derived from data shared by NAMMCO") %>% mutate(survey = list(c("","NASS","T-NASS","GL","IC"))) %>% unnest(survey)
mappingf(icea95)

#Iceland-Faroes ####
Blk87Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk87\\Blk87Poly.shp"
Blk87 <- dissolve(shp = Blk87Poly, subareaname = "Faroes-Iceland-NASS87") %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Hbk", source = "derived from data shared by NAMMCO")
mappingf(Blk87)
#1995
Blk95 <- Blk95Poly %>% dissolve(subareaname = "Faroes-Iceland-NASS95") %>% st_set_crs(st_crs(Blk87)) %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Hbk", source = "derived from data shared by NAMMCO")
mappingf(Blk95)

#2001
Blk01Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk01\\Blk01Poly.shp"
Blk01 <- dissolve(shp = Blk01Poly, subareaname = "Faroes-Iceland-NASS01") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Hbk", source = "derived from data shared by NAMMCO")
mappingf(Blk01)
#2007
Blk07Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk07\\Blk07Poly.shp"
Blk07 <- dissolve(shp = Blk07Poly, subareaname = "Faroes-Iceland-NASS07") %>%nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", large_area = "NA", species = "Hbk", source = "derived from data shared by NAMMCO") %>% mutate(survey = list(c("","NASS","T-NASS","GL","IC"))) %>% unnest(survey)
mappingf(Blk07)
#2015
Blk15Poly = "NASS and NILS effort\\NASS and NILS effort\\NASSBLOCKS\\NASSBLKS\\Blk15\\Blk15Poly.shp"
Blk15 <- dissolve(shp = Blk15Poly, subareaname = "Faroes-Iceland-NASS15") %>% nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Hbk", source = "derived from data shared by NAMMCO")
mappingf(Blk15)

# Norwegian & Barents Seas ####

#1988-89
a5 <- "NA-Hbk\\georeferenced\\norway-barents-1988.shp"
n8889 <- read_sf(a5) %>% st_intersection(ne_10m_ocean) %>% mutate(subareas = "Norwegian & Barents Seas 1988-89", accuracy = "approximate", survey = "NASS", large_area = "NA", species = "Hbk", source = "georeferenced")
mappingf(n8889)

#Norwegian & adjacent Seas 1995
a3 <- "NA-Hbk\\georeferenced\\Norway 1995.shp"
n95 <- read_sf(a3) %>% mutate(subareas = "Norwegian & adjacent Seas 1995", accuracy = "approximate", survey = "NASS", large_area = "NA", species = "Hbk", source = "georeferenced")

#Norwegian & adjacent Seas 1996-2001
a4 <- "NA-Hbk\\georeferenced\\Norway 1996-2001.shp"
n9601 <- read_sf(a4) %>% mutate(subareas = "Norwegian & adjacent Seas 1996-2001", accuracy = "approximate", survey = "NILS", large_area = "NA", species = "Hbk", source = "georeferenced")

#Norwegian & adjacent Seas 2002-2007
a1 <- "NASS and NILS effort\\fromhino\\polygon-blocks-0207-wgs84\\polygon-blocks-0207-wgs84.shp"
n27 <- read_sf(a1) %>% st_union() %>%  st_sf() %>% mutate(subareas = "Norwegian & adjacent Seas 2002-2007", accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Hbk", source = "derived from data shared by NAMMCO and Havforskningsinstituttet")

#Norwegian & adjacent Seas 2008
a2 <- "NASS and NILS effort\\fromhino\\polygon_blocks_0813\\polygon_blocks_0813_refinedCopy.shp"
n8 <- read_sf(a2) %>% st_union() %>%  st_sf() %>% mutate(subareas = "Norwegian & adjacent Seas 2008", accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Hbk", source = "made of polygons received from NAMMCO and Havforskningsinstituttet")
mappingf(n8)

#NASS extension 2015
#originally noted as CM1a+CM3
p1 <- read_sf("NASS and NILS effort\\fromhino\\polygon_blocks_0813\\polygon_blocks_0813_refinedCopy.shp") %>% filter(ET_ID %in% c("CM3", "EW1", "EW2", "EW3"))
p2 <- read_sf("NASS and NILS effort\\NASS and NILS effort\\NASS 2015 blocks and transects\\NASS_blokker_transekter\\CM1_ost.shp") %>% st_transform(st_crs(p1))  
NASSext2015 <- dplyr::bind_rows(list(p1,p2)) %>% st_union() %>% st_as_sf() %>% mutate(subareas = "NASS extension 2015", accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Hbk", source = "made of polygons received from NAMMCO and Havforskningsinstituttet") %>% rename(geometry = x)
View(NASSext2015)
mappingf(NASSext2015)

# Cape Verde Islands
CVI <- eezs %>% filter(UNION == "Cape Verde") %>% select(geometry)  %>% st_intersection(ne_10m_ocean) %>% mutate(subareas = "Cape Verde Islands", accuracy = "approximate", survey = "", large_area = "NA", species = "Hbk", source = "derived from EEZ")
mappingf(CVI)

# N.Atlantic
in1<- "NA-Hbk\\georeferenced\\NAHbk.shp"
out1 = read_sf(in1)  %>% st_intersection(ne_10m_ocean) %>% mutate(subareas = "N.Atlantic", accuracy = "approximate", survey = "", large_area = "NA", species = "Hbk", source = "approximate polygon derived from the paper")
mappingf(out1)

#save####
output <- dplyr::bind_rows(list(GOM,NE_OPAREA, NASSext2015, CVI,EastCAN, ScotiaToGsL, NFLLAB, wg87, wg88, wg89, wg93, wg05, wgnass07, eg05, iceS95, icea95, Blk87,Blk01, Blk95, Blk07, Blk15, n95, n9601, n27, n8, n8889, eg15, out1)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
m <- mappingf(output); m
write_sf(output, "NA-Hbk/NA-Hbk-subareas.shp")

#### update with EG and WG 2024 surveys ####
Hbksshp <- "NA-Hbk\\NA-Hbk-subareas.shp"
Hbks0 <- st_read(Hbksshp)
View(Hbks0)

#read in the data shared by the authors of Heide-Jørgensen, 2025:
Sys.setenv(SHAPE_RESTORE_SHX = "YES")

WG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/West_all_together.shp", subareaname = "WG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "Hbk", source = "personal communication with Heide-Jørgensen")
st_crs(WG24) <- 4326 # Set the CRS
mappingf(WG24)

EG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/East_all_together.shp", subareaname = "EG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "Hbk", source = "personal communication with Heide-Jørgensen")
st_crs(EG24) <- 4326 # Set the CRS
mappingf(EG24)

# update and save
output <- dplyr::bind_rows(list(Hbks0, EG24, WG24)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
write_sf(output, "NA-Hbk/NA-Hbk-subareas.shp")
