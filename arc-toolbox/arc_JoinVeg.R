tool_exec <- function(in_params, out_params) {
  # library(arcgisbinding)
  # arc.check_product()
  
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  
  # Get inputs 
  pt_exp         <- in_params$pt_exp
  shp_marsh      <- in_params$shp_marsh
  shp_kelp       <- in_params$shp_kelp
  shp_eelgrass   <- in_params$shp_eelgrass
  

  
  # Open lines
  importGeom = arc.open(pt_exp)
  # Select
  arcgeom = arc.select(importGeom)
  # Convert format
  pt_exp =  arc.data2sf(arcgeom)
  
  
  # Start veg object
  veg_list <- list()
  list_counter <- 1
  
  
  if(length(shp_eelgrass) > 0){
    
    importGeom = arc.open(shp_eelgrass)
    arcgeom = arc.select(importGeom)
    shp_eelgrass =  arc.data2sf(arcgeom)
    shp_eelgrass$Type <- 'Eelgrass'
    veg_list[[list_counter]] <- shp_eelgrass
    list_counter <- 1 + list_counter
    
  }
  
  
  if(length(shp_marsh) > 0){
    
    importGeom = arc.open(shp_marsh)
    arcgeom = arc.select(importGeom)
    shp_marsh =  arc.data2sf(arcgeom)
    shp_marsh$Type <- 'Marsh'
    veg_list[[list_counter]] <- shp_marsh
    list_counter <- 1 + list_counter
    
  }
  
  
  if(length(shp_kelp) > 0){
    
    importGeom = arc.open(shp_kelp)
    arcgeom = arc.select(importGeom)
    shp_kelp =  arc.data2sf(arcgeom)
    shp_kelp$Type <- 'Kelp'
    veg_list[[list_counter]] <- shp_kelp
    list_counter <- 1 + list_counter
    
  }
  
  
  
  
  if(length(veg_list)>0){
    
    # Merge vegetation files together...
    merg_Veg = func_profile_ExtractVeg(
      pt_exp = pt_exp, 
      veg_list = veg_list
    )
    
    # Extract (join) vegetation and attributes under profiles
    elev_veg <- st_join(pt_exp, merg_Veg)
    elev_veg$n.overlaps <- NULL
    elev_veg$origins <- NULL
    dat <- elev_veg
    
  } else {
    
    #Type StemHeight StemDiam StemDensty Cd
    dat <- pt_exp
    dat$Type <- NA
    dat$StemHeight <- NA
    dat$StemDiam <- NA
    dat$StemDensty <- NA
    dat$Cd <- NA
    
  }
  
  
  
  
  # Save outputs
  veg_points <- out_params$veg_points
  print("Writting output ...")
  print(veg_points)
  
  arc.write(veg_points, dat, overwrite = TRUE)
  
  print("Function Completed...")
  
  
  return(out_params)
  
  
}