# IWC cetacean abundance subareas

This repository is a **companion repository to the IWC Cetacean Abundance Database**. It documents how the spatial polygons associated with abundance estimates in the IWC abundance tables were identified, reconstructed and processed.

The main IWC abundance database and associated data-processing workflow are maintained in the [IWC Cetacean Abundances Database repository](https://github.com/intwhcom/iwc-cetaceans-abundances-database/tree/main).

Many abundance estimates refer to a particular survey area, survey stratum, assessment area or combination of subareas. These spatial definitions are not always available as ready-to-use digital polygons. Depending on the estimate, the corresponding spatial area may therefore have been obtained from an existing shapefile, supplied directly by researchers or organisations, reconstructed from published coordinates, or digitised from maps and figures in scientific publications and IWC Scientific Committee documents.

This repository provides the **spatial provenance and processing workflow** for those areas. It contains the source and intermediate spatial information, where appropriate and where redistribution is permitted, together with the R scripts used to prepare the polygons associated with individual abundance estimates.

The principal output of this workflow is the **subareas spatial reference dataset**, which links the spatial polygons to the corresponding subarea, species and survey information used in the IWC abundance tables. This reference dataset forms part of the wider **IWC Cetacean Abundance data product** distributed through the main repository.

## Repository organisation

The repository is organised primarily by **large geographic area and species**. Folder names use the following regional prefixes:

- `NA` — North Atlantic
- `NP` — North Pacific
- `SH` — Southern Hemisphere

The regional prefix is followed by the species code used in the IWC abundance database. For example:

```text
NA-Fin     North Atlantic fin whale
NA-Hbk     North Atlantic humpback whale
NP-Mi      North Pacific minke whale
NP-Hbk     North Pacific humpback whale
SH-Fin     Southern Hemisphere fin whale
SH-Blu     Southern Hemisphere blue whale
```

Within each species folder, the R script documents how the spatial areas required for that species and region were constructed. Depending on the source of the spatial information, the folder may also contain project-created polygons, georeferenced material, assessment-area files, or spatial data supplied directly by researchers or organisations.

Additional folders contain spatial information used across several species or surveys, as well as scripts for combining the individual species-level outputs into the final subareas reference dataset.

The purpose of this repository is therefore not to provide a general distribution map for each cetacean species, but to document and reproduce the **specific spatial areas associated with abundance estimates included in the IWC Cetacean Abundance Database**.

---

## Third-party data 
Several scripts depend on spatial datasets produced by third parties.

Except for the GBIF occurrence download described below, third-party datasets are not distributed with this repository. Users who wish to rerun the scripts should download the required datasets from the original providers and place them in a local thirdpartydata folder alongside the repository.

This approach avoids redistributing third-party data, respects provider terms and licences, and makes the provenance of all external spatial inputs explicit.
## Recommended folder structure

The scripts should be run from the root of the repository. The expected layout is:

```
workspace/
├── parent_directory/
│   └── iwc-cetaceans-abundances-subareas/
│       ├── README.md
│       ├── set up and functions.R
│       ├── NA-NArht/
│       │   └── from_GBIF/
│       │       ├── 0058701-241126133413365.csv
│       │       ├── 0058701-241126133413365.txt
│       │       └── README.txt
│       └── ...
│
└── thirdpartydata/
    ├── NaturalEarth/
    │   ├── land/
    │   └── oceans/
    ├── marineregions/
    │   ├── Global Oceans and Seas/
    │   ├── IHO Sea Areas/
    │   └── World EEZ v12/
    ├── EEZ_land_union_v3_202003/
    ├── FAO/
    │   └── FAO Fishing areas/
    ├── NOAA/
    │   └── GOM-GB Regulated Mesh Areas/
    ├── large marine ecosystems/
    ├── IUCN/
    └── Maui_s_Dolphin-Annual_Distribution/
```

Paths in the R scripts should therefore use repository-relative paths such as:

```r
"../../thirdpartydata/NaturalEarth/oceans/ne_10m_ocean.shp"
```

Some early development scripts may still contain absolute Windows paths from the original working environment. These should be replaced by the equivalent relative path shown in this README before rerunning the workflow.

---

# Required third-party datasets

## 1. Natural Earth — 1:10m land polygons

**Provider:** Natural Earth  
**Dataset:** 1:10m Physical Vectors — Land  
**Version used in this project:** 5.0.0  
**Expected file:** `ne_10m_land.shp`

Place the downloaded shapefile components in:

```text
../../thirdpartydata/NaturalEarth/land/
```

The script expects:

```text
../../thirdpartydata/NaturalEarth/land/ne_10m_land.shp
```

Source:

https://www.naturalearthdata.com/downloads/10m-physical-vectors/10m-land/

Natural Earth release archive:

https://github.com/nvkelso/natural-earth-vector/releases/tag/v5.0.0

The project used version 5.0.0. The Natural Earth website may now offer a newer version, so users attempting an exact reconstruction should use the archived v5.0.0 release where possible.

Natural Earth data are public domain.

---

## 2. Natural Earth — 1:10m ocean polygons

**Provider:** Natural Earth  
**Dataset:** 1:10m Physical Vectors — Ocean  
**Version used in this project:** 5.1.1  
**Expected file:** `ne_10m_ocean.shp`

Place the downloaded shapefile components in:

```text
../../thirdpartydata/NaturalEarth/oceans/
```

The script expects:

```text
../../thirdpartydata/NaturalEarth/oceans/ne_10m_ocean.shp
```

Source:

https://www.naturalearthdata.com/downloads/10m-physical-vectors/10m-ocean/

Natural Earth data are public domain.

---

## 3. Marine Regions — Global Oceans and Seas

**Provider:** Flanders Marine Institute (VLIZ), Marine Regions  
**Dataset:** Global Oceans and Seas  
**Version used:** version 1 (`goas_v01`)  
**Expected file:** `goas_v01.shp`

Place the shapefile components in:

```text
../../thirdpartydata/marineregions/Global Oceans and Seas/
```

The script expects:

```text
../../thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp
```

Download:

https://www.marineregions.org/downloads.php

Citation:

> Flanders Marine Institute (2021). Global Oceans and Seas, version 1. Available online at https://www.marineregions.org/. https://doi.org/10.14284/542.

Licence: CC BY 4.0.

Marine Regions requests that users do not redistribute copies of its products and instead direct users to MarineRegions.org. The raw dataset is therefore not included in this repository.

---

## 4. Marine Regions — IHO Sea Areas

**Provider:** Flanders Marine Institute (VLIZ), Marine Regions  
**Dataset:** IHO Sea Areas  
**Primary version used:** version 3  
**Expected file:** `World_Seas_IHO_v3.shp`

Place the shapefile components in:

```text
../../thirdpartydata/marineregions/IHO Sea Areas/
```

Suggested path:

```text
../../thirdpartydata/marineregions/IHO Sea Areas/World_Seas_IHO_v3.shp
```

Download:

https://www.marineregions.org/downloads.php

Citation:

> Flanders Marine Institute (2018). IHO Sea Areas, version 3. Available online at https://www.marineregions.org/. https://doi.org/10.14284/323.

Licence: CC BY-NC-SA 4.0.

One older/legacy workflow uses IHO Sea Areas version 2. If that script is to be rerun, version 2 can also be downloaded from the Marine Regions downloads page and placed in the same folder.

Marine Regions requests that users do not redistribute copies of its products. Neither version is included in this repository.

---

## 5. Marine Regions — World Exclusive Economic Zones

**Provider:** Flanders Marine Institute (VLIZ), Marine Regions  
**Dataset:** Maritime Boundaries and Exclusive Economic Zones (200 NM)  
**Version used:** version 12  
**Expected file:** `eez_v12.shp`

Place the shapefile components in:

```text
../../thirdpartydata/marineregions/World EEZ v12/
```

Suggested path:

```text
../../thirdpartydata/marineregions/World EEZ v12/eez_v12.shp
```

Download:

https://www.marineregions.org/downloads.php

Citation:

> Flanders Marine Institute (2023). Maritime Boundaries Geodatabase: Maritime Boundaries and Exclusive Economic Zones (200NM), version 12. Available online at https://www.marineregions.org/. https://doi.org/10.14284/632.

Licence: CC BY 4.0.

The raw dataset is not redistributed in this repository.

---

## 6. Marine Regions — union of land and EEZ polygons

**Provider:** Flanders Marine Institute (VLIZ), Marine Regions  
**Dataset:** Union of the ESRI Country shapefile and the Exclusive Economic Zones  
**Version used:** version 3 (2020)  
**Expected file:** `EEZ_Land_v3_202030.shp`

Place the shapefile components in:

```text
../../thirdpartydata/EEZ_land_union_v3_202003/
```

The script expects:

```text
../../thirdpartydata/EEZ_land_union_v3_202003/EEZ_Land_v3_202030.shp
```

Download:

https://www.marineregions.org/downloads.php

Citation:

> Flanders Marine Institute (2020). Union of the ESRI Country shapefile and the Exclusive Economic Zones (version 3). Available online at https://www.marineregions.org/. https://doi.org/10.14284/403.

The metadata accompanying the version used in this project describes the layer as a union of the ESRI world country data and Marine Regions EEZ version 11.

The raw dataset is not redistributed in this repository.

---

## 7. FAO — CWP major fishing areas

**Provider:** Food and Agriculture Organization of the United Nations (FAO)  
**Dataset:** CWP/FAO fishing areas  
**Expected file:** `FAO_AREAS_CWP.shp`

Place the shapefile components in:

```text
../../thirdpartydata/FAO/FAO Fishing areas/
```

The script expects:

```text
../../thirdpartydata/FAO/FAO Fishing areas/FAO_AREAS_CWP.shp
```

Source catalogue record:

https://data.apps.fao.org/map/catalog/srv/eng/catalog.search#/metadata/ac02a460-da52-11dc-9d70-0017f293bd28

Accessed for this project: **7 March 2022**.

The FAO source dataset is not redistributed in this repository. Users should obtain it directly from FAO.

---

## 8. NOAA Fisheries — Gulf of Maine–Georges Bank Regulated Mesh Areas

**Provider:** NOAA Fisheries, National Marine Fisheries Service, Greater Atlantic Regional Fisheries Office (GARFO)  
**Dataset:** Gulf of Maine–Georges Bank Regulated Mesh Areas  
**Expected file:** `GOM-GB_Regulated_Mesh_Areas.shp`

Place the shapefile components in:

```text
../../thirdpartydata/NOAA/GOM-GB Regulated Mesh Areas/
```

Suggested path:

```text
../../thirdpartydata/NOAA/GOM-GB Regulated Mesh Areas/GOM-GB_Regulated_Mesh_Areas.shp
```

Current NOAA resource page:

https://www.fisheries.noaa.gov/resource/map/gulf-maine-georges-bank-regulated-mesh-areas

Citation for the version used in this project:

> NOAA Fisheries Service. NMFS Regulated Areas in Northeast and Mid-Atlantic Waters. GOM-GB Regulated Mesh Areas [Shapefile]. Gloucester, MA: National Oceanic and Atmospheric Administration (NOAA), National Marine Fisheries Service (NMFS), Greater Atlantic Regional Fisheries Office (GARFO) [producer], 15 March 2015.

The NOAA metadata states that government-server information is public domain unless specifically annotated otherwise and requests appropriate attribution. The layer is a GIS representation and is not the legal definition of the regulated areas.

The raw dataset is not included in this repository; users should download it directly from NOAA.


The folder `NA-Fin/from_GOM-GB_Regulated_Mesh_Areas/` contains **project-created polygons developed for the North Atlantic fin whale workflow using the NOAA Gulf of Maine–Georges Bank Regulated Mesh Areas as a spatial basis**. These files are **not copies of the original NOAA raw dataset**. They are derived spatial products created within this project from the NOAA source layer and are retained to document the construction of the relevant abundance subareas.

---

## 9. NOAA / US Large Marine Ecosystem Program — Large Marine Ecosystems

**Provider:** US Large Marine Ecosystem Program / NOAA Fisheries  
**Dataset:** Global Large Marine Ecosystems  
**Expected file:** `LME66.shp`

Place the shapefile components in:

```text
../../thirdpartydata/large marine ecosystems/
```

The script expects:

```text
../../thirdpartydata/large marine ecosystems/LME66.shp
```

A downloadable copy of the dataset used in the workflow is available from:

https://github.com/datasets/lme-large-marine-ecosystems/blob/main/polygons/shp/lme66.zip

The data were originally distributed through the NOAA Large Marine Ecosystem Program. The supplied metadata identifies the source as the US LME Program and requests citation of the US LME Program.

The GitHub location above should be treated as a download mirror rather than the primary scientific attribution.

The raw dataset is not included in this repository.

---

## 10. IUCN Red List — marine mammal distribution polygons

**Provider:** International Union for Conservation of Nature (IUCN)  
**Dataset:** IUCN Red List spatial data — marine mammals  
**Version used:** spatial-data version 6.3  
**Expected file:** `MAMMALS_MARINE_ONLY.shp`  
**Downloaded:** May 2026

Place the downloaded shapefile components in:

```text
../../thirdpartydata/IUCN/
```

Suggested path:

```text
../../thirdpartydata/IUCN/MAMMALS_MARINE_ONLY.shp
```

Download page:

https://www.iucnredlist.org/resources/spatial-data-download

Dataset-level citation:

> IUCN. The IUCN Red List of Threatened Species. Spatial data version 6.3. https://www.iucnredlist.org. Downloaded May 2026.

Where individual species maps are used, users should also retain the species-specific citation information contained in the IUCN attribute data.

**Important:** IUCN's spatial-data terms restrict reposting and redistribution of the original spatial datasets without permission. For this reason, the IUCN shapefile is not included in this repository and must be obtained directly from IUCN by each user.

---

## 11. New Zealand — Māui dolphin annual distribution

**Provider / custodian:** New Zealand Ministry for Primary Industries  
**Creator:** National Institute of Water and Atmospheric Research (NIWA)  
**Dataset:** *Maui's Dolphin (North Island Hector's Dolphin) - Annual Distribution*  
**Creation date:** 16 October 2006  
**Publication date:** 9 November 2006  
**Contributors identified in the metadata:** Rochelle Constantine (University of Auckland) and Elisabeth Slooten (University of Otago)  
**Expected file:** `Maui_s_Dolphin_(North_Island_Hector_s_Dolphin)_-_Annual_Distribution.shp`

Place the shapefile components in:

```text
../../thirdpartydata/Maui_s_Dolphin-Annual_Distribution/
```

The script expects:

```text
../../thirdpartydata/Maui_s_Dolphin-Annual_Distribution/Maui_s_Dolphin_(North_Island_Hector_s_Dolphin)_-_Annual_Distribution.shp
```

The dataset metadata describes the distribution as a scientific interpretation based on published and unpublished sources and identifies the Ministry for Primary Industries as publisher/custodian.

The metadata also states **Crown Copyright Reserved**. The raw shapefile is therefore not redistributed in this repository.

Users should obtain the layer from the New Zealand government fisheries/NABIS spatial-data resources or the current successor service. If the historical download link changes, the dataset title above should be used to locate the same layer.

---

# GBIF occurrence data used for North Atlantic right whale polygons

The GBIF data are handled differently from the datasets above.

The exact GBIF occurrence download used during construction of the North Atlantic right whale polygons is retained in the repository at:

```text
NA-NArht/from_GBIF/
```

Files:

```text
NA-NArht/from_GBIF/0058701-241126133413365.csv
NA-NArht/from_GBIF/0058701-241126133413365.txt
NA-NArht/from_GBIF/README.txt
```

Citation:

> GBIF.org (06 January 2025). GBIF Occurrence Download. https://doi.org/10.15468/dl.unpxra.

The occurrence records were plotted and used as **spatial guidance for manual delineation** of the North Atlantic right whale polygons (`nwAtl` and `neAtl`). The polygons were drawn manually; they were **not generated algorithmically from the GBIF points**.

The GBIF files are retained so that the exact occurrence dataset used during the manual delineation is documented alongside the resulting project-created polygons. Record-level GBIF identifiers, source datasets and licences are retained in the original download.

Users reusing the occurrence data should cite the GBIF download DOI above and comply with the licences attached to the underlying occurrence records.

---
 
## Data supplied directly by researchers or organisations

Several spatial inputs used in this repository were provided directly by organisations, researchers, authors or collaborators rather than downloaded from public data portals. These files are treated separately from the datasets listed under `thirdpartydata`.

For each case, the repository records the provider, the scientific context in which the spatial information was produced, the relevant publication or IWC Scientific Committee paper, and whether permission has been obtained to redistribute the original spatial files.

Where permission to redistribute has not yet been confirmed, the files will not be included in the public repository. The corresponding R scripts and documentation can nevertheless identify the source and explain how the files were used.

## NAMMCO Secretariat — NASS, TNASS and NILS survey blocks

**Provider:** North Atlantic Marine Mammal Commission (NAMMCO) Secretariat

**Spatial inputs include:**

- NASS survey blocks including `Blk87`, `Blk89`, `Blk95`, `Blk01`, `Blk07` and `Blk15`
- TNASS 2007 survey blocks
- NASS 2015 survey blocks and associated spatial files
- NILS survey blocks and associated spatial information where applicable

These files were provided through the NAMMCO Secretariat. NAMMCO compiled survey-block and survey-stratum information from spatial data supplied by the countries participating in and implementing the North Atlantic Sightings Surveys (NASS and TNASS) and associated Norwegian survey work.

The files are used in this repository to reconstruct survey areas associated with abundance estimates in the IWC abundance database. Depending on the analysis, individual blocks or strata are selected, combined, dissolved or otherwise processed to represent the spatial extent associated with a particular abundance estimate.

The original source files remain attributable to NAMMCO and to the national institutes responsible for the relevant survey effort.

**Redistribution status:** Permission has been granted to make these source spatial data publicly available, with credit to the relevant institutes. Where possible, individual survey blocks should be attributed to the institute responsible for the corresponding national survey effort:

- **Faroe Islands:** [Faroe Marine Research Institute](https://www.hav.fo/famri/)
- **Greenland (where applicable):** [Greenland Institute of Natural Resources](https://natur.gl/?lang=en)
- **Iceland:** [Marine and Freshwater Research Institute](https://www.hafogvatn.is/en)
- **Norway:** [Institute of Marine Research](https://www.hi.no/en)



---

## Norwegian Institute of Marine Research — NILS survey polygons

**Provider:** Norwegian Institute of Marine Research / Havforskningsinstituttet

**Provided by:** Deanna Marie Leonard

**Spatial inputs include:**

- `polygon-blocks-0207-wgs84.shp`
- `polygon_blocks_0813_refinedCopy.shp`
- related NILS survey-area files

These files were provided directly by Deanna Marie Leonard of the Norwegian Institute of Marine Research in response to a request for the spatial definitions of survey areas used in Norwegian minke whale abundance analyses.

The request specifically concerned the survey subareas described in the IWC Scientific Committee evaluation of the minke whale abundance estimates presented in Solvang et al. (2021), including differences in the ES subareas between the 2014 and 2019 survey periods and the area referred to as EW1–3.

Relevant scientific reference:

> Solvang, H.K., Skaug, H.J. and Øien, N.I. 2021. *Abundance of common minke whales in the Northeast Atlantic based on survey data collected over the period 2014–2019.* Paper SC/68C/ASI/04 presented to the IWC Scientific Committee, Virtual Meetings, April–May 2021. 12 pp. Unpublished paper available from the Office of the IWC.

The files are used to reconstruct NILS/Norwegian survey strata and associated abundance areas in the North Atlantic workflows.

**Redistribution status:** Permission has been requested from the Norwegian Institute of Marine Research to include the original files in the public repository. The files will not be made public until this permission is confirmed.

---

## D. Palka / IWC Scientific Committee — North Pacific humpback whale assessment areas

**Provider:** D. Palka, in the context of IWC Scientific Committee North Pacific humpback whale assessment work

**Spatial inputs include:**

- `NPhuwhRegions.6Dec2023.shp`
- `NPhuwhRegions.1Apr2024.shp`

These shapefiles define spatial regions used in the IWC Scientific Committee In-Depth Assessment of North Pacific humpback whales. They were provided directly as part of the assessment work and are used in this repository to represent the corresponding North Pacific humpback whale assessment areas.

The assessment regions and their scientific context are described in:

> Palka, D.C., Baker, S., Calambokidis, J., Cheeseman, T., Eichenberger, F., Donovan, G., Katara, I., Martinez-Loustalot, P., Mizoch, S., Palacios, D.M., Privitera-Johnson, K., Punt, A., Scordino, J., Steel, D., Urbán R., J., Wade, P. and Weinrich, M. 2024. *Updated data and assessment model for the North Pacific humpback whale.* Paper SC/69B/IA/04 presented to the IWC Scientific Committee, April–May 2024, Bled, Slovenia. 28 pp. Unpublished paper available from the Office of the IWC.

and:

> Punt, A.E., Wade, P.R. and Liu, O.R. 2026. *Updated specifications and results for the In Depth Assessment of North Pacific humpback whales.* Paper SC/70/IA/01 presented to the IWC Scientific Committee, April–May 2026, Bled, Slovenia. 42 pp. Unpublished paper available from the Office of the IWC.

**Redistribution status:** D. Palka has given permission for these files to be included in the public repository.

---

## Heide-Jørgensen — 2024 Greenland whale survey areas

**Provider:** Mads Peter Heide-Jørgensen

**Spatial inputs:**

- `West_all_together.shp`
- `East_all_together.shp`

These files were provided directly by Heide-Jørgensen through personal communication and describe the spatial survey areas used in the 2024 West and East Greenland whale survey.

The survey and associated abundance analyses are presented in:

> Heide-Jørgensen, M.P. 2025. *Analysis of a whale survey in West and East Greenland in 2024.* Paper SC/S25/ASG/01/Rev2 presented to the IWC Scientific Committee, September 2025. Unpublished paper available from the Office of the IWC.

The shapefiles are used in the North Atlantic fin whale workflow and associated survey-area reconstructions.

**Redistribution status:** Heide-Jørgensen has given permission for these spatial files to be included in the public repository.

---

## Martin Biuw / CCAMLR-IWC survey strata — Scotia Sea fin whale survey areas

**Provider:** Martin Biuw

**Spatial input:**

- `SH-Fin/input_provided_by_researchers/MB1/survey_strata2.shp`

The shapefile was provided directly by Martin Biuw through personal communication. The spatial strata originate from CCAMLR krill survey work and have been used in analyses of whale distribution and abundance in the Scotia Sea.

The relevant studies include:

> Hedley, S., Reilly, S., Borberg, J., Holland, R., Hewitt, R., Watkins, J., Naganobu, M. and Sushin, V. 2001. *Modelling whale distribution: a preliminary analysis of data collected on the CCAMLR-IWC Krill Synoptic Survey, 2000.* Paper SC/53/E9 presented to the IWC Scientific Committee, 2001. 39 pp.

and:

> Biuw, M., Lindstrøm, U., Jackson, J.A., Baines, M., Kelly, N., McCallum, G., Skaret, G. and Krafft, B.A. 2024. *Estimated summer abundance and krill consumption of fin whales throughout the Scotia Sea during the 2018/2019 summer season.* https://doi.org/10.21203/rs.3.rs-3959755/v1.

The shapefile is used in this repository to represent the corresponding Southern Hemisphere fin whale survey strata.

**Redistribution status:** Martin Biuw indicated that the shapefile originates from CCAMLR krill surveys. Permission for redistribution was given.

---

## Herr / Viquerat and collaborators — Antarctic Peninsula and Scotia Sea survey areas

**Provider:** Helena Herr and collaborators

**Spatial input:**

- `SurveyAreas_ViqueratHerr_WGS84.shp`

This shapefile was provided directly by Helena Herr and contains survey areas used across several whale abundance and distribution studies in the Antarctic Peninsula and Scotia Sea region.

The relevant studies include:

> Herr, H., Viquerat, S., Siegel, V., Kock, K.H., Dorschel, B., Huneke, W.G., Bracher, A., Schröder, M. and Gutt, J. 2016. *Horizontal niche partitioning of humpback and fin whales around the West Antarctic Peninsula: evidence from a concurrent whale and krill survey.* Polar Biology 39: 799–818. https://doi.org/10.1007/s00300-016-1927-9.

> Viquerat, S. and Herr, H. 2017. *Mid-summer abundance estimates of fin whales Balaenoptera physalus around the South Orkney Islands and Elephant Island.* Endangered Species Research 32: 515–524. https://doi.org/10.3354/esr00832.

> Herr, H., Viquerat, S., Devas, F., Lees, A., Wells, L., Gregory, B., Giffords, T., Beecham, D. and Meyer, B. 2022. *Return of large fin whale feeding aggregations to historical whaling grounds in the Southern Ocean.* Scientific Reports 12: 9458. https://doi.org/10.1038/s41598-022-13798-7.

> Viquerat, S., Waluda, C.M., Kennedy, A.S., Jackson, J.A., Hevia, M., Carroll, E.L., Buss, D.L., Burkhardt, E., Thain, S., Smith, P., Secchi, E.R., Santora, J.A., Reiss, C., Lindstrøm, U., Krafft, B.A., Gittins, G., Dalla Rosa, L., Biuw, M. and Herr, H. 2022. *Identifying seasonal distribution patterns of fin whales across the Scotia Sea and the Antarctic Peninsula region using a novel approach combining habitat suitability models and ensemble learning methods.* Frontiers in Marine Science 9: 1040512. https://doi.org/10.3389/fmars.2022.1040512.

Herr also identified publicly archived survey datasets associated with several of these studies:

- Herr et al. (2016): https://doi.org/10.1594/PANGAEA.894914
- Viquerat & Herr (2017): https://doi.org/10.1594/PANGAEA.955067
- Herr et al. (2022): https://doi.org/10.1594/PANGAEA.955068

The shapefile is used in this repository to reconstruct the relevant Southern Hemisphere fin whale survey areas.

**Redistribution status:** Helena Herr has given permission for `SurveyAreas_ViqueratHerr_WGS84.shp` to be included in the public repository.

---

## Williams et al. (2006) — Antarctic survey region

**Provider:** Nat Kelly

**Spatial input:**

- `Williams_et_al_2006_survey_region.shp`

This shapefile was provided directly by Nat Kelly through personal communication and corresponds to the survey region analysed in:

> Williams, R., Hedley, S.L. and Hammond, P.S. 2006. *Modeling distribution and abundance of Antarctic baleen whales using ships of opportunity.* Ecology and Society 11(1): 1. http://www.ecologyandsociety.org/vol11/iss1/art1/.

The shapefile is used in this repository to reconstruct the Southern Hemisphere survey region associated with the abundance analysis.

**Redistribution status:** Permission to redistribute the original spatial data has **not yet been obtained**. The original shapefile should therefore **not be included in the public repository** unless and until permission is confirmed. The workflow and documentation may still identify the source and describe how the spatial information was used.


---

## Repository treatment of directly supplied files

Files in this section should be handled according to their redistribution status:

- files for which explicit permission has been obtained may be included in the public repository together with their provenance and citation information;
- files for which permission is still pending should remain outside the public repository until permission is confirmed;
- the R scripts should retain clear references to the original provider and scientific source irrespective of whether the underlying file can be redistributed;
- inclusion of a supplied shapefile in this repository does not transfer ownership of the original data or geometry to the repository authors.

Where possible, the relevant publication, IWC Scientific Committee paper, data DOI or personal communication should be recorded so that users can understand the scientific context in which each spatial layer was produced.

The repository does not claim ownership of any third-party dataset. All third-party data remain subject to the licences, terms of use and citation requirements of their original providers.


Users who reuse **original source data supplied directly by researchers, institutes or organisations** should acknowledge both the original scientific source and the relevant data provider identified in this repository. As a matter of professional courtesy, users are also encouraged to contact the original data owners before reusing those source data and, where appropriate, to request permission. Any specific licence, attribution requirement or reuse condition associated with an original dataset takes precedence over this general guidance.

---

# Project-created and georeferenced spatial files

A substantial proportion of the spatial information in this repository was created within the project when an original digital polygon was not available. In these cases, survey areas, assessment areas or other spatial boundaries were reconstructed from maps, figures, coordinates or descriptions published in scientific papers, IWC Scientific Committee documents and other source material.

Folders named `georeferenced` contain the files associated with this reconstruction process. They include both the **final project-created polygons** and the **intermediate files used to produce them**. Depending on the workflow, these folders may contain:

- the original map or figure used as the spatial source (`.png`, `.jpg` or similar);
- QGIS georeferencing control-point files (`.points`);
- georeferenced raster images (`.tif`);
- auxiliary georeferencing or raster metadata files;
- intermediate polygon shapefiles created during digitisation or spatial editing;
- the final polygon shapefile used by the R workflow; and
- QGIS project or metadata files where these were retained as part of the processing record.

The general workflow was to obtain a map or figure showing the relevant survey or assessment area, georeference that image to an appropriate geographic coordinate system, and manually digitise the required boundaries. Where necessary, the resulting polygons were subsequently clipped to ocean boundaries, dissolved, combined or otherwise processed in R to obtain the spatial area corresponding to an abundance estimate.

These polygons should therefore be understood as **project-created spatial reconstructions derived from published or otherwise documented source material**, rather than as original spatial data supplied by the authors of the source publication.

Where the spatial boundary was reconstructed from a publication or IWC document, the relevant source should be cited in the corresponding R script and/or repository documentation. The repository retains the intermediate georeferencing material to provide transparency about how the polygon was constructed and to allow the reconstruction process to be inspected.

The accuracy of these reconstructed polygons varies according to the information available in the original source. Where a boundary could be reconstructed directly from clearly defined coordinates or well-defined mapped boundaries, it may be classified as `accurate`. Where the boundary had to be inferred from a published figure, schematic map or incomplete spatial description, it may be classified as `approximate`.

In some cases, polygons were drawn manually using other spatial information as guidance rather than reconstructed from a published map. These cases are documented separately in the relevant species folder or R script. The North Atlantic right whale polygons derived with reference to GBIF occurrence points are one example.

The inclusion of the georeferenced source image and intermediate processing files in the repository is intended to document the provenance and construction of the derived polygon. Copyright and reuse conditions associated with the original published figures or maps remain those of their respective sources.

---
### Optional app output

The `combine_subarea_shapefiles.R` script includes an optional step for copying the final spatial outputs to a separate abundance-viewer application directory. This functionality is intended for the IWC internal workflow and is disabled by default:

```r
write_app_copies <- FALSE
```

Users who maintain a local copy of the abundance-viewer application can enable this option and set `app_dir` to the appropriate local directory. It is not required to reproduce the spatial reference dataset produced by this repository.

---

## Quality-control and first-release disclaimer

This is the **first public version** of the spatial component of the IWC Cetacean Abundance data product. Extensive quality assurance and quality control (QA/QC) have been undertaken during data preparation, spatial reconstruction, validation and release, and every effort has been made to identify and correct errors and inconsistencies.

However, given the size, complexity and long history of the underlying abundance and spatial information, some issues may remain. Users are encouraged to report any errors, inconsistencies, missing provenance information or suggested corrections to **statistics@iwc.int**. Feedback will be used to improve future versions.

---
## Development and contributions

The spatial component of the IWC Cetacean Abundance Database and this repository were developed by **Isidora Katara, Head of Statistics and Modelling at the IWC Secretariat**. The work introduced a systematic spatial representation of the areas associated with abundance estimates in the IWC abundance tables.

This work would not have been possible without the support of the many researchers, authors, institutions, organisations and collaborators who contributed data, clarified survey or assessment areas, shared material, and gave permission for files to be included in this repository.

Special thanks are due to the **IWC Scientific Committee Sub-committee on Stock Abundance and Status (SAS), formerly ASI**, and to all its participants for their work and continued support of this initiative.
