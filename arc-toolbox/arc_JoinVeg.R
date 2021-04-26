tool_exec <- function(in_params, out_params) {
  
  
  
# Load package
  print("Loading library...")
  library(MNAI.CPBT)

  
# Get inputs 
  Vegetation      <- in_params$Vegetation

# Get input and output parameters
  print("Loading Spatial...")
  getpath = in_params$pt_exp
  importGeom = arc.open(getpath)
  arcgeom = arc.select(importGeom)
  pt_exp =  arc.data2sf(arcgeom)

  
if(length(Vegetation) == 0){
    
    Vegetation = NA
    print("Not using trimline...")
    
} else {
    
    print("Using trimline...")
    importGeom = arc.open(Vegetation)
    arcgeom = arc.select(importGeom)
    Vegetation =  arc.data2sf(arcgeom)
    
    Vegetation = Vegetation
}    


  
  dat <- MNAI.CPBT::ExtractVeg(
    pt_exp = pt_exp,
    Vegetation = Vegetation
  ) 
  
  
  
    # Save outputs
  veg_points <- out_params$veg_points
  print("Writting output ...")
  print(veg_points)
  
  arc.write(veg_points, dat, overwrite = TRUE)
  
  print("Function Completed...")
  
  
  return(out_params)
  
  
  
}