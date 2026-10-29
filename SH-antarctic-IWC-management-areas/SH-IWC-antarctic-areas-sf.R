# =============================================================================
# Southern Hemisphere IWC Management areas
# =============================================================================
#
# Purpose
# -------
# Construct the broad Antarctic IWC areas used by the abundance database.
#
# Workflow
# --------
# 1. Define IWC areas directly from longitude/latitude limits using WKT.
# 2. Convert the WKT definitions to an sf object in WGS84 (EPSG:4326).
# 3. Clip the geometries to the Natural Earth ocean polygons.
# 4. Add database attributes describing accuracy, survey programme and
#    large-area grouping.
# 5. Replicate the areas for each species to which they apply.
# 6. Write the resulting spatial layer to disk.
#
# Dependency
# ----------
# `set up and functions.R` loads sf/tidyverse, helper functions and the
# external ocean/land layers used below.
# =============================================================================

source("set up and functions.R")


# =============================================================================
# 1. Define IWC areas from coordinates
# =============================================================================

# Area V crosses the +/-180 degree longitude boundary and is therefore stored
# as a MULTIPOLYGON.
#
# The final "Circumpolar-S of 60S" feature represents the full circumpolar
# area south of 60 degrees South and also crosses the dateline.
df <- structure(
  list(
    geometry = c(
      "POLYGON ((-120 -60, -60 -60, -60 -90, -120 -90, -120 -60))",
      "POLYGON ((-60 -60, 0 -60, 0 -90, -60 -90, -60 -60))",
      "POLYGON ((0 -60, 70 -60, 70 -90, 0 -90, 0 -60))",
      "POLYGON ((70 -60, 130 -60, 130 -90, 70 -90, 70 -60))",
      "MULTIPOLYGON (((130 -60, 180 -60, 180 -90, 130 -90, 130 -60)), ((-170 -60, -170 -90, -180 -90, -180 -60, -170 -60)))",
      "POLYGON ((-170 -60, -120 -60, -120 -90, -170 -90, -170 -60))",
      "MULTIPOLYGON (((0 -60, 180 -60, 180 -90, 0 -90, 0 -60)), ((-180 -60, -180 -90, 0 -90, 0 -60, -180 -60)))"
    ),
    subareas = c(
      "Area I", "Area II", "Area III", "Area IV", "Area V", "Area VI",
      "Circumpolar-S of 60S"
    )
  ),
  row.names = c(NA, -7L),
  class = c("tbl_df", "tbl", "data.frame")
)


# =============================================================================
# 2. Convert WKT to sf
# =============================================================================

sf <- sf::st_as_sf(df, wkt = "geometry", crs = 4326)

# Quick diagnostic plot of the un-clipped geometries.
plot(sf)


# =============================================================================
# 3. Prepare reference layers and clip areas to ocean
# =============================================================================

# These objects are loaded by `set up and functions.R`.
world <- land
oceans <- ne_10m_ocean

# Intersect the IWC polygons with the ocean layer so that land is excluded.
#
# Metadata added here:
#   accuracy   whether the spatial boundary is considered accurately known;
#   survey     survey/management programme associated with these areas;
#   large_area broad geographical grouping.
#
# IMPORTANT:
# st_intersection() can split one input feature into multiple output features.

output <- sf %>%
  mutate(large_area = c("SO", "SO", "SO", "SO", "SO", "SO", "SH")) %>% 
  st_intersection(oceans) %>% 
  select(geometry,subareas,large_area) %>%
  mutate(
    accuracy = "accurate",
    survey = "IDCR/SOWER"
  ) 

# =============================================================================
# 4. Visual check
# =============================================================================

mappingf(output)


# =============================================================================
# 5. Associate the areas with each applicable species
# =============================================================================

# The same spatial boundaries are used for each of the species codes below.
# Replicating the features by species allows the final spatial data to be
# matched directly to abundance records using subarea + survey + species.
Outlist <- list()

for (i in c("Ablu", "AMi", "Fin", "Hbk", "Spr", "Srht","SoBottlW")) {
  Outlist[[i]] <- output %>% mutate(species = i)
}

out <- do.call("rbind", Outlist)


# =============================================================================
# 6. Write output
# =============================================================================

write_sf(out,"SH-antarctic-IWC-management-areas/SH-IWC-antarctic-areas.shp")

