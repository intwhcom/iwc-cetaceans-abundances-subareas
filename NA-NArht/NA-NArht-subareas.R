#### North Atlantic rights Whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

#wN.Atlantic
# draw a polygons based on :
#GBIF.org (06 January 2025) GBIF Occurrence Download  https://doi.org/10.15468/dl.unpxra
wNA <- st_read("NA-NArht/from_GBIF/nwAtl.shp") %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "NArht", source = "the NA right whales GBIF Occurrence points were derived from GBIF.org (06 January 2025); Download  https://doi.org/10.15468/dl.unpxra. Points were selected along the US and Canadian coasts, to cover known habitats, the concave hull of the points was drawn and buffered by 1DD.", subareas = "wN.Atlantic")
mappingf(wNA)

eNA <- st_read("NA-NArht/from_GBIF/neAtl.shp") %>% st_intersection(ne_10m_ocean) %>% 
  mutate(accuracy = "approximate", survey = "", large_area = "NA", species = "NArht", source = "the NA right whales GBIF Occurrence points were derived from GBIF.org (06 January 2025); Download  https://doi.org/10.15468/dl.unpxra. Points were selected east of 50W, the concave hull of the points was drawn and buffered by 1DD.", subareas = "eN.Atlantic")
mappingf(eNA)

#final output:
output <- dplyr::bind_rows(list(wNA, eNA)) %>% select(subareas, geometry, accuracy, survey, large_area, species, source)
View(output)
mappingf(output)
write_sf(output, "NA-NArht\\NA-NArht-subareas.shp")
