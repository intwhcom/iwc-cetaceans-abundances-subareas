#### North Atlantic minke Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### 'basic' assessment subareas

subs2 <- st_read("NA-Mi/assessment-subareas/NA-Mi-assessment-subareas.shp") %>% 
  mutate(accuracy = "accurate", survey = "", large_area = "NA", species = "Mi", source = "from WKT,coordinates derived from IWC maps")
mappingf(subs2)

#expand the polygons to add the surveys
# --- Define Expansion Rules ---
expansion_rules <- c("",'NASS','T-NASS','IC','NILS','GL')

# --- Expand Data Based on Rules ---
subs2 <- subs2 %>%
  mutate(survey = list(expansion_rules)) %>%  # Add list column with same values
  unnest(survey)  # Expand into multiple rows

#ES = ESW+ESE
ES <- subs2 %>% filter(subareas %in% c("ESW", "ESE")) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Mi", subareas = "ES", source = "from WKT,coordinates derived from IWC maps")
mappingf(ES)

#E = 'ESW','ESE','EB','EW', 'EN'
E <- subs2 %>% filter(subareas %in% c('ESW','ESE','EB','EW', 'EN')) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", large_area = "NA", species = "Mi", subareas = "E", source = "from WKT,coordinates derived from IWC maps")%>% mutate(survey = list(c("","NILS"))) %>% unnest(survey)
mappingf(E)

#C = "CG"  "CIP" "CIC" "CM"
C <- subs2 %>% filter(subareas %in% c("CG","CIP","CIC","CM")) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", large_area = "NA", species = "Mi", subareas = "C", source = "from WKT,coordinates derived from IWC maps") %>% mutate(survey = list(c("","NILS"))) %>% unnest(survey)
mappingf(C)

#CG+CIP 'CG','CIP'
CGCIP <- subs2 %>% filter(subareas %in% c('CG','CIP')) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Mi", subareas = "CG+CIP", source = "from WKT,coordinates derived from IWC maps")
mappingf(CGCIP)

#E+CM 'CM','ESW','ESE','EB','EW', 'EN'
ECM <- subs2 %>% filter(subareas %in% c('CM','ESW','ESE','EB','EW', 'EN')) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Mi", subareas = "E+CM", source = "from WKT,coordinates derived from IWC maps")
mappingf(ECM)

#NE OPAREA
NE_OPAREA <- st_read("NA-Sei/georeferenced/Palka2006and2020-ocean.shp") %>% st_intersection(ne_10m_ocean) %>%
  mutate(accuracy = "approximate", survey = "NEFSC", large_area = "NA", species = "Mi", source = "georeferenced")
mappingf(NE_OPAREA)

#CG exc EG
shpf <- "NASS and NILS effort/NAMMCO-Havforskningsinstituttet/cgexceg.shp"
cgexceg <- st_read(shpf) %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Mi", subareas = "CG exc EG", source = "derived from data shared by NAMMCO and Havforskningsinstituttet")
mappingf(cgexceg)

#CG:EG
shpf <- "NASS and NILS effort/NAMMCO-Havforskningsinstituttet/cgeg2015.shp"
cgeg <- st_read(shpf) %>% mutate(accuracy = "accurate", survey = "NASS", large_area = "NA", species = "Mi", subareas = "CG:EG", source = "derived from data shared by NAMMCO and Havforskningsinstituttet")
mappingf(cgeg)

#EW1-3
ew13 <- st_read("NASS and NILS effort\\fromhino\\polygon_blocks_0813\\polygon_blocks_0813_refinedCopy.shp") %>% filter(ET_ID %in% c('EW1','EW2','EW3')) %>% group_by() %>% dplyr::summarize() %>% mutate(accuracy = "accurate", survey = "NILS", large_area = "NA", species = "Mi", subareas = "EW1-3", source = "derived from data shared by Havforskningsinstituttet")
mappingf(ew13)

#### output ####
output <- dplyr::bind_rows(list(subs2, CGCIP, E, ECM, ES, NE_OPAREA,ew13, cgexceg, cgeg, C)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
mappingf(output)
View(output)
#save 
write_sf(output, "NA-Mi/NA-Mi-subareas.shp")

