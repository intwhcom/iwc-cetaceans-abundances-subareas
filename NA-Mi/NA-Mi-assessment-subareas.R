#### North Atlantic minke Whales ####
#~~~~~~~~~assessment subareas~~~~~~~#
source("set up and functions.R")

#WG, WC, CG, CIP, CIC, CM, ESW, ESE, EB, EW, EN
# 
g1 = c(
  "POLYGON ((-77.744595 80,-77.744595 76.711549,-59 69,-59 61,-42 52.33333,-42 59,-43.9 59,-43.9 80,-77.744595 80))",
  "POLYGON ((-77.744595 80,-77.744595 76.711549,-59 69,-59 61,-42 52.33333,-42 38.67,-120 38.67,-120 80,-77.744595 80))",
  "POLYGON ((-43.9 80,-25 74 ,-15 74,-25 67.5,-42 60,-42 59,-43.9 59,-43.9 80))",
  "POLYGON ((-25 67.5,-25 63,-12 63 ,-18 60,-18 38.67,-42 38.67,-42 60,-25 67.5))",
  "POLYGON ((-25 67.5,-12 67.5,-12 63,-25 63,-25 67.5))",
  "POLYGON ((-25 67.5,-12 67.5,-12 63,3 68,3 74,-15 74,-25 67.5))",
  "POLYGON ((-25 74,-25 80,9 80,9 77,3 74,-25 74))",
  "POLYGON ((9 80,9 77,3 74,3 73,28 73,28 80,9 80))",
  "POLYGON ((28 80,28 70,28 65,50 65,50 80,28 80))",
  "POLYGON ((3 73,28 73,28 70,10 62,-14 62,-12 63,3 68,3 73))",
  "POLYGON ((-18 38.67,-18 60,-14 62,10 62,28 70,40 57.5,-0.33 44.6,-4 40, -5 38.67,-18 38.67))"
)
sa = c('WG','WC','CG','CIP','CIC','CM','ESW','ESE','EB','EW', 'EN')
subs1 <- wktfunction(GEOM = g1, Subareas = sa)
					
#clip the polygons with the world 
output = st_intersection(subs1, ne_10m_ocean) %>% select(subareas,geometry)
mappingf(output)

#save 
write_sf(output, "NA-Mi/assessment-subareas/NA-Mi-assessment-subareas.shp")
