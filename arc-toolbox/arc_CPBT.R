tool_exec <- function(in_params, out_params) {
  
# Load package
library(MNAI.CPBT)


#=========================================
# Load and sanitize all non-spatial inputs
#=========================================
simulation_name <- in_params$simulation_name
dir_output <- in_params$dir_output
print(dir_output)
dir_output <- gsub("\\\\", "/", dir_output)
print(dir_output)

ShorelinePointDist <- in_params$ShorelinePointDist
BufferDist <- in_params$BufferDist
RadLineDist <- in_params$RadLineDist
SmoothParameter <- in_params$SmoothParameter
MaxOnshoreDist <- in_params$MaxOnshoreDist
mean_high_water <- in_params$mean_high_water
mean_sea_level <- in_params$mean_sea_level
tide_during_storm <- in_params$tide_during_storm
surge_elevation <- in_params$surge_elevation
sea_level_rise <- in_params$sea_level_rise
Ho <- in_params$Ho
To <- in_params$To
storm_duration <- in_params$storm_duration
Tr <- in_params$Tr
PropValue <- in_params$PropValue
disc <- in_params$disc
TimeHoriz <- in_params$TimeHoriz


#=========================================
# Load and sanitize all spatial inputs
#=========================================

# Get input and output parameters
print("Loading Coastline...")
Coastline0 = in_params$Coastline
importGeom = arc.open(Coastline0)
arcgeom = arc.select(importGeom)
Coastline =  arc.data2sf(arcgeom)


print("Loading raster...")
TopoBathy0     <- in_params$TopoBathy
rr <- arc.open(TopoBathy0)
arcraster <- arc.raster(rr)
TopoBathy <- as.raster(arcraster)


trimline <- in_params$trimline
if(length(trimline) == 0){
  use_trimline = FALSE
  trimline = NA
  print("Not using trimline...")
} else {
  print("Using trimline...")
  importGeom = arc.open(trimline)
  arcgeom = arc.select(importGeom)
  trimline =  arc.data2sf(arcgeom)
  use_trimline = TRUE
  trimline = trimline
}


print("Loading BeachAttributes...")
BeachAttributes0 = in_params$BeachAttributes
importGeom = arc.open(BeachAttributes0)
arcgeom = arc.select(importGeom)
BeachAttributes =  arc.data2sf(arcgeom)

print("Loading Bldgs...")
Bldgs0 = in_params$Bldgs
importGeom = arc.open(Bldgs0)
arcgeom = arc.select(importGeom)
Bldgs0 =  arc.data2sf(arcgeom)
Bldgs = Bldgs0


Vegetation0 <- in_params$Vegetation
if(length(Vegetation0) == 0){
  Vegetation = NA
  print("No veg...")
} else {
  print("Using veg...")
  importGeom = arc.open(Vegetation0)
  arcgeom = arc.select(importGeom)
  Vegetation =  arc.data2sf(arcgeom)
  Vegetation = Vegetation
}



CPBT(
  simulation_name = simulation_name,
  dir_output = dir_output,
  Coastline = Coastline,
  ShorelinePointDist = ShorelinePointDist,
  BufferDist = BufferDist,
  RadLineDist = RadLineDist,
  TopoBathy = TopoBathy,
  SmoothParameter = SmoothParameter,
  MaxOnshoreDist = MaxOnshoreDist,
  trimline = NA,
  Vegetation = Vegetation,
  mean_high_water = mean_high_water,
  mean_sea_level = mean_sea_level,
  tide_during_storm = tide_during_storm,
  surge_elevation = surge_elevation,
  sea_level_rise = sea_level_rise,
  Ho = Ho,
  To = To,
  storm_duration = storm_duration,
  BeachAttributes = BeachAttributes,
  Tr = Tr,
  PropValue = PropValue,
  disc = disc,
  TimeHoriz = TimeHoriz,
  Bldgs = Bldgs,
  export_report = TRUE
)




print("Function Completed...")
  
  
return(out_params)
  
  
}