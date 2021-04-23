tool_exec <- function(in_params, out_params) {
  
  # library(arcgisbinding)
  # arc.check_product()
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  print("get inputs")
  
  
  # Open raster
  r_d_veg     <- in_params$r_d_veg
  rr <- arc.open(r_d_veg)
  arcraster <- arc.raster(rr)
  r_d_veg <- as.raster(arcraster)
  
  
  r_d_noveg     <- in_params$r_d_noveg
  rr <- arc.open(r_d_noveg)
  arcraster <- arc.raster(rr)
  r_d_noveg <- as.raster(arcraster)
  
  
  print("get buildings")
  
  
  bld       <- in_params$bld
  importGeom = arc.open(bld)
  arcgeom = arc.select(importGeom)
  bld =  arc.data2sf(arcgeom)
  
  
  print("running DepthDamageFlood")
  
  
  # Calculate depth damage with flood
  dd_flood <- func_DepthDamageFlood(bld = bld, r_d_noveg = r_d_noveg, r_d_veg = r_d_veg)
  
  print("prepping outputs")
  
  
  # Save outputs
  dd_flood_path <- out_params$dd_flood_path
  print("Writting output ...")
  print(dd_flood_path)
  
  
  arc.write(dd_flood_path, dd_flood, overwrite = TRUE)
  
  
  return(out_params)
  
  
  
  
}