# Split North Pacific polygons at the antimeridian (±180°) to
# prevent mapping issues caused by edges crossing the dateline.
# The script shifts longitudes to 0–360°, repairs geometries,
# cuts them at 180°, and returns them to −180° to +180°.
# Split pieces are stored as a MULTIPOLYGON, preserving one row
# per original feature and all original attribute values.
# The result is checked and saved as a new WGS84 shapefile.

library(sf)

# ------------------------------------------------------------
# 1. File paths
# ------------------------------------------------------------

input_dir <- "NP-Hbk/assessment-subareas/"

input_file <- file.path(
  input_dir,
  "NPhuwhRegions.1Apr2024.shp"
)

output_file <- file.path(
  input_dir,
  "NPhuwhRegions.1Apr2024_split180.shp"
)

library(sf)

# ============================================================
# 2. Read the shapefile
# ============================================================

x <- st_read(input_file, quiet = TRUE)

if (is.na(st_crs(x))) {
  stop("Input CRS is missing. Assign the correct source CRS first.")
}

if (!all(st_geometry_type(x) %in% c("POLYGON", "MULTIPOLYGON"))) {
  stop("The input must contain only polygons or multipolygons.")
}

if (st_crs(x) != st_crs(4326)) {
  x <- st_transform(x, 4326)
}

original_attributes <- st_drop_geometry(x)

# ============================================================
# 3. Prepare geometry in 0–360° longitude
# ============================================================

g <- st_shift_longitude(st_geometry(x))

# Temporarily remove CRS to perform a straight, planar cut.
# Coordinate values are unchanged by this step.
g <- st_set_crs(g, NA)

# Repair geometry AFTER shifting longitude.
g <- st_make_valid(g)

# ============================================================
# 4. Define helper functions
# Run these COMPLETE function definitions.
# ============================================================

# Create a rectangular clipping polygon.
make_box <- function(xmin, xmax) {
  
  st_sfc(
    st_polygon(list(rbind(
      c(xmin, -90),
      c(xmax, -90),
      c(xmax,  90),
      c(xmin,  90),
      c(xmin, -90)
    )))
  )
}

# Recursively collect polygon components.
# Lines and points produced by boundary touches are discarded.
get_polygons <- function(geometry) {
  
  if (inherits(geometry, "POLYGON")) {
    return(list(geometry))
  }
  
  if (inherits(geometry, "MULTIPOLYGON")) {
    return(lapply(geometry, function(part) st_polygon(part)))
  }
  
  if (inherits(geometry, "GEOMETRYCOLLECTION")) {
    result <- list()
    
    for (component in geometry) {
      result <- c(result, get_polygons(component))
    }
    
    return(result)
  }
  
  # Ignore point and line geometries.
  list()
}

# Return polygon components as an sfc object.
polygon_parts <- function(z) {
  
  result <- list()
  
  for (j in seq_along(z)) {
    if (!st_is_empty(z[j])) {
      result <- c(result, get_polygons(z[[j]]))
    }
  }
  
  result <- st_sfc(result, crs = st_crs(z))
  result[!st_is_empty(result)]
}

# ============================================================
# 5. Define clipping rectangles
# ============================================================

west_box <- make_box(0, 180)
east_box <- make_box(180, 360)

# ============================================================
# 6. Define how to split ONE feature
# ============================================================

split_one <- function(i) {
  
  west <- polygon_parts(
    st_intersection(g[i], west_box)
  )
  
  east <- polygon_parts(
    st_intersection(g[i], east_box)
  )
  
  # Convert eastern pieces back to negative longitudes.
  # Their boundary at +180° becomes -180°.
  if (length(east) > 0L) {
    east <- east - c(360, 0)
  }
  
  pieces <- c(west, east)
  
  if (length(pieces) == 0L) {
    stop("No polygon geometry remains for feature row ", i)
  }
  
  # Assemble one multipolygon, preserving holes.
  st_multipolygon(
    lapply(
      seq_along(pieces),
      function(j) unclass(pieces[[j]])
    )
  )
}

# ============================================================
# 7. Apply the split and restore the CRS
# ============================================================

new_geometry <- st_sfc(
  lapply(seq_len(nrow(x)), split_one),
  crs = 4326
)

# Replace ONLY the geometry; retain the attribute table.
x_split <- x
st_geometry(x_split) <- new_geometry

# ============================================================
# 8. Verify attributes and geometry
# ============================================================

stopifnot(
  nrow(x_split) == nrow(x),
  identical(st_drop_geometry(x_split), original_attributes),
  !any(st_is_empty(x_split))
)

# Check validity in the planar representation used for the cut.
valid <- st_is_valid(
  st_set_crs(st_geometry(x_split), NA)
)

bad <- which(is.na(valid) | !valid)

if (length(bad) > 0L) {
  stop(
    "Invalid output geometry in feature row(s): ",
    paste(bad, collapse = ", ")
  )
}

message(
  "Preserved all ", nrow(x_split), " features and all ",
  ncol(original_attributes), " attribute columns."
)

# Diagnostic table — does not add columns to the output.
print(data.frame(
  Name = x_split$Name,
  polygon_parts = vapply(
    st_geometry(x_split),
    length,
    integer(1)
  )
))

# ============================================================
# 9. Inspect EAL+BER
# ============================================================

eal <- x_split[
  which(x_split$Name == "EAL+BER"),
]

if (nrow(eal) > 0L) {
  plot(
    st_geometry(eal),
    col = "lightblue",
    border = "grey40",
    axes = TRUE,
    main = "EAL+BER — split at 180°"
  )
}

# ============================================================
# 10. Save as a NEW shapefile
# ============================================================

if (file.exists(output_file)) {
  stop("Output already exists. Change output_file to a new filename.")
}

st_write(
  x_split,
  output_file,
  append = FALSE,
  quiet = TRUE
)

message("Saved: ", output_file)
