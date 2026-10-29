#### SH humpbacks ####
#~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")


# IDCR/SOWER ####
g <- c("POLYGON ((-20 -60, -50 -60, -50 -90, -20 -90, -20 -60))",
       "MULTIPOLYGON (((10 -60, 180 -60, 180 -90, 10 -90, 10 -60)), ((-20 -60, -20 -90, -180 -90, -180 -60, -20 -60)))",
       "POLYGON ((-10 -60, -60 -60, -60 -90, -10 -90, -10 -60))",
       "POLYGON ((-60 -60, -120 -60, -120 -90, -60 -90, -60 -60))",
       "MULTIPOLYGON (((170 -60, 180 -60, 180 -90, 170 -90, 170 -60)), ((-120 -60, -120 -90, -180 -90, -180 -60, -120 -60)))",
       "POLYGON ((170 -60, 110 -60, 110 -90, 170 -90, 170 -60))",
       "POLYGON ((110 -60, 50 -60, 50 -90, 110 -90, 110 -60))")
s <- c('BS A (50W-20W S of 60S)',
'BS B (20W-10E S of 60S)',
'BS C (10E-60E S of 60S)',
'BS D (60E-120E, S of 60S)',
'BS E (120E-170W, S of 60S)',
'BS F (170W-110W, S of 60S)',
'BS G (110W-50W, S of 60S)')

out1 <- wktfunction(GEOM = g, Subareas = s) %>% mutate(accuracy = "accurate", survey = "IDCR/SOWER", large_area = "SO", species = "Hbk", source = "built from known coordinates")
mappingf(out1)

#Arabian Sea
out4 <- IHOseas %>% filter(NAME == "Arabian Sea") %>% select(geometry) %>%
  mutate(accuracy = "accurate", survey = "", large_area = "IO", species = "Hbk", subareas = "Arabian Sea", source = "derived from marineregions World Seas IHO v3" )
mappingf(out4)

#BS C2 (Comoros Archipelago)
#BS C4 (Mascarene Is.)
out6 <- eezs %>% filter(UNION %in% c("Republic of Mauritius","Comores")) %>% 
  st_intersection(ne_10m_ocean) %>% select(geometry) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "IO", species = "Hbk", subareas = c("BS C4 (Mascarene Is.)","BS C2 (Comoros Archipelago)"), source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")
mappingf(out6)

#BS A (Brazil)
#BS B1 (Gabon)
#BS B2 (W. South Africa)
#BS C1 (Mozambique)
#BS C3 (Madagascar)
g <- c("POLYGON ((-36 -6, -33 -6, -33 -9, -36 -12, -36 -21, -39 -24, -42 -26, -46 -26, -46 -6, -36 -6))",
       "POLYGON ((-10 10, 20 10, 20 -15, -10 -15, -10 10))",
       "POLYGON ((0 -15, 20 -15, 20 -35, 0 -35, 0 -15))",
       "POLYGON ((30 -30, 45 -30, 45 -10, 30 -10, 30 -30))",
       "POLYGON ((45 -30, 55 -30, 55 -10, 50 -10, 45 -30))")
s <- c(
  'BS A (Brazil)',
  'BS B1 (Gabon)',
  'BS B2 (W. South Africa)',
  'BS C1 (Mozambique)',
  'BS C3 (Madagascar)'
)
out2 <- wktfunction(GEOM = g, Subareas = s) %>% select(subareas, geometry) %>% mutate(accuracy = "approximate", survey = "", large_area = c("SA","SA","SA","IO","IO"), species = "Hbk", source = "built from approximate coordinates")
mappingf(out2)

#BS B (Western Africa)
out3 <- out2 %>% filter(subareas %in% c('BS B1 (Gabon)', 'BS B2 (W. South Africa)')) %>% group_by(accuracy,survey,large_area, species) %>% dplyr::summarize() %>% mutate(subareas = "BS B (Western Africa)", source = "built from approximate coordinates")
m <- mappingf(out3); m

#BS C (Eastern Africa)
out5 <- rbind(out2, out6) %>% 
  filter(subareas %in% c('BS C1 (Mozambique)','BS C3 (Madagascar)',"BS C4 (Mascarene Is.)","BS C2 (Comoros Archipelago)")) %>% group_by(accuracy,survey,large_area, species) %>% dplyr::summarize() %>% mutate(subareas = "BS C (Eastern Africa)", source = "built from known coordinates")
m <- mappingf(out5); m
  
#BS D (West Australia)
g <- c("POLYGON ((112 -23,113.5 -23,113.5 -26.5,112 -26.5,112 -23))")
s <- c("BS D (West Australia)")
outD <- wktfunction(GEOM = g, Subareas = s) %>% select(subareas, geometry) %>% mutate(accuracy = "approximate", survey = "", large_area = "IO", species = "Hbk", source = "built from approximate coordinates")
mappingf(outD)

#BS G (Magellan Strait)
g <- c("POLYGON ((-68.356526 -52.368536,
-69.193551 -52.036986,
 -74.789021 -52.365182,
 -74.810994 -52.785801,
 -71.655689 -54.817822,
 -66.450074 -54.746109,
 -69.28166960991607 -52.770505273083934,
 -68.511837 -52.633263,
 -68.356526 -52.368536))")
s <- c("BS G (Magellan Strait)")
out7 <- wktfunction(GEOM = g, Subareas = s) %>% select(subareas, geometry) %>% mutate(accuracy = "approximate", survey = "", large_area = "SO", species = "Hbk", source = "built from approximate coordinates")
mappingf(out7)

#BS G (Ecuador)
out8 <- eezs %>% filter(UNION %in% c("Ecuador")) %>% 
  st_intersection(ne_10m_ocean) %>% select(geometry) %>%
    mutate(accuracy = "approximate", survey = "", large_area = "SP", species = "Hbk", subareas = c("BS G (Ecuador)"), source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")
mappingf(out8)

#BS E1 (East Australia)
g <- c("POLYGON ((152 -25, 154 -25, 154 -28, 152 -28, 152 -25))")
s <- c("BS E1 (East Australia)")
outE1 <- wktfunction(GEOM = g, Subareas = s) %>% select(subareas, geometry) %>% mutate(accuracy = "approximate", survey = "", large_area = "SP", species = "Hbk", source = "built from approximate coordinates")
mappingf(outE1)

#BS E2 (Oceania)
outE2 <- eezs %>% filter(UNION %in% c("New Caledonia")) %>%
  st_intersection(ne_10m_ocean) %>% select(geometry) %>%
  mutate(accuracy = "approximate", survey = "", large_area = "SP", species = "Hbk", subareas = c("BS E2 (Oceania)"), source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")
mappingf(outE2)

#BSs E2+E3+F (Oceania)
outF <- eezs %>% filter(UNION %in% c("French Polynesia","Cook Islands")) %>% 
  st_intersection(ne_10m_ocean)  %>% select(geometry) %>% dplyr::summarize() %>% 
  mutate(source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry", accuracy = "approximate", survey = "", large_area = "SP", species = "Hbk", subareas = c("BS F"))
outE3 <- eezs %>% filter(UNION %in% c("Tonga")) %>%
  st_intersection(ne_10m_ocean) %>%  select(geometry) %>% 
  mutate(source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry", accuracy = "approximate", survey = "", large_area = "SP", species = "Hbk", subareas = c("BS E3"))

outO <- rbind(outE2, outE3, outF) %>% group_by() %>% dplyr::summarize() %>% mutate(source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry", accuracy = "approximate", survey = "",large_area = "SP", species = "Hbk", subareas = "BSs E2+E3+F (Oceania)")
m <- mappingf(outO); m

#IDCR/SOWER
#IV V I II III VI circumpolar
sower<- st_read("SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp")%>% filter(species == "Hbk") %>% mutate(source = "based on coordinates derived from maps") %>% mutate(large_area = "SO") 

#JARPA
#Area IV, Area V
j <- st_read("SH-JARPA-JARPAII/JARPA-JARPAII-areas.shp")%>% 
  filter(subareas %in% c("Area IV", "Area V"), species == "Hbk", survey == "JARPA") %>% mutate(source = "based on known coordinates derived from maps")

#JARPA/JARPAII
jj2 <- st_read("SH-JARPA-JARPAII/JARPA-JARPAII-areas.shp") %>% 
  filter(subareas %in% c( "Area IV", "Area V", "Area IIIE", "Area VIW"), species == "Hbk", survey == "JARPA/JARPAII") %>% mutate(source = "based on known coordinates derived from maps", survey = "JARPA+JARPAII")

#### final output ####
output <- dplyr::bind_rows(list(out1, out2, out3, out4, out5, out6, out7, out8, outD, outE1, outE2, outE3, outF, outO, sower,j, jj2)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
#save 
write_sf(output, "SH-Hbk/SH-Hbk-subareas.shp")
