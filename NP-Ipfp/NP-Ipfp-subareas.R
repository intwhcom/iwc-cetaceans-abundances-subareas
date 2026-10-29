#### North Pacific Indo-Pacific finless porpoise ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

source("set up and functions.R")

ipfp <- "NP-Ipfp/georeferenced/HKIpfp.shp"

ipfpshp <- st_read(ipfp)

ipfppoly <- ipfpshp %>% select(geometry) %>% mutate(species = "Ipfp", accuracy = "approximate", large_area="NP", subareas = "Hong Kong waters", source = "georeferenced from original paper")

View(ipfppoly)
m <- mappingf(ipfppoly); m
write_sf(ipfppoly, "NP-Ipfp/NP-Ipfp-subareas.shp")
