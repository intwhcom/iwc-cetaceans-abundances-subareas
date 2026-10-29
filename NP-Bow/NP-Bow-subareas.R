# North Pacific Bowhead Subareas #
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#### Okhotsk Sea ####
Okhotsk <- IHOseas %>% filter(NAME == "Sea of Okhotsk" )%>% summarize() %>% mutate(subareas = "Okhotsk Sea", large_area = "NP", accuracy = "approximate", source = "derived from World Seas IHO v3") 

m <- mappingf(Okhotsk); m

#### BCB ####
BCB <- IHOseas %>% filter(NAME %in% c("Bering Sea", "Chukchi Sea", "Beaufort Sea"))%>% summarize() %>% mutate(subareas = "BCB", large_area = "NP", accuracy = "approximate", source = "derived from World Seas IHO v3") 

m <- mappingf(BCB); m

#### final output ####
output <- dplyr::bind_rows(list(Okhotsk, BCB)) %>% 
  select(subareas, geometry,accuracy, source) %>% 
  mutate(large_area = "NP", species = "Bow", survey = "")
View(output)
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
write_sf(output, "NP-Bow/NP-Bow-subareas.shp")
