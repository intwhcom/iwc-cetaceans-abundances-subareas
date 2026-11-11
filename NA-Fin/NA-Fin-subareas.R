#### North Atlantic Fin Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### 'basic' assessment subareas

subs2 = st_read("NA-Fin/assessment-subareas/NA-Fin-assessment-subareas.shp") %>%
  mutate(accuracy = "accurate", survey = "", large_area = "NA", species = "Fin", source = "from WKT,coordinates derived from IWC maps") %>% mutate(survey = list(c("","T-NASS","NASS","GL","NASS+NILS","NILS"))) %>% unnest(survey)  
mappingf(subs2)

#EG+WI+EIF
EGWIEIF <- subs2 %>% filter(subareas %in% c('EG','WI','EIF')) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "", large_area = "NA", species = "Fin", subareas = "EG+WI+EIF", source = "from WKT,coordinates derived from IWC maps") %>% mutate(survey = list(c("","T-NASS","NASS","GL","NASS+NILS","NILS"))) %>% unnest(survey)
m <- mappingf(EGWIEIF); m

#NE OPAREA
NE_OPAREA <- st_read("NA-Sei/georeferenced/Palka2006and2020-ocean.shp") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "approximate", survey = "NEFSC", large_area = "NA", species = "Fin", source = "georeferenced")
mappingf(NE_OPAREA)

#T-NASS core
tnass <- st_read("NASS and NILS effort\\NASS and NILS effort\\TNASS 2007 blocks\\tnass_blocks_all.shp") %>% st_set_crs(st_crs(subs2))  %>% filter(PRIMARY %in% c("IF-N-N", "IF-N-S","IF-E","IF-SE-N","IF-SE-S", "IF-SC", "IF-RED-S", "IF-RED-N", "IF-N-W", "IC")) %>% group_by() %>% dplyr::summarize() %>% nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "accurate", survey = "T-NASS", large_area = "NA", species = "Fin", subareas = "T-NASS core", source = "derived from data shared by NAMMCO and Havforskningsinstituttet")
mappingf(tnass)

#Norwegian & adjacent Seas 2002-2007
a1 <- "NASS and NILS effort\\fromhino\\polygon-blocks-0207-wgs84\\polygon-blocks-0207-wgs84.shp"
n27 <- read_sf(a1) %>% st_union() %>%  st_sf() %>% mutate(subareas = "Norwegian & adjacent Seas 2002-2007", accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Fin", source = "derived from data shared by NAMMCO and Havforskningsinstituttet")

#Norwegian & adjacent Seas 2008
a2 <- "NASS and NILS effort\\fromhino\\polygon_blocks_0813\\polygon_blocks_0813_refinedCopy.shp"
n8 <- read_sf(a2) %>% st_union() %>%  st_sf() %>% mutate(subareas = "Norwegian & adjacent Seas 2008", accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Fin", source = "made of polygons received from NAMMCO and Havforskningsinstituttet")
mappingf(n8)

#w. Mediterranean
wmed <- faofishingareas %>% st_set_crs(st_crs(subs2))  %>% filter(F_CODE %in% c("37.1.1", "37.1.2","37.1.3")) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Fin", subareas = "w. Mediterranean", source = "area derived from FAO areas")
mappingf(wmed)

#EC-Newfoundland-Labrador
ECNL <- st_read("NASS and NILS effort\\NASS and NILS effort\\TNASS 2007 blocks\\tnass_blocks_all.shp") %>% filter(PRIMARY %in% c("NL-LAB","NL-E","NL-S"))  %>% st_set_crs(st_crs(subs2)) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "T-NASS", large_area = "NA", species = "Fin", subareas = "EC-Newfoundland-Labrador", source = "derived from data shared by NAMMCO")
mappingf(ECNL)

#US and canada ##
GB <- GOM_GB %>%
  ungroup() %>%
  st_transform(32619) %>%  # UTM zone 19N, suitable for Gulf of Maine
  st_make_valid() %>%
  dplyr::summarise() %>%
  st_transform(st_crs(subs2))
GOM <- GOM_GB %>% filter(GARFO_ID %in% c("G000180", "1")) %>%
  st_transform(st_crs(subs2))  %>% 
  st_make_valid() %>% group_by() %>% dplyr::summarize() 
Scotia <- st_read("NA-Fin/georeferenced/Scotia.shp") %>% group_by() %>% dplyr::summarize() %>% st_set_crs(st_crs(subs2))
sBOF <- st_read("NA-Fin/from_GOM-GB_Regulated_Mesh_Areas/south bay of fundy.shp")
BOF <- st_read("NA-Fin/from_GOM-GB_Regulated_Mesh_Areas/bay of fundy.shp")
GsL <- IHOseas %>% filter(NAME == "Gulf of St. Lawrence")

#GBtoScotia
GBtoScotia <- dplyr::bind_rows(list(GB,Scotia)) %>% group_by() %>% dplyr::summarize() %>% nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Fin", subareas = "GB-Scotia", source = "built from areas derived from NOAA Gulf of Maine-Georges Bank Regulated Mesh Areas - https://www.fisheries.noaa.gov/resource/map/gulf-maine-georges-bank-regulated-mesh-areas - and a hand drawn polygon of the Scotia Sea")
mappingf(GBtoScotia)

#GOM
gom <- GOM %>% mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Fin", subareas = "GOM", source = "derived from NOAA Gulf of Maine-Georges Bank Regulated Mesh Areas - https://www.fisheries.noaa.gov/resource/map/gulf-maine-georges-bank-regulated-mesh-areas")
mappingf(gom)

#GOM-sBOF
gomsfob<- dplyr::bind_rows(list(sBOF,GOM)) %>% st_make_valid() %>% group_by() %>% dplyr::summarize() %>% nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Fin", subareas = "GOM-sBOF", source = "built from areas derived from NOAA Gulf of Maine-Georges Bank Regulated Mesh Areas - https://www.fisheries.noaa.gov/resource/map/gulf-maine-georges-bank-regulated-mesh-areas - and from World Seas IHO v3")
mappingf(gomsfob)

#GOM-BOF-GsL
gomsfobgsl<- dplyr::bind_rows(list(GB,BOF,GOM,Scotia,GsL)) %>% st_make_valid() %>% group_by() %>% dplyr::summarize() %>% nngeo::st_remove_holes() %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "Fin", subareas = "GOM-BOF-GsL", source = "built from areas derived from NOAA Gulf of Maine-Georges Bank Regulated Mesh Areas - https://www.fisheries.noaa.gov/resource/map/gulf-maine-georges-bank-regulated-mesh-areas - and from World Seas IHO v3")
mappingf(gomsfobgsl)

#NEFSC-2011
NEFSC2011 <- st_read("NA-Fin/georeferenced/nefsc palka 2012 - ocean.shp") %>% mutate(accuracy = "approximate", survey = "NEFSC", large_area = "NA", species = "Fin", subareas = "NEFSC-2011", source = "georeferenced")
mappingf(NEFSC2011)

#European Atlantic waters
euna <- st_read("NA-Fin/georeferenced/EuropeNA.shp") %>% st_intersection(ne_10m_ocean) %>% mutate(accuracy = "approximate", large_area = "NA", species = "Fin", subareas = "European Atlantic waters", source = "georeferenced with error due to unknown projection of original map") %>% mutate(survey = list(c("SCANSI","SCANSII","SCANSIII"))) %>% unnest(survey)
mappingf(euna)

#save####
output <- dplyr::bind_rows(list(wmed,tnass,EGWIEIF,NEFSC2011,gomsfobgsl,gomsfob,gom,GBtoScotia,subs2,NE_OPAREA,n27,n8,euna, ECNL)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
write_sf(output, "NA-Fin\\NA-Fin-subareas.shp")

#### update with EG and WG 2024 surveys ####
finsshp <- "NA-Fin\\NA-Fin-subareas.shp"
fins0 <- st_read(finsshp)

#read in the data shared by the authors of Heide-Jørgensen, 2025:
Sys.setenv(SHAPE_RESTORE_SHX = "YES")

WG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/West_all_together.shp", subareaname = "WG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "Fin", source = "personal communication with Heide-Jørgensen")
st_crs(WG24) <- 4326 # Set the CRS
mappingf(WG24)

EG24 <- dissolve_b(shp = "NA-Fin/Heide-Jørgensen_2025/East_all_together.shp", subareaname = "EG-24") %>% 
  mutate(accuracy = "accurate",survey = "GL", large_area = "NA", species = "Fin", source = "personal communication with Heide-Jørgensen")
st_crs(EG24) <- 4326 # Set the CRS
mappingf(EG24)

# add the areas and save updated output
output <- dplyr::bind_rows(list(fins0, EG24, WG24)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
write_sf(output, "NA-Fin\\NA-Fin-subareas.shp")
