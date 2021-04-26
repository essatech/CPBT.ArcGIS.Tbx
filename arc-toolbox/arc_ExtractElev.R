tool_exec <- function(in_params, out_params) {
  
  
  
  # Load package
print("Loading library...")
library(MNAI.CPBT)

# Get input and output parameters
print("Loading Spatial...")
getpath = in_params$cross_shore_profiles
importGeom = arc.open(getpath)
arcgeom = arc.select(importGeom)
cross_shore_profiles =  arc.data2sf(arcgeom)

  
# Open raster
print("Open Raster...")
TopoBathy = in_params$TopoBathy
rr <- arc.open(TopoBathy)
arcraster <- arc.raster(rr)
TopoBathy <- as.raster(arcraster)

  
  
SmoothParameter <- in_params$SmoothParameter

print("Running func...")
pt_elevs <- MNAI.CPBT::ExtractElev(cross_shore_profiles = cross_shore_profiles, TopoBathy = TopoBathy)

point_elev <- MNAI.CPBT::SignalSmooth(point_elev = pt_elevs, SmoothParameter = SmoothParameter)

  
print("Completed SignalSmooth()...")

# Save outputs
point_elev_path <- out_params$point_elev_path
print("Writting output ...")
print(point_elev_path)

arc.write(point_elev_path, point_elev, overwrite = TRUE)

print("Function Completed...")

return(out_params)
  

}