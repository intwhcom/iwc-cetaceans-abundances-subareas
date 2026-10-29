#### North Atlantic Fin Whales ####
#~~~~~~~assessment subareas~~~~~~~#
						
source("set up and functions.R")

#### 'basic' assessment subareas
g1 = c(
    "POLYGON ((-97 80, -44 53.5, -44 80, -97 80))",
    "POLYGON ((-97 80, -100 80, -100 34.4, -44 34.4, -44 53.5, -97 80))",
    "POLYGON ((-44 80, -44 34.4, -30 34.4, -30 60, -31 60, -31 65, -27 67, -27 80, -44 80))",
    "POLYGON ((-27 75, -27 67, -31 65, -31 60, -30 60, -30 50, -18 50, -18 75, -27 75))",
    "POLYGON ((-30 50, -30 34.4, 25 34.4, 25 52, -18 52, -18 50, -30 50))",
    "POLYGON ((-25 80, -25 75, -18 75, -18 52, -1 52, -5 58.5, 0 61.5, 0 80, -25 80))",
    "POLYGON ((0 80, 0 61.5, -5 58.5, -1 52, 53 52, 53 80, 0 80))"
  )
sa = c('WG','EC','EG','WI','Sp','EIF','N')
						  
subs1 <- wktfunction(GEOM = g1, Subareas = sa)

#clip the polygons with the oceans  
output = st_intersection(subs1, ne_10m_ocean) %>% select(subareas,geometry)
mappingf(output)

#save 
st_write(output, "NA-Fin/assessment-subareas/NA-Fin-assessment-subareas.shp", append = F)
