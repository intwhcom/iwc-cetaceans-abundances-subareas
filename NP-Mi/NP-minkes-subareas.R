#### north pacific minkes ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

# assessment subareas #
#### subareas as WKT ####
subareas = c("1W","1E","2C", "2R", "3", "4", "5", "6W", "6E", "7CS", "7WR", "7E", "7CN", "8", "9","10E","11", "10W", "12SW","12NE", "9N", "13")
str=c("POLYGON((115 25 ,127 25 ,127 33 ,115 33 ,115 25))", 
"POLYGON((127 25 ,130 25 ,130 33 ,127 33 ,127 25 ))", 
"POLYGON((130 30 ,131.5 30 ,133 32 ,140 34 ,142 35 ,130 35 ,130 30 ))", 
"POLYGON((130 25 ,150 25 ,150 35 ,142 35 ,140 34 ,133 32 ,131.5 30 ,130 30 ,130 25 ))",
"POLYGON((150 25 , 157 25,157 35 ,150 35 ,150 25 ))", 
"POLYGON((157 25,170 25,170 35,157 35,157 25))", 
"POLYGON((115 33,127 33,127 42,115 42,115 33))", 
"MULTIPOLYGON(((127 33,130 35,127 35,127 33)),((127 35,130 35,136 41,127 41,127 35)))", 
"MULTIPOLYGON(((127 33,130 33,130 35,127 33)),((130 35,140 35,140 41,136 41,130 35)))",
"POLYGON((140 35,142 35,143.25 40,143 41,140 41,140 35))",
"POLYGON((142 35,147 35,147 42.75,143 41,143.25 40,142 35))",
"POLYGON((147 35,150 35,150 46,149 45.5,148 45,147 44.4,147 42.75,147 35))",
"POLYGON((141 41,143 41,147 42.75,147 44.4,145 43,140 42.55,141 41))",
"POLYGON((150 35,157 35,157 52,153 48,150 46,150 35))",
"POLYGON((157 35,170 35,170 52,157 52,157 35))",
"POLYGON((136 41,141 41,140 42.55,143 43,142 45,142 46,139 46,136 41))",
"POLYGON((145 43,147 44.4,150 46,142 46,142 45,143 43,145 43))",
"POLYGON((127 41,136 41,139 46,142 46,142.5 47,142.5 52,127 52,127 41))",
"POLYGON((142.5 47,143 46,145 46,150 46,150 50,142.5 50,142.5 47))",
"POLYGON((142.5 50,150 50,150 46,153 48,157 51,157 55,162 60,135 60,135 55,140 52,142.5 52,142.5 50))",
"POLYGON((157 52,170 52,170 60,162 60,160 55,157 55,157 52))",
"POLYGON((170 25,180 25,180 60,170 60,170 25))")

areas1 <- st_as_sf(data.frame(subareas = subareas, g=str),wkt="g", crs = 4326)#"+init=epsg:4326"
mappingf(x=areas1)

areas2 <- st_intersection(st_make_valid(areas1), ne_10m_ocean)
mappingf(x=areas2)

areas2[areas2$subareas == "2C","g"]

write_sf(areas2, "NP-Mi/assessment-subareas/AreasToFix 18032022.shp")

# the areas need to be 'manually' corrected using QGIS and then re-read in R:
NPareas <- st_read("NP-Mi/assessment-subareas/subareas 18032022.shp") %>%
  select(subareas, geometry) %>%
  mutate(species = "Mi",accuracy = "accurate", large_area = "NP", source = "original coordinates derived from IWC maps and corrected manually in QGIS") %>% mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(x=NPareas)

# make the medium sized areas
lookup1 <- data.frame(subareas = c("2C", "2R", "6E", "6W", "7CN", "7E", "7WR", "7CS", "10E", "10W", "12SW", "12NE", "1W", "1E"), bigareas = c("2", "2", "6", "6", "7", "7", "7", "7", "10", "10", "12", "12", "1", "1"))

NPareas1 <- merge(NPareas,lookup1, by="subareas")
nc_dissolve <- NPareas1 %>% group_by(bigareas) %>% summarize() %>% rename(subareas = bigareas)
areas_bbox <- st_bbox(nc_dissolve)
nc_dissolve <- cbind(nc_dissolve, st_coordinates(st_centroid(nc_dissolve)))%>%
  mutate(species = "Mi",accuracy = "accurate", large_area = "NP", source = "original coordinates derived from IWC map") %>% mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(x=nc_dissolve)

# 7CS+7CN+7WR ####
plus7 <- st_read("NP-Mi/assessment-subareas/subareas 18032022.shp") %>%
  select(subareas, geometry) %>% filter(subareas %in% c('7CS','7CN','7WR')) %>% st_union() %>% st_sf() %>% mutate(subareas = "7CS+7CN+7WR", species = "Mi",accuracy = "accurate", large_area = "NP", source = "original coordinates derived from IWC maps and corrected manually in QGIS") %>% mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(x=plus7)

#7+8+9 ####
sen <- dplyr::bind_rows(list(NPareas,nc_dissolve)) %>% select(subareas, geometry) %>% filter(subareas %in% c('7','8','9')) %>% st_union() %>% st_sf() %>% mutate(subareas = "7+8+9", species = "Mi",accuracy = "accurate", large_area = "NP", source = "original coordinates derived from IWC maps and corrected manually in QGIS") %>% mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(x=sen)

#### US west Coast ####
subareasUSWC = c("US West Coast")
strUSWC = c("POLYGON((-130 45.8,-124 47, -115 33.5, -117.5 33.5, -119 32, -123.5 30, -126.5 32, -130 40, -130 45.8))")
areasUSWC <- st_as_sf(data.frame(subareas = subareasUSWC, geometry=strUSWC),wkt="geometry", crs = 4326)
areasUSWC2 <- st_intersection(st_make_valid(areasUSWC), ne_10m_ocean)%>%
  mutate(species = "Mi",accuracy = "accurate", survey = "", large_area = "NP", source = "based on known coordinates")
mappingf(x=areasUSWC2)

#### eastern Bering Sea shelf ####
subareasEBSS = c("eastern Bering Sea shelf")
strEBSS = c("POLYGON((-179.9 60,-177 62,-161 56,-168 53,-179.9 60))")
areasEBSS <- st_as_sf(data.frame(subareas = subareasEBSS, geometry=strEBSS),wkt="geometry", crs = 4326)
areasEBSS2 <- st_intersection(st_make_valid(areasEBSS), ne_10m_ocean)%>%
  mutate(species = "Mi",accuracy = "approximate", survey = "", large_area = "NP", source = "based on known coordinates")
mappingf(areasEBSS2)

#### Aleutian Islands and the Alaska Peninsula ####
subareasAIAP = c("Aleutian Islands and the Alaska Peninsula")
strAIAP = c("POLYGON((-178 51,-178 52,-165 54,-155 57,-149 60,-149.5 59, -150 58.5, -150 58, -155 55, -160 53.8, -170 51.5, -178 51))")
areasAIAP <- st_as_sf(data.frame(subareas = subareasAIAP, geometry=strAIAP),wkt="geometry", crs = 4326)
areasAIAP2 <- st_intersection(st_make_valid(areasAIAP), ne_10m_ocean)%>%
  mutate(species = "Mi",accuracy = "approximate", survey = "", large_area = "NP", source = "based on known coordinates")
mappingf(areasAIAP2)

#### 7WR subarea divided ####
subareas7wr = c("7WRS","7WRN")
str7wr = c("POLYGON((142 35,147 35,147 40,143.25 40,142 35))","POLYGON((143.25 40,143 41,147 42.75,147 40,143.25 40))")
areas7wr <- st_as_sf(data.frame(subareas = subareas7wr, geometry=str7wr),wkt="geometry", crs = 4326) %>% st_intersection(ne_10m_ocean) %>%
  mutate(species = "Mi",accuracy = "accurate", large_area = "NP", source = "derived from known coordinates - see original IWC maps") %>% mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(areas7wr)

#### 9N and 9S ####
subareas9s = c("9-S")
str9s = c("POLYGON((157 35,170 35,170 43,157 43,157 35))")
areas9s <- st_as_sf(data.frame(subareas = subareas9s, geometry=str9s),wkt="geometry", crs = 4326) 
areas9n <- st_difference(NPareas[NPareas$subareas=="9",], areas9s) %>% mutate(subareas = "9-N")
JARPN_9NS <- dplyr::bind_rows(list(areas9s,areas9n)) %>% select(subareas, geometry) %>%
  mutate(species = "Mi",accuracy = "accurate", large_area = "NP", source = "derived from known coordinates - see original IWC maps") %>% mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(JARPN_9NS)

#the Hawaian EEZ
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>%
  mutate(subareas = "Hawaiian EEZ",species = "Mi",accuracy = "accurate", survey = "", large_area = "NP", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")
mappingf(Hawaii)

#### final output ####
output <- dplyr::bind_rows(list(NPareas,nc_dissolve,areas7wr,JARPN_9NS,Hawaii,areasUSWC2,areasEBSS2,areasAIAP2,plus7,sen)) %>% 
  select(subareas, geometry,species,accuracy, survey, large_area, source)
View(output)
output %>% 
  st_shift_longitude() %>% mappingf()
write_sf(output, "NP-Mi/NP-minkes-subareas.shp")
