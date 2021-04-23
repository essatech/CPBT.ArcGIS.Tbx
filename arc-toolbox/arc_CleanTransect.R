tool_exec <- function(in_params, out_params) {
  # library(arcgisbinding)
  # arc.check_product()
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  
  
  # Get inputs 
  point_elev      <- in_params$point_elev
  RadLineDist     <- in_params$RadLineDist
  MaxOnshoreDist  <- in_params$MaxOnshoreDist
  trimline        <- in_params$trimline
  
  
  # Open
  importGeom = arc.open(point_elev)
  arcgeom = arc.select(importGeom)
  point_elev =  arc.data2sf(arcgeom)
  
  
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
  

  
  
  #--------------------------------------------  
  # Clean and fix transects
  # need to make sure the direction is all the same ... need to exclude shallow islands 
  print("Running function...")
  
  pt_exp <- CleanTransect(
    point_elev = point_elev, 
    RadLineDist = RadLineDist,
    MaxOnshoreDist = MaxOnshoreDist,
    use_trimline = use_trimline,
    trimline = trimline
  )
  
  print("Saving output...")
  
  # Save outputs
  clean_point_elev_path <- out_params$clean_point_elev_path
  print("Writting output ...")

  arc.write(clean_point_elev_path, pt_exp, overwrite = TRUE)
  
  print("Function Completed...")
  
  return(out_params)
  
  
  
}
  
  