tool_exec <- function(in_params, out_params) {
  
  # library(arcgisbinding)
  # arc.check_product()
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  print("get inputs")
  
  # Get inputs 
  fs = in_params$fs
  if(length(fs) == 0){
    fs = NA
  } else {
    importGeom = arc.open(fs)
    arcgeom = arc.select(importGeom)
    fs =  arc.data2sf(arcgeom)
  }
  
  
  
  
  Ho                   <- in_params$Ho
  To                   <- in_params$To
  surge_elevation      <- in_params$surge_elevation
  mean_high_water      <- in_params$mean_high_water
  sea_level_rise       <- in_params$sea_level_rise
  storm_duration       <- in_params$storm_duration
  ShorelinePointDist   <- in_params$ShorelinePointDist
  PropValue            <- in_params$PropValue
  disc                 <- in_params$disc
  TimeHoriz            <- in_params$TimeHoriz
  Tr                   <- in_params$Tr
  
  
  sed_size            <- in_params$sed_size
  berm_lengt          <- in_params$berm_lengt
  berm_heigh          <- in_params$berm_heigh
  dune_heigh          <- in_params$dune_heigh
  fore_slp            <- in_params$fore_slp


  
  
  wave_dat       <- in_params$wave_dat
  importGeom = arc.open(wave_dat)
  arcgeom = arc.select(importGeom)
  wave_dat =  arc.data2sf(arcgeom)
  
  
  
  dat       <- in_params$dat
  importGeom = arc.open(dat)
  arcgeom = arc.select(importGeom)
  dat =  arc.data2sf(arcgeom)
  
  
  
  total_wsl_adj = surge_elevation + mean_high_water + sea_level_rise
  
  
 
  
  #--------------------------------------------
  # Calculate Erosion Distance
  #--------------------------------------------
  print("join start")
  
  
  # Link profiles to shoreline berms
  if(!(is.na(fs))){
    fs_dat <- LinkProfilesToBerms(path_foreshore=NA, dat, fs=fs)
  } else {
    line_id <- sort(unique(wave_dat$line_id))
    fs_dat <- data.frame(line_id = line_id,
                         sed_size = sed_size,
                         berm_lengt = berm_lengt,
                         berm_heigh = berm_heigh,
                         dune_heigh = dune_heigh,
                         fore_slp = fore_slp)
  }
  
  # Load sediment size lookup
  ssf_lookup = func_getSSF()
  
  print("ErosionTransectsUtil start")
  
  # Calculate Runup and Erosion
  erosion <- ErosionTransectsUtil(Ho=Ho,
                                  To=To,
                                  ssf_lookup = ssf_lookup,
                                  total_wsl_adj = total_wsl_adj,
                                  fs_dat = fs_dat,
                                  wave_dat = wave_dat,
                                  storm_duration = storm_duration,
                                  Tr = Tr,
                                  Longshore = ShorelinePointDist, 
                                  PropValue = PropValue,
                                  disc = disc,
                                  TimeHoriz = TimeHoriz)
  
  print("ErosionTransectsUtil comp")

  # Save outputs
  erosion_dat_path <- out_params$erosion_dat_path
  print("Writting output ...")
  print(erosion_dat_path)
  
  
  # Make spatial points
  wave_dat <- wave_dat[which(!(is.na(wave_dat$elev))),]
  wave_dat$xminpos <- abs(wave_dat$Xpos)
  smpt <- wave_dat %>% group_by(line_id) %>% slice(which.min(H_noveg))
  smpt$transect_id <- smpt$line_id
  smpt <- smpt[,c("transect_id")]
  smpt2 <- merge(smpt, erosion, by.x="transect_id", by.y="transect_id")
  

  
  arc.write(erosion_dat_path, smpt2, overwrite = TRUE)
  
  
  
  
  
  
  
  # Summarize shoreline erosion across whole shoreline
  ero_tot <- func_ErosionTotals(dat = dat, erosion = erosion,
                                Longshore = ShorelinePointDist, # USE POINT DISTANCE AS LONGSHORE
                                PropValue = PropValue, Tr = Tr,
                                disc = disc, TimeHoriz = TimeHoriz)
  
  ero_tot_out <- data.frame(
    TotalErosionVeg_m2 = ero_tot$total_erosion_Veg_m2,
    TotalErosionNoVeg_m2 = ero_tot$total_erosion_NoVeg_m2,
    ErosionDiffVegNoVeg_m2 = ero_tot$total_erosion_diff_m2,
    ErosionPctDiffVegNoVeg = ero_tot$percent_diff*100,
    TotalDamageVeg = ero_tot$total_damage_Veg,
    TotalDamageNoVeg = ero_tot$total_damage_NoVeg,
    DamgePctDiffVegNoVeg = ero_tot$percent_diff_damage*100
    )
  
  # Save outputs
  ero_tot_path <- out_params$ero_tot_path
  print("Writting output ...")
  print(ero_tot_path)
  

  arc.write(ero_tot_path, ero_tot_out, overwrite = TRUE)
  
  
  
  
  
  print("Function Completed...")
  
  
  return(out_params)

  
}