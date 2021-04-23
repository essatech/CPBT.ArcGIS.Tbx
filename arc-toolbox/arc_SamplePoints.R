tool_exec <- function(in_params, out_params) {
  
  # library(arcgisbinding)
  # arc.check_product()

  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")


  # Get input and output parameters
  shorelinefc = in_params$shorelinefc               # Shapefile of shoreline
  BufferDist = in_params$BufferDist                 # Buffer distance in meters for vertical line
  RadLineDist = in_params$RadLineDist               # Line dist in km
  ShorelinePointDist = in_params$ShorelinePointDist # where to sample points on shoreline
  
  
  # Open
  importGeom = arc.open(shorelinefc)
  # Select
  arcgeom = arc.select(importGeom)
  # Convert format
  shoreline_fc =  arc.data2sf(arcgeom)

 
    
  # Sample shoreline points and get perpendicular lines
  slp = SamplePoints(
      path_shoreline = NA, # shapefile of shoreline
      shoreline_fc = shoreline_fc,
      BufferDist = BufferDist, # Buffer distance in meters for vertical line
      RadLineDist = RadLineDist, # Line dist in km
      ShorelinePointDist = ShorelinePointDist # where to sample points on shoreline
  )
    
    
    
  perp_lines <- slp[[2]]
  shoreline_points <- slp[[1]]
    
    
  # Save outputs
  path_pts <- out_params$shoreline_points
  path_lines <- out_params$shoreline_lines
  
  arc.write(path_pts, shoreline_points, overwrite = TRUE)
  arc.write(path_lines, perp_lines, overwrite = TRUE)
  

  return(out_params)
}