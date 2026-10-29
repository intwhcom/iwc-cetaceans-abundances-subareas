# calculate the area of the subareas in km2 #

sf::sf_use_s2(FALSE)
library(sf)
library(tidyverse)
library(units)

outNA <- "combine/output/NA-subareas.shp"
outNP <- "combine/output/NP-subareas.shp"
outSH <- "combine/output/SH-subareas.shp"

shps <- c(outNA,outNP,outSH)
ALLshps <- lapply(shps,st_read)
ALLSubs <- dplyr::bind_rows(ALLshps)
st_crs(ALLSubs)

# Transform to an equal-area projection (e.g., Mollweide)
global_polygons_proj <- st_transform(ALLSubs, crs = 6933)

# Calculate area in square meters
global_polygons_proj$area_m2 <- st_area(global_polygons_proj)

# Convert to square kilometers
global_polygons_proj$area_km2 <- set_units(global_polygons_proj$area_m2, "km^2")

min(global_polygons_proj$area_km2)
median(global_polygons_proj$area_km2)
max(global_polygons_proj$area_km2)
hist(global_polygons_proj$area_km2)
mean(global_polygons_proj$area_km2)
