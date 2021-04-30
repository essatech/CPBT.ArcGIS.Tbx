tool_exec <- function(in_params, out_params) {
  
  
  
# Load package
print("Loading library...")
library(MNAI.CPBT)

  
# Get inputs 
  point_elev      <- in_params$point_elev
  RadLineDist     <- in_params$RadLineDist
  MaxOnshoreDist  <- in_params$MaxOnshoreDist
  trimline        <- in_params$trimline
  

# Get input and output parameters
  print("Loading Spatial...")
  getpath = in_params$point_elev
  importGeom = arc.open(getpath)
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


  
pt_exp <- MNAI.CPBT::CleanTransect(
  point_elev = point_elev,
  RadLineDist = RadLineDist,
  MaxOnshoreDist = MaxOnshoreDist,
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
  
  