tool_exec <- function(in_params, out_params) {
  # library(arcgisbinding)
  # arc.check_product()
  
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  
  # Get inputs 
  perp_lines      <- in_params$perp_lines
  PointResolution <- 1
  bathytopo_r     <- in_params$bathytopo_r
  SmoothParameter <- in_params$SmoothParameter
  
  # Open raster
  rr <- arc.open(bathytopo_r)
  arcraster <- arc.raster(rr)
  r_bathytopo <- as.raster(arcraster)

  
  # Open lines
  importGeom = arc.open(perp_lines)
  # Select
  arcgeom = arc.select(importGeom)
  # Convert format
  perp_lines =  arc.data2sf(arcgeom)
  
 
  
  point_elev <- ExtractElev(
    perp_lines = perp_lines,
    PointResolution = PointResolution,
    path_bathytopo = NA,
    r_bathytopo = r_bathytopo
  )
  
  print("Completed ExtractElev()...")
  
  # Smooth signal by percentage - SignalSmooth.smooth
  point_elev$elev_smooth <- SignalSmooth(
    point_elev = point_elev,
    SmoothParameter = SmoothParameter
  )
  
  print("Completed SignalSmooth()...")
  
  # Save outputs
  point_elev_path <- out_params$point_elev_path
  print("Writting output ...")
  print(point_elev_path)
  
  arc.write(point_elev_path, point_elev, overwrite = TRUE)

  print("Function Completed...")
  
  return(out_params)







  return(out_params)
}