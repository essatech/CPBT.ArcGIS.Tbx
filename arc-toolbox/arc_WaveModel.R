tool_exec <- function(in_params, out_params) {
  # library(arcgisbinding)
  # arc.check_product()
  
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  
  # Get inputs 
  dat         <- in_params$dat
  surge_elevation      <- in_params$surge_elevation
  mean_high_water       <- in_params$mean_high_water
  sea_level_rise   <- in_params$sea_level_rise
  Ho   <- in_params$Ho
  To   <- in_params$To

  
  # Load data
  importGeom = arc.open(dat)
  arcgeom = arc.select(importGeom)
  dat =  arc.data2sf(arcgeom)
  
  print('INPUT POINTS...')
  print(nrow(dat))
  print(class(dat))
  
  #--------------------------------------------
  # Wave model
  #--------------------------------------------
  # determine storm surge flood
  total_wsl_adj = surge_elevation + mean_high_water + sea_level_rise
  
  print(paste0("Total WSE Adj: ", total_wsl_adj))
  print(paste0("Ho: ", Ho))
  print(paste0("To: ", To))
  
  # run wave attenuation model
  wave_dat <- WaveModel(dat,
                        total_wsl_adj,
                        Ho=Ho,
                        To=To)
  #plot(st_geometry(wave_dat), pch=19, cex=0.1)
  
  # Save outputs
  wave_dat_path <- out_params$wave_dat_path
  print("Writting output ...")
  print(wave_dat_path)
  
  arc.write(wave_dat_path, wave_dat, overwrite = TRUE)
  
  print("Function Completed...")
  
  
  return(out_params)
  
  
  
  
  
  
  
  
  
  
  
}