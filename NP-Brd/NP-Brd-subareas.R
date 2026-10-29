#### North Pacific Bryde's whales ####
######################################
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

# subareas 1 and 2
df <- structure(list(
  geometry = c(
    "POLYGON ((165 43, 165 20, 130 20, 130 27, 132 27, 132 32, 134 32, 134 33, 137 33, 137 34, 140 34, 140 39, 141 43, 165 43))",
    "POLYGON ((165 20, 165 43, 180 43, 180 20, 165 20))",
    "POLYGON ((-155 43, -180 43, -180 25, -155 25, -155 43))"
  ), subareas = c('1W', '1E', '2')), 
  row.names = c(NA, -3L), 
  class = c("tbl_df", "tbl", "data.frame"))
sf <- sf::st_as_sf( df, wkt = "geometry", crs = 4326)

#plot to check
orp  <- ggplot() +geom_sf(data = sf, aes(fill = subareas)) +
  geom_sf(data = ne_10m_ocean) +
  coord_sf(ylim = c(20,43), expand = T)

#clip the polygons with the world 
out1 = st_intersection(sf, ne_10m_ocean) %>% select(subareas,geometry)
#no survey
jd <- out1 %>% mutate(survey = "JD", species = "Brd", accuracy = "accurate", large_area="NP", source = "derived from known coordinates - see original IWC maps")
#JARPN
jarpn <- out1 %>% mutate(survey = "JARPN", species = "Brd", accuracy = "accurate", large_area="NP", source = "derived from known coordinates - see original IWC maps")
#POWER+JARPNII
pjarpn2 <- out1 %>% mutate(survey = "POWER+JARPNII", species = "Brd", accuracy = "accurate", large_area="NP", source = "derived from known coordinates - see original IWC maps")

#add the Hawaian EEZ
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "Brd", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ", source = "EEZ derived from Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3) https://marineregions.org/sources.php#unioneezcountry")

# add the ETP
strJ = c("POLYGON ((-155 -5, -155 25, -75 25, -75 -5,-155 -5))") 
subareas = c('Eastern Tropical Pacific')
areasJ <- st_as_sf(data.frame(subareas = subareas, geometry=strJ, accuracy = "approximate"),wkt="geometry", crs = 4326)
ETP <- st_intersection(st_make_valid(areasJ), ne_10m_ocean)
ETP = ETP[c(1,2),] %>%
  select(geometry) %>% summarise() %>% mutate(subareas = 'Eastern Tropical Pacific',species = "Brd", accuracy = "approximate", large_area="NP", source = "based on approximate coordinates")
p <- mappingf(ETP); p

#7+8+9 ####
sen <- st_read("NP-Mi/NP-minkes-subareas.shp") %>% 
  select(subareas, geometry) %>% filter(subareas == "7+8+9") %>% 
  distinct() %>% st_intersection(ne_10m_ocean) %>%
  mutate(subareas = "7+8+9", species = "Brd", accuracy = "accurate", large_area = "NP", source = "original coordinates derived from IWC maps and corrected manually in QGIS") %>% 
  mutate(survey = list(c("","JD","JARPNII","KD","JARPN"))) %>% unnest(survey)
mappingf(sen)

#### final output ####
output <- dplyr::bind_rows(list(jd,jarpn,pjarpn2,Hawaii,ETP,sen)) %>% 
  mutate(large_area = "NP", species = "Brd")
View(output)
#make map
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
write_sf(output, "NP-Brd/NP-Brd-subareas.shp",append=FALSE)
