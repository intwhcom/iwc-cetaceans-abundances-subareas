#### North Pacific humpbacks ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### read in the assessment areas ####
dt2 <- st_read("NP-Hbk/assessment-subareas/NPhuwhRegions.1Apr2024_split180.shp") %>% st_buffer(dist = 0.0001) %>% st_intersection(ne_10m_ocean) %>% 
  rename(subareas = Name)

mappingf(dt2)

# north pacific ####
NP <- goas %>% filter(name == "North Pacific Ocean") %>% st_intersection(ne_10m_ocean)

ggplot() + geom_sf(data = NP, fill = "lightblue")

areasNP <- NP %>% select(geometry) %>% mutate(subareas = "North Pacific", accuracy = "accurate", large_area = "NP", species = "Hbk", survey = "", source = "derived from marineregions GOAS v1")
m <- mappingf(areasNP); m


# all IA subareas - no survey ####
IAsubareas <- dt2 %>% select(geometry, subareas) %>% mutate(accuracy = "accurate", large_area = "NP", species = "Hbk", survey = "", source = "IWC-SC's IA, provided by D. Palka") 
mappingf(IAsubareas)

# Wade's SPLASH outputs #
#-----------------------
wade_splash <- dt2 %>%
  select(subareas, geometry) %>% 
  mutate(large_area = "NP", species = "Hbk", accuracy = "accurate", source = "subareas for IWC-SC's IA, provided by D. Palka", survey = "SPLASH")
mappingf(wade_splash)

# GOA #
# -------------
goa <- dt2 %>% filter(subareas %in% c("WGOA","NGOA")) %>%  
  st_union() %>% # unite to a geometry object
  st_sf() %>% # make the geometry a data frame object
  mutate(subareas = "WGOA+NGOA", large_area = "NP", species = "Hbk", accuracy = "accurate", source = "disolved polygons from subareas for IWC-SC's IA, provided by D. Palka", survey = "SPLASH")
mappingf(goa)

# Mexico - MX #
# -------------
MX <- dt2 %>% filter(subareas %in% c("MX_ML","MX_AR","MX_BJ")) %>%  
  st_union() %>% # unite to a geometry object
  st_sf() %>% # make the geometry a data frame object
  mutate(subareas = "MX", large_area = "NP", species = "Hbk", accuracy = "accurate", source = "disolved polygons from subareas for IWC-SC's IA, provided by D. Palka")
mappingf(MX)
#with survey = SPLASH
MXsplash <- MX %>% mutate(survey = "SPLASH") 

# JARPNII area #
#---------------
# read in the areas:
JARPNII <- st_read('NP-JARPNII/JARPNII.shp')
# select and add columns
JARPN2 <- JARPNII %>% filter(subareas == "N of 35N, 140E-170E") %>% st_intersection(ne_10m_ocean) %>% mutate(large_area = "NP", species = "Hbk", source = "built from known coordinates") %>% mutate(survey = "JARPNII")
# map
m <- mappingf(JARPN2); m

# Western N. Pacific ####
# not necessary anymore but keeping just in case #
str1 = c("POLYGON((115 -10, 180 -10, 180 90, 115 90, 115 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasWNP <- areasNP %>% 
  st_crop(st_bbox(c(xmin=115, ymin=-10, xmax=179.999, ymax=90))) %>%
  st_make_valid() %>% mutate(subareas = "WN Pacific", accuracy = "accurate", large_area = "NP", species = "Hbk", survey = "", source = "built from known coordinates") 
m <- mappingf(areasWNP); m

# SPLASH survey #
#---------------

#main georeferenced data:
splash1 <- st_read("NP-Hbk/georeferenced/splash_georeferenced.shp") %>% st_transform(crs = 4326) %>%
  rename(subareas = "subarea") %>%  select(-id)
  #mutate(large_area = "NP", species = "Hbk", accuracy = "approximate", survey = "SPLASH", source = "georeferenced") %>%

#Hbk feeding grounds - wintering grounds
lookupf <- data.frame(subareas = c("Aleutian Is.-Bering Sea" ,"Gulf of Alaska" ,"SE Alaska-N British Columbia", "S British Columbia - N.Washington", "California-Oregon" , "Mexico" , "Central America" , "Hawaii", "Gulf of Anadyr", "Kamchatka", "Commander Is.", "Okinawa", "Ogasawara", "Philippines"), bigareas = c("Hbk feeding grounds" ,"Hbk feeding grounds" ,"Hbk feeding grounds", "Hbk feeding grounds", "Hbk feeding grounds" , "Hbk wintering grounds" , "Hbk wintering grounds" , "Hbk wintering grounds", "Hbk feeding grounds","Hbk feeding grounds","Hbk feeding grounds" , "Hbk wintering grounds", "Hbk wintering grounds","Hbk wintering grounds"))
areas1 <- merge(splash1,lookupf, by="subareas")
ncdissolve <- st_make_valid(areas1) %>% group_by(bigareas) %>% summarize() %>% rename(subareas = bigareas) 

splash6 <- st_intersection(st_make_valid(st_transform(ncdissolve,crs = st_crs(NP))), NP) %>% 
  filter(subareas %in% c("Hbk feeding grounds" , "Hbk wintering grounds")) %>% 
  mutate(large_area = "NP", species = "Hbk", accuracy = "approximate", survey = "SPLASH", source = "georeferenced")

m <- mappingf(splash6); m
rm(area1, ncdissolve)

# Central_Am/MX-OR+CA/SBC+WA #
# ---------------------------
paceastcoast <- dt2 %>% filter(subareas %in% c("Central_Am","MX_ML","MX_AR","MX_BJ","OR+CA","SBC+WA")) %>% st_buffer(0.0005) %>% 
  st_union() %>% # unite to a geometry object
  st_sf() %>% # make the geometry a data frame object
  mutate(subareas = "Central_Am/MX-OR+CA/SBC+WA", large_area = "NP", species = "Hbk", accuracy = "accurate", source = "disolved polygons from subareas for IWC-SC's IA, provided by D. Palka")
mappingf(paceastcoast)

# California Current Ecosystem #
#-------------------------------
cce <- lmeco %>% filter(LME_NAME == "California Current") %>%
  select(geometry) %>%
  st_sf() %>% # make the geometry a data frame object
  mutate(subareas = "California Current Ecosystem", large_area = "NP", species = "Hbk", accuracy = "accurate", source = "polygon extracted from Large Marine Ecosystem Program NOAA-Fisheries Narragansett Laboratory Narragansett, R.I. 02882.")
mappingf(cce)

# Aleutian Islands and Alaska Peninsula #
#---------------------------------------
zerbini2006 <- st_read("NP-Hbk/georeferenced/zerbini_2006.shp") %>% st_transform(crs = 4326) %>% select(geometry) %>%
  mutate(subareas = "Aleutian Islands and Alaska Peninsula", large_area = "NP", species = "Hbk", accuracy = "approximate", source = "georeferenced")

mappingf(zerbini2006)

# final output #
#---------------
output <- dplyr::bind_rows(list(IAsubareas, JARPN2, areasNP, areasWNP, splash6, MX, MXsplash, goa, paceastcoast,cce,wade_splash,zerbini2006)) %>% 
  select(subareas, geometry,accuracy,survey,source) %>% 
  mutate(large_area = "NP", species = "Hbk")
#View(output)
mappingf(output)
write_sf(output, "NP-Hbk/NP-Hbk-subareas.shp")

