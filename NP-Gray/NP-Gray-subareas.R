# Gray whales #
#~~~~~~~~~~~~~#

source("set up and functions.R")

#### subareas ####
str = c("POLYGON ((-122.36366693211988 49.003934013787585, -131.486187 49.003934013787585, -128.350896 40.337663, -123.077458 40.337663, -122.36366693211988 49.003934013787585))",
        "POLYGON ((-155 62, -110 62, -110 30, -155 30, -155 62))",
        "POLYGON ((160.917350 55.990503, 163.993522 55.620043, 159.071647 50.727540, 156.654655 51.772720, 160.917350 55.990503))",
        "POLYGON ((143 53.6, 144 53.6, 144 51.8, 143 51.8, 143 53.6))") 
  
subareas = c('PCFG: N.California - N.Vancouver Is','Eastern Pacific','Kamchatka Feeding Group', 'Sakhalin Feeding Group')
areas <- st_as_sf(data.frame(subareas = subareas, geometry=str, accuracy = "approximate"),wkt="geometry", crs = 4326)
sareas <- st_intersection(st_make_valid(areas), ne_10m_ocean) %>%
  mutate(species = "Gray", survey = c("CRC photographic catalog", "SWFSC shore-based surveys","",""), source = "based on approximate coordinates")
mappingf(sareas[c(1,2),])
mappingf(sareas[c(3,4),])

# Western Feeding Group ####
wfg = sareas[c(3,4),] %>%
  select(geometry) %>% summarise() %>% mutate(subareas = "Western Feeding Group", accuracy = "approximate", species = "Gray", survey = "", source = "based on approximate coordinates")
p <- mappingf(wfg); p

#### final output ####
output <- dplyr::bind_rows(list(sareas, wfg)) %>% 
  select(subareas, geometry,accuracy,species,survey, source) %>% 
  mutate(large_area = "NP")
View(output)
output %>% 
  st_shift_longitude() %>% mappingf()
write_sf(output, "NP-Gray/NP-Gray-subareas.shp")
