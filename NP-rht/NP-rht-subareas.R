#### North Pacific Right whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### JARPNII areas ####
jarpnii <- "NP-JARPNII/JARPNII.shp"
jarpniipoly <- st_read(jarpnii) %>%
  filter(subareas %in% c("N of 35N, 140E-170E")) %>%
  st_intersection(ne_10m_ocean) %>% 
  mutate(species = "NPrht", source = "based in coordinates from maps")%>% mutate(survey = list(c("","JARPNII","JARPN"))) %>% unnest(survey)
mappingf(jarpniipoly)
View(jarpniipoly)

#### final output ####
#save 
write_sf(jarpniipoly, "NP-rht/NP-rht-subareas.shp",append=FALSE)
