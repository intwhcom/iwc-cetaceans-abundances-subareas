# =============================================================================
# JARPNII subareas
# =============================================================================
#
# Purpose
# -------
# Construct the spatial subareas associated with JARPNII surveys
# for the IWC cetacean abundance database.
#
# This script combines three types of spatial information:
#   1. JARPNII strata defined directly from longitude/latitude limits;
#   2. an approximate broader JARPNII area used for humpback whales;
#   3. existing minke-whale assessment subareas imported from an existing shapefile,
#      including a dissolved composite area "7+8+9".
#
# The resulting geometries are combined into one North Pacific spatial layer
# and written to a shapefile.
#
# Dependencies
# ------------
# `set up and functions.R` loads:
#   - sf and tidyverse;
#   - the `mappingf()` helper;
#   - the Natural Earth ocean polygons (`ne_10m_ocean`).
#
# The script also depends on an existing minke-whale subarea shapefile:
#
#   NP-Mi/Misubareas-10072024.shp
#
# Run this script from the root of the spatial-data repository, or adjust the
# relative paths accordingly.
# =============================================================================

source("set up and functions.R")


# =============================================================================
# 1. JARPNII strata 8S, 8N, 9-S and 9-N
# =============================================================================
#
# These four areas are constructed directly from their longitude/latitude
# boundaries using WKT polygons.
#
# The geometries are treated as accurately defined because their boundaries
# are explicitly described by coordinates.

subareas1 <- c(
  "8S",
  "8N",
  "9-S",
  "9-N"
)

str1 <- c(
  "POLYGON((150 35,157 35,157 40,150 40,150 35))",
  "POLYGON((150 40,157 40,157 46,150 46,150 40))",
  "POLYGON((157 35,170 35,170 40,157 40,157 35))",
  "POLYGON((157 40,170 40,170 53,157 53,157 40))"
)

# Convert WKT definitions into an sf object in WGS84 (EPSG:4326).
subas <- st_as_sf(
  data.frame(
    subareas = subareas1,
    geometry = str1,
    accuracy = "accurate",
    survey = "JARPNII"
  ),
  wkt = "geometry",
  crs = 4326
)

# Validate geometries and clip them to the Natural Earth ocean layer so that
# any land portions are removed.
JARPNII <- st_intersection(
  st_make_valid(subas),
  ne_10m_ocean
)

# Visual QA of the resulting polygons.
m <- mappingf(JARPNII)
m


# =============================================================================
# 2. Broader JARPNII area used for humpback whales
# =============================================================================
#
# This geometry represents an approximate area north of 35°N between
# approximately 140°E and 170°E.
#
# Unlike the four coordinate-defined strata above, this boundary is marked
# as "approximate" because the polygon is reconstructed from a broader spatial
# description rather than from an exact survey-stratum boundary.

subareasJ <- c(
  "N of 35N, 140E-170E"
)

strJ <- c(
  "POLYGON((140 35,170 35,170 50,165 52,155 45,150 42,145 44,140 42.5,140 35))"
)

areasJ <- st_as_sf(
  data.frame(
    subareas = subareasJ,
    geometry = strJ,
    accuracy = "approximate",
    survey = "JARPNII"
  ),
  wkt = "geometry",
  crs = 4326
)

# Validate and clip the reconstructed polygon to the ocean layer.
areasJ2 <- st_intersection(
  st_make_valid(areasJ),
  ne_10m_ocean
)

# Visual QA.
plot(areasJ2["subareas"])

m <- mappingf(areasJ2)
m


# =============================================================================
# 3. JARPNII areas derived from existing minke-whale assessment subareas
# =============================================================================
#
# Some JARPNII areas correspond directly to existing minke-whale assessment
# subareas. Rather than reconstructing those polygons from coordinates, the
# relevant geometries are selected from the existing North Pacific minke-whale
# subarea shapefile.

NPMisubs <- "NP-Mi/assessment-subareas/subareas 18032022.shp"

# Read the existing minke-whale assessment subareas.
NPMisubspoly <- st_read(NPMisubs)

# Select the minke-whale subareas used by JARPNII.
#
# Included codes:
#   10E, 11, 7, 7CN, 7CS, 7E, 7WR, 7WRN, 7WRS, 8, 9
#
# These geometries are treated as accurately defined because they are taken
# directly from the existing assessment-area spatial layer.
subareasJMi <- NPMisubspoly %>%
  filter(
    subareas %in% c(
      "10E", "11", "7", "7CN", "7CS",
      "7E", "7WR", "7WRN", "7WRS", "8", "9"
    )
  ) %>%
  mutate(
    accuracy = "accurate",
    survey = "JARPNII"
  )

# Visual QA.
m <- mappingf(subareasJMi)
m


# =============================================================================
# 4. Construct composite area "7+8+9"
# =============================================================================
#
# The abundance tables may also refer to the combined area "7+8+9".
# This geometry is constructed by dissolving minke-whale subareas 7, 8 and 9
# into a single polygon/multipolygon.

lookup1 <- data.frame(
  subareas = c("7", "8", "9"),
  bigareas = c("7+8+9", "7+8+9", "7+8+9")
)

# Join the selected subareas to the lookup table.
NPareas1 <- merge(
  NPMisubspoly,
  lookup1,
  by = "subareas"
)

# Dissolve the three geometries into one combined area and rename the grouping
# field to match the standard `subareas` attribute used elsewhere.
poly789 <- NPareas1 %>%
  group_by(bigareas) %>%
  summarize() %>%
  rename(subareas = bigareas)%>%
  mutate(
    accuracy = "accurate",
    survey = "JARPNII"
  )

# Visual QA.
m <- mappingf(poly789)
m


# =============================================================================
# 5. Combine all JARPNII spatial records
# =============================================================================

# Combine:
#   - coordinate-defined JARPNII strata;
#   - approximate humpback-whale JARPNII area;
#   - minke-whale assessment subareas used by JARPNII;
#   - dissolved composite area "7+8+9".
#
# Only the fields required for the final subarea layer are retained.
output <- dplyr::bind_rows(
  list(
    JARPNII,
    areasJ2,
    subareasJMi,
    poly789
  )
) %>%
  select(
    subareas,
    accuracy,
    geometry,
    survey
  ) %>%
  mutate(
    large_area = "NP"
  )

# Final visual QA before writing the output.
mappingf(output)


# =============================================================================
# 6. Write output
# =============================================================================
#
# The output is one shapefile containing the JARPNII subareas required for the
# North Pacific component of the abundance database.

write_sf(
  output,
  "NP-JARPNII/JARPNII.shp"
)
