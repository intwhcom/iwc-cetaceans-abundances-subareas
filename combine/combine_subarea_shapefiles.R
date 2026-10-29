# =============================================================================
# Build (optional) and combine IWC abundance subarea shapefiles
# =============================================================================
# Run from the project directory containing the species folders and
# "set up and functions.R". All paths below are relative to that directory.
#
# DEFAULT: read existing shapefiles and regenerate the combined outputs only.
# No construction script or setup/reference-layer loading runs by default.
# Requires installed packages: sf and dplyr.
#
# WORKFLOW
# 1. Edit the settings below.
# 2. Source this file.
# 3. Combined sf objects are available as NorthAtlanticSubs,
#    NorthPacificSubs, SouthernHemisphereSubs and allsubareas.
#
# Rebuilding runs the existing construction scripts unchanged. Those scripts
# may themselves source other files, write outputs or open plots.
# Missing input shapefiles cause an error; they are NOT rebuilt automatically.

# ---- 1. Settings --------------------------------------------------------------
rebuild_subareas <- FALSE      # TRUE: run construction scripts before combining
rebuild_ids <- NULL            # NULL: all enabled scripts; or c("NABlu", "SHFin"). rebuild_ids only controls which ones are recreated first.
write_app_copies <- TRUE       # Retains the original copies for the viewer app
make_maps <- FALSE            # Optional simple maps; no external basemap required
output_dir <- "combine/output"
app_dir <- "../Extras/abundances-viewer/view-abundances-whales"
target_crs <- 4326

# Examples (edit the settings ABOVE before sourcing):
# Combine existing files: rebuild_subareas <- FALSE
# Rebuild all enabled scripts: rebuild_subareas <- TRUE; rebuild_ids <- NULL
# Rebuild selected scripts: rebuild_subareas <- TRUE; rebuild_ids <- c("NABlu")
# Selection affects rebuilding only: all included files are still combined.

# ---- 2. File registry ---------------------------------------------------------
# One row per construction script and its expected shapefile.
# Paths and their capitalisation are retained exactly from the original.
# include: whether the shapefile belongs in the combined output.
# rebuild_enabled: whether an all-scripts rebuild should run this script.
#
# * NPMi was included but its source() was commented out: automatic rebuild
#   remains disabled. Explicitly listing "NPMi" in rebuild_ids will run it.
# Check the original spelling "NA-Narght-subareas.R" against your local files.
subarea_files <- tibble::tribble(
  ~id, ~region, ~script, ~shapefile, ~include, ~rebuild_enabled,
  "NABlu", "NA", "NA-Blu/NA-Blu-subareas.R", "NA-Blu/NA-Blu-subareas.shp", TRUE, FALSE,
  "NABow", "NA", "NA-Bow/NA-Bow-subareas.R", "NA-Bow/NA-Bow-subareas.shp", TRUE, FALSE,
  "NAFin", "NA", "NA-Fin/NA-Fin-subareas.R", "NA-Fin/NA-Fin-subareas.shp", TRUE, FALSE,
  "NAHbk", "NA", "NA-Hbk/NA-Hbk-subareas.R", "NA-Hbk/NA-Hbk-subareas.shp", TRUE, FALSE,
  "NAMi", "NA", "NA-Mi/NA-Mi-subareas.R", "NA-Mi/NA-Mi-subareas.shp", TRUE, FALSE,
  "NArht", "NA", "NA-NArht/NA-NArht-subareas.R", "NA-NArht/NA-NArht-subareas.shp", TRUE, FALSE,
  "NALPlt", "NA", "NA-NP-Plt/NA-LPlt-subareas.R", "NA-NP-Plt/NA-LPlt-subareas.shp", TRUE, FALSE,
  "NPSPlt", "NP", "NA-NP-Plt/NP-SPlt-subareas.R", "NA-NP-Plt/NP-SPlt-subareas.shp", TRUE, FALSE,
  "NARic", "NA", "NA-Ric/NA-Ric-subareas.R", "NA-Ric/NA-Ric-subareas.shp", TRUE, FALSE,
  "NASei", "NA", "NA-Sei/NA-Sei-subareas.R", "NA-Sei/NA-Sei-subareas.shp", TRUE, FALSE,
  "NASpr", "NA", "NA-Spr/NA-Spr-subareas.R", "NA-Spr/NA-Spr-subareas.shp", TRUE, FALSE,
  "NPBdu", "NP", "NP-Bdu/NP-Bdu-subareas.R", "NP-Bdu/NP-Bdu-subareas.shp", TRUE, FALSE,
  "NPBlu", "NP", "NP-Blu/NP-Blu-subareas.R", "NP-Blu/NP-Blu-subareas.shp", TRUE, FALSE,
  "NPBow", "NP", "NP-Bow/NP-Bow-subareas.R", "NP-Bow/NP-Bow-subareas.shp", TRUE, FALSE,
  "NPBrd", "NP", "NP-Brd/NP-Brd-subareas.R", "NP-Brd/NP-Brd-subareas.shp", TRUE, FALSE,
  "NPFin", "NP", "NP-Fin/NP-Fin-subareas.R", "NP-Fin/NP-Fin-subareas.shp", TRUE, FALSE,
  "NPGray", "NP", "NP-Gray/NP-Gray-subareas.R", "NP-Gray/NP-Gray-subareas.shp", TRUE, FALSE,
  "NPHawaii", "NP", "NP-Hawaii-various/Hawaii-various.R", "NP-Hawaii-various/NP-Hawaii-subareas.shp", TRUE, FALSE,
  "NPHbk", "NP", "NP-Hbk/NP-Hbk-subareas.R", "NP-Hbk/NP-Hbk-subareas.shp", TRUE, FALSE,
  "NPIpfp", "NP", "NP-Ipfp/NP-Ipfp-subareas.R", "NP-Ipfp/NP-Ipfp-subareas.shp", TRUE, FALSE,
  "NPMi", "NP", "NP-Mi/NP-minkes-subareas.R", "NP-Mi/NP-minkes-subareas.shp", TRUE, FALSE,
  "NPrht", "NP", "NP-rht/NP-rht-subareas.R", "NP-rht/NP-rht-subareas.shp", TRUE, FALSE,
  "NPSei", "NP", "NP-Sei/NP-Sei-subareas.R", "NP-Sei/NP-Sei-subareas.shp", TRUE, FALSE,
  "NPSpr", "NP", "NP-Spr/NP-Spr-subareas.R", "NP-Spr/NP-Spr-subareas.shp", TRUE, FALSE,
  "NPVqu", "NP", "NP-Vqu/NP-Vqu-subareas.R", "NP-Vqu/Vqu-subareas.shp", TRUE, FALSE,
  "SHAMi", "SH", "SH-AMi/SH-AMi-subareas.R", "SH-AMi/SH-AMi-subareas.shp", TRUE, FALSE,
  "SHBlu", "SH", "SH-Blu/SH-Blu-subareas.R", "SH-Blu/SH-Blu-subareas.shp", TRUE, FALSE,
  "SHFin", "SH", "SH-Fin/SH-Fin-subareas.R", "SH-Fin/SH-Fin-subareas.shp", TRUE, FALSE,
  "SHFin", "SH", "SH-Franciscana/SH-Fra-subareas.R", "SH-Franciscana/SH-Fra-subareas.shp", TRUE, FALSE,
  "SHHbk", "SH", "SH-Hbk/SH-Hbk-subareas.R", "SH-Hbk/SH-Hbk-subareas.shp", TRUE, FALSE,
  "SHMaui", "SH", "SH-Hectors/SP-Hec-Maui-subareas.R", "SH-Hectors/SP-Maui-subareas.shp", TRUE, FALSE,
  "SHCircVar", "SH", "SH-Sei-HuDol-KiWa-SoBottlW/SH-Sei-HuDol-SoBottlW-KiWa-circumpolar.R", "SH-Sei-HuDol-KiWa-SoBottlW/SH-various-circumpolar-subareas.shp", TRUE, FALSE,
  "SHSpr", "SH", "SH-Spr/SH-Spr-subareas.R", "SH-Spr/SH-Spr-subareas.shp", TRUE, FALSE,
  "SHSrht", "SH", "SH-Srht/SH-Srht-subareas.R", "SH-Srht/SH-Srht-subareas.shp", TRUE, FALSE
)

# ---- 3. Workflow --------------------------------------------------------------
# Keep orchestration variables local so objects created by construction scripts
# do not overwrite the registry or workflow settings during a rebuild.
combine_subareas <- function(files, rebuild = FALSE, rebuild_ids = NULL,
                             output_dir = "combine/output", write_app = TRUE,
                             app_dir = "../Extras/abundances-viewer/view-abundances-whales",
                             target_crs = 4326, make_maps = FALSE) {
  for (pkg in c("sf", "dplyr")) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      stop("Install the required package: ", pkg, call. = FALSE)
    }
  }
  require_files <- function(paths, label) {
    missing <- paths[!file.exists(paths)]
    if (length(missing)) {
      stop(label, " missing (check the working directory and filename case):\n",
           paste(missing, collapse = "\n"), call. = FALSE)
    }
  }

  # ---- 3a. Optional construction ----------------------------------------------
  if (rebuild) {
    if (is.null(rebuild_ids)) {
      selected <- files[files$rebuild_enabled, ]
    } else {
      unknown <- setdiff(rebuild_ids, files$id)
      if (length(unknown)) stop("Unknown rebuild_ids: ", paste(unknown, collapse = ", "))
      selected <- files[files$id %in% rebuild_ids, ]
    }
    if (nrow(selected)) {
      require_files(c("set up and functions.R", selected$script), "Construction scripts")
      # Use the global environment, as in the original workflow, because the
      # existing scripts may rely on shared functions and reference datasets.
      # Restore the working directory even if a child script changes it/errors.
      project_dir <- getwd()
      source_from_project <- function(path) {
        on.exit(setwd(project_dir), add = TRUE)
        setwd(project_dir)
        source(path, local = .GlobalEnv)
      }
      source_from_project("set up and functions.R")
      for (script in unique(selected$script)) {
        message("Building: ", script)
        source_from_project(script)
      }
    }
  } else {
    message("Using existing subarea shapefiles; construction scripts skipped.")
  }

  # ---- 3b. Read and combine ---------------------------------------------------
  inputs <- files[files$include, ]
  # Check all regions before writing anything. A shapefile also needs its
  # companion files; st_read() will report unreadable/incomplete datasets.
  require_files(inputs$shapefile, "Input shapefiles")
  read_subarea <- function(path) {
    x <- sf::st_read(path, quiet = TRUE)
    if (is.na(sf::st_crs(x))) x <- sf::st_set_crs(x, target_crs)
    # Use one CRS for ALL regions.
    if (sf::st_crs(x) != sf::st_crs(target_crs)) x <- sf::st_transform(x, target_crs)
    # Normalise the active geometry-column name before binding different files.
    geom_col <- attr(x, "sf_column")
    if (geom_col != "geometry") {
      if ("geometry" %in% names(x)) stop("Conflicting geometry column in: ", path)
      names(x)[names(x) == geom_col] <- "geometry"
      sf::st_geometry(x) <- "geometry"
    }
    x
  }
  regions <- setNames(lapply(c("NA", "NP", "SH"), function(region) {
    paths <- inputs$shapefile[inputs$region == region]
    message("Combining ", region, ": ", length(paths), " shapefiles")
    dplyr::bind_rows(lapply(paths, read_subarea))
  }), c("NA", "NP", "SH"))

  # Preserve the original Pacific longitude shift for Pacific-centred mapping.
  # This also remains in AllSubAreas, matching the original workflow; it is
  # not a globally standardised -180..180 longitude product.
  regions$NP <- sf::st_shift_longitude(regions$NP)
  # bind_rows also accommodates fields that occur in only some regions (NA
  # values fill missing fields). Incompatible field types still raise an error.
  combined <- dplyr::bind_rows(regions$SH, regions$NP, regions$`NA`)

  # ---- 3c. Write combined products --------------------------------------------
  # Repeated runs replace these output layers, never the source shapefiles.
  write_layer <- function(x, path) {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    sf::st_write(x, path, delete_layer = TRUE, quiet = TRUE)
    message("Written: ", path)
  }
  for (region in names(regions)) {
    filename <- paste0(region, "-subareas.shp")
    write_layer(regions[[region]], file.path(output_dir, filename))
    if (write_app) write_layer(regions[[region]], file.path(app_dir, filename))
  }
  write_layer(combined, file.path(output_dir, "subareas.shp"))

  # Optional plots avoid loading setup/reference layers during combine-only use.
  # Replaces the undefined mappings() call and automatic View() windows.
  if (make_maps) {
    for (region in names(regions)) {
      plot(sf::st_geometry(regions[[region]]), main = region)
    }
  }
  list(`NA` = regions$`NA`, NP = regions$NP, SH = regions$SH, all = combined)
}

# ---- 4. Run and retain the familiar output-object names -----------------------
combined_subareas <- combine_subareas(
  files = subarea_files,
  rebuild = rebuild_subareas,
  rebuild_ids = rebuild_ids,
  output_dir = output_dir,
  write_app = write_app_copies,
  app_dir = app_dir,
  target_crs = target_crs,
  make_maps = make_maps
)
NorthAtlanticSubs <- combined_subareas$`NA`
NorthPacificSubs <- combined_subareas$NP
SouthernHemisphereSubs <- combined_subareas$SH
allsubareas <- combined_subareas$`all`
