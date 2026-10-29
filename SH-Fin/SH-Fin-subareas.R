#### SH Fin whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#Circumpolar-S of 60S
c60s1 <- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp") %>% filter(subareas %in% c("Circumpolar-S of 60S"), species == "Fin") %>% mutate(source = "based on known coordinates derived from maps") %>% mutate(large_area = list(c("SH","SO"))) %>% unnest(large_area) 

#Areas V+VIW
#Areas IIIE+IV
jj2 <- st_read("SH-JARPA-JARPAII/JARPA-JARPAII-areas.shp")%>% filter(subareas %in% c( "Areas V+VIW", "Areas IIIE+IV"), species == "Fin", survey == "JARPA/JARPAII") %>% mutate(source = "based on known coordinates derived from maps", survey = "JARPA+JARPAII")

#Hedley et al 2001
#Scotia Sea
#Antarctic Peninsula
dtsower <- read_sf("SH-Fin/input_provided_by_researchers/MB1/survey_strata2.shp") %>%
  filter(stratum %in% c("SS","AP")) %>% 
  mutate(subareas=c("Scotia Sea","Antarctic Peninsula"), accuracy = "accurate", survey="SOWER-2000", large_area="SO", species="Fin", source="provided by the authors")
mappingf(dtsower)

#herr et al 2016
#Drake Passage
#Bransfield Strait
dt2 <- read_sf("SH-Fin/input_provided_by_researchers/HH/Survey Area2/SurveyAreas_ViqueratHerr_WGS84.shp")

h16 <- dt2 %>% filter(publicatio == "Herr et al. 2016") %>% st_intersection(ne_10m_ocean) %>% mutate(subareas = case_when( area_name=="DP" ~ "Drake Passage", area_name=="BS" ~ "Bransfield Strait"), accuracy = "accurate", survey="", large_area="SO", species="Fin", source="provided by the authors")
mappingf(h16)

#Viquerat & Herr, 2017
#Elephant Island
#S Orkney Islands
vh17 <- dt2 %>% filter(publicatio == "Viquerat & Herr 2017") %>% st_intersection(ne_10m_ocean) %>% mutate(subareas = case_when( area_name=="Orkneys" ~ "S Orkney Islands", area_name=="Elephant Island" ~ "Elephant Island"), accuracy = "accurate", survey="", large_area="SO", species="Fin", source="provided by the authors")
mappingf(vh17)

#Williams et al. 2006
#Drake Passage-Antarctic Peninsula
dtw <- read_sf("SH-Fin/input_provided_by_researchers/Williams_et_al_2006/Williams_et_al_2006_survey_region.shp") %>% st_intersection(ne_10m_ocean) %>% st_union() %>% st_sf() %>% mutate(subareas = "Drake Passage-Antarctic Peninsula", accuracy = "accurate", survey="", large_area="SO", species="Fin", source="provided by the authors")
mappingf(dtw)

# Herr et al. 2022
#Antarctic Peninsula-S Orkney Islands-Elephant Island 
h22 <- dt2 %>% filter(publicatio == "Herr et al. 2022") %>% st_intersection(ne_10m_ocean) %>% st_union() %>% st_sf() %>% mutate(subareas = "Antarctic Peninsula-S Orkney Islands-Elephant Island", accuracy = "accurate", survey="", large_area="SO", species="Fin", source="provided by the authors")
mappingf(h22)

# Viquerat et al. 2022
#Antarctic Peninsula-Scotia Sea
v22 <- dt2 %>% filter(publicatio == "Viquerat et al. 2022") %>% st_intersection(ne_10m_ocean) %>% st_union() %>% st_sf() %>% mutate(subareas = "Antarctic Peninsula-Scotia Sea", accuracy = "accurate", survey="", large_area="SO", species="Fin", source="provided by the authors")
mappingf(v22)

# Biuw et al. 2024
#Area 48-partial
dt <- read_sf("SH-Fin/input_provided_by_researchers/MB1/survey_strata2.shp") %>%
  filter(stratum %in% c("SS","AP","ESS")) %>% st_union() %>% st_sf() %>% mutate(subareas="Area 48-partial", accuracy = "accurate", survey="", large_area="SO", species="Fin", source="provided by the authors")
mappingf(dt) 

#### final output ####
output <- dplyr::bind_rows(list(c60s1, jj2, dtsower, dt, h16, vh17, dtw, h22, v22)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
#save 
write_sf(output, "SH-Fin/SH-Fin-subareas.shp")
