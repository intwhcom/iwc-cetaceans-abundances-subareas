# =============================================================================
# Setup and helper functions for development of IWC abundance subarea polygons
# =============================================================================
#
# Purpose
# -------
# This script:
#   1. loads the spatial and data-manipulation packages used by the subarea
#      construction scripts;
#   2. defines helper functions for mapping, creating polygons from WKT and
#      dissolving existing shapefiles;
#   3. loads external spatial reference layers used by downstream scripts.
#
# Intended use
# ------------
# Source this file from the individual subarea-construction scripts, e.g.:
#
#   source("set up and functions.R")
#
# =============================================================================

# Disable the s2 spherical geometry engine.
# This makes sf use planar/geometrical operations for functions such as
# st_intersection() and st_buffer().
sf::sf_use_s2(FALSE)

library(sf)
library(tidyverse)


# =============================================================================
# Mapping helper
# =============================================================================

# Plot a subarea sf object and label each polygon using the `subareas` field.
#
# Input:
#   x  sf object containing a geometry column and a `subareas` attribute.
#
# Output:
#   A ggplot object. The plot is also printed when the function is called.
#
# Dependency:
#   Uses the global object `ne_10m_ocean`, loaded later in this script.
#
# NOTE:
# st_centroid() is used only to obtain label positions. For complex or
# multipart polygons, centroids can fall outside the polygon.
mappingf <- function(x){
  library("ggplot2")
  theme_set(theme_bw())

  areas_bbox <- st_bbox(x)
  x <- cbind(x, st_coordinates(st_centroid(x)))

  y <- ggplot() +
    geom_sf(data = x, aes(fill = subareas), alpha = 0.3) +
    geom_sf(data = ne_10m_ocean, fill = "lightgrey", alpha = 0.3) +
    geom_text(data = x, aes(X, Y, label = subareas), size = 3, col = "red") +
    coord_sf(
      xlim = c(areas_bbox$xmin, areas_bbox$xmax),
      ylim = c(areas_bbox$ymin, areas_bbox$ymax),
      expand = TRUE
    )

  print(y)
  return(y)
}

#use to map multiple species
mapping_sp <- function(x){
  
  library("ggplot2")
  theme_set(theme_bw())
  library(ggrepel)
  areas_bbox <- st_bbox(x)
  x <- cbind(x, st_coordinates(st_centroid(x)))
  y <- ggplot() + geom_sf(data = x, aes(fill = species), colour = "grey", alpha=0.3) + geom_sf(data = land, colour = "#D9CBA5", fill = "#D9CBA5") + coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T) 
  
  return(y)
}

# =============================================================================
# Create polygons from WKT
# =============================================================================

# Convert WKT polygon definitions and subarea names into an sf object and clip
# the resulting polygons to an ocean polygon layer.
#
# Inputs:
#   GEOM      character vector containing polygon geometries in WKT format.
#   Subareas  character vector containing the corresponding subarea names.
#
# Output:
#   sf object in WGS84 (EPSG:4326), clipped to `ne_10m_ocean`.
#

wktfunction <- function(GEOM, Subareas){
  df <- structure(
    list(geometry = GEOM, subareas = Subareas),
    row.names = c(NA, -length(Subareas)),
    class = c("tbl_df", "tbl", "data.frame")
  )

  sf <- sf::st_as_sf(df, wkt = "geometry", crs = 4326)
  output <- st_intersection(sf, ne_10m_ocean)
  return(output)
}


# =============================================================================
# Dissolve existing polygons
# =============================================================================

# Read a spatial file, dissolve all polygons into one geometry, and assign a
# single subarea name.
#
# Inputs:
#   shp          path to a spatial file readable by sf::st_read().
#   subareaname  name assigned to the dissolved polygon.
#
# Output:
#   sf object with one dissolved geometry and a `subareas` field.
dissolve <- function(shp, subareaname){
  inx <- st_read(shp)
  outx <- inx %>%
    st_union() %>%
    st_sf() %>%
    mutate(subareas = subareaname)
  return(outx)
}

# Variant of dissolve() that applies a small positive buffer before unioning
# and an equivalent negative buffer afterwards. This can close very small gaps
# that would otherwise prevent polygons from dissolving cleanly.
#
# IMPORTANT:
# These data are generally in EPSG:4326 and s2 is disabled above, so the buffer
# distance is interpreted in coordinate units (degrees), not metres.
dissolve_b <- function(shp, subareaname, buffer_dist = 0.0015){
  inx <- st_read(shp)

  outx <- inx %>%
    st_buffer(buffer_dist) %>%   # buffer outward slightly
    st_union() %>%               # merge polygons
    st_buffer(-buffer_dist) %>%  # approximately restore original boundary
    st_sf() %>%
    mutate(subareas = subareaname)

  return(outx)
}


# =============================================================================
# External spatial reference data
# =============================================================================
#
# These layers are used as source/reference geometries in the individual
# subarea-construction scripts.
#

# Natural Earth ocean polygons
ne_10m_oceanshp <- "../../thirdpartydata\\NaturalEarth\\oceans\\ne_10m_ocean.shp"
ne_10m_ocean <- st_read(ne_10m_oceanshp)

# Marine Regions: Global Oceans and Seas (GOaS)
goasshape <- "../../thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp"
goas <- st_read(goasshape)

# Exclusive Economic Zones / land union
eezshp <- "../../thirdpartydata\\EEZ_land_union_v3_202003\\EEZ_Land_v3_202030.shp"
eezs <- st_read(eezshp)

# Large Marine Ecosystems
lmeshp <- "../../thirdpartydata\\large marine ecosystems\\LME66.shp"
lmeco <- st_read(lmeshp)

# Natural Earth land polygons
landshape <- "../../thirdpartydata/NaturalEarth/land/ne_10m_land.shp"
land <- st_read(landshape)

# IHO world seas
IHOseasshape <- "..\\..\\thirdpartydata\\marineregions\\World_Seas_IHO_v3\\World_Seas_IHO_v3.shp"
IHOseas <- st_read(IHOseasshape)

# FAO areas
faofishingareas <- st_read("../../thirdpartydata/FAO/FAO Fishing areas/FAO_AREAS_CWP.shp")

# GOM-GB_Regulated_Mesh_Areas
GOM_GB <- st_read("../../thirdpartydata\\GOM-GB_Regulated_Mesh_Areas\\GOM-GB_Regulated_Mesh_Areas.shp")

# IUCN distribition maps
iucnmms <- "../../thirdpartydata/redlist_species_data\\MAMMALS_MARINE_ONLY.shp"
allmms <- st_read(iucnmms)

# IHO-EEZs
ihoeezshp <- "../../thirdpartydata/World_EEZ_v12_20231025/eez_v12.shp"
ihoeezs <- st_read(ihoeezshp)
