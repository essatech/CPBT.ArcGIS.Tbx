tool_exec <- function(in_params, out_params) {
  

  # Load package
  print("Loading library...")
  library(MNAI.CPBT)



  Ho                   <- in_params$Ho
  To                   <- in_params$To
  total_wsl_adj        <- in_params$total_wsl_adj
  storm_duration       <- in_params$storm_duration
  ShorelinePointDist   <- in_params$ShorelinePointDist
  PropValue            <- in_params$PropValue
  disc                 <- in_params$disc
  TimeHoriz            <- in_params$TimeHoriz
  Tr                   <- in_params$Tr
  

  mean_high_water     <- in_params$mean_high_water
  mean_sea_level     <- in_params$mean_sea_level



  BeachAttributes      <- in_params$BeachAttributes
  wave_data            <- in_params$wave_data


  # Load data
  importGeom = arc.open(BeachAttributes)
  arcgeom = arc.select(importGeom)
  BeachAttributes =  arc.data2sf(arcgeom)
  
  # Load data
  importGeom = arc.open(wave_data)
  arcgeom = arc.select(importGeom)
  wave_data =  arc.data2sf(arcgeom)
  



linkbeach <- MNAI.CPBT::LinkProfilesToBeaches(
  BeachAttributes = BeachAttributes,
  dat = wave_data
)



erosion <- MNAI.CPBT::ErosionTransectsUtil(
  Ho = Ho,
  To = To,
  total_wsl_adj = total_wsl_adj,
  linkbeach = linkbeach,
  wave_data = wave_data,
  storm_duration = storm_duration,
  Longshore = ShorelinePointDist,
  PropValue = PropValue,
  Tr = Tr,
  disc = disc,
  TimeHoriz = TimeHoriz,
  mean_sea_level = mean_sea_level,
  mean_high_water = mean_high_water
)



  # Save outputs
  erosion_dat_path <- out_params$erosion_dat_path
  print("Writting output ...")
  print(erosion_dat_path)
  
  
  # Make spatial points
  wave_data <- wave_data[which(!(is.na(wave_data$elev))),]
  wave_data$xminpos <- abs(wave_data$Xpos)


  uids <- unique(wave_data$line_id)
  build_obj <- list()
  for(i in 1:length(uids)){
    this_id <- uids[i]
    ttran <- wave_data[which(wave_data$line_id == this_id), ]
    mmin <- min(ttran$H_noveg, na.rm=TRUE)
    keep <- ttran[which(ttran$H_noveg == mmin),]
    keep <- keep[1,]
    build_obj[[i]] <- keep
  }

  smpt <- do.call("rbind", build_obj)

  #smpt <- wave_data %>% group_by(line_id) %>% slice(which.min(H_noveg))
  smpt$transect_id <- smpt$line_id
  smpt <- smpt[,c("transect_id")]
  smpt2 <- merge(smpt, erosion, by.x="transect_id", by.y="transect_id")
  

  
  arc.write(erosion_dat_path, smpt2, overwrite = TRUE)
  
  
  
  
  
  
  ero_tot <- MNAI.CPBT::ErosionTotals (
              wave_data = wave_data,
              erosion = erosion,
              Longshore = ShorelinePointDist
            )


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