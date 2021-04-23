tool_exec <- function(in_params, out_params) {
  
  # library(arcgisbinding)
  # arc.check_product()
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  print("get inputs")
  
  
  fprnt <- function(msg){
    arc.progress_label(msg)
    print(msg)
  }
  
  #--------------------------------------------
  # User Inputs - Arc Toolbox Arguments
  #--------------------------------------------
  # Input files
  
  sim_name <- in_params$sim_name
  sim_folder <- in_params$sim_folder
  print(sim_folder)
  sim_folder <- gsub("\\\\", "/", sim_folder)
  print(sim_folder)
  path_output <- paste0(sim_folder,"/",sim_name,"/")
  print(path_output)
  
  
  # Get input and output parameters
  print("Loading shoreline...")
  shorelinefc = in_params$shorelinefc               # Shapefile of shoreline
  importGeom = arc.open(shorelinefc)
  arcgeom = arc.select(importGeom)
  shorelinefc =  arc.data2sf(arcgeom)
  shoreline_fc <- shorelinefc
  
  
  BufferDist = in_params$BufferDist                 # Buffer distance in meters for vertical line
  RadLineDist = in_params$RadLineDist               # Line dist in km
  ShorelinePointDist = in_params$ShorelinePointDist # where to sample points on shoreline
  

  PointResolution <- 1
  
  print("Loading raster...")
  bathytopo_r     <- in_params$bathytopo_r
  rr <- arc.open(bathytopo_r)
  arcraster <- arc.raster(rr)
  bathytopo_r <- as.raster(arcraster)
  r_bathytopo <- bathytopo_r
  
  SmoothParameter <- in_params$SmoothParameter

  print("Loading buildings...")
  bld  <- in_params$bld
  importGeom = arc.open(bld)
  arcgeom = arc.select(importGeom)
  bld =  arc.data2sf(arcgeom)
  
  
  fprnt("Loading trimline...")
  trimline <- in_params$trimline
  if(length(trimline) == 0){
    use_trimline = FALSE
    trimline = NA
    fprnt("Not using trimline...")
  } else {
    fprnt("Using trimline...")
    importGeom = arc.open(trimline)
    arcgeom = arc.select(importGeom)
    trimline =  arc.data2sf(arcgeom)
    use_trimline = TRUE
    trimline = trimline
  }
  
  
  
  # Copy template directory to generate project files
  fprnt("Creating dir...")
  fprnt(path_output)
  dir.create(path_output)
  arc.progress_label("Copying base content ....")
  fprnt("Copying base content ... ")
  file.copy(paste0(path_invest, "/dev/template/www"), path_output, recursive=TRUE)
  file.copy(paste0(path_invest, "/dev/template/SimulationResults.html"), path_output, recursive=TRUE)
  
  
  # Numeric inputs
  MaxOnshoreDist  <- in_params$MaxOnshoreDist
  TrimOnshoreDist = FALSE
  ReCalcDDCalibPlots = FALSE # Redo depth-damage calibration plots
  
  
  # WAVE INPUTS
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
  
  dS = 0.1                # Surge reduction
  dx = 1                  # Model Spatial Resolution (dx)
  EconCP = "Yes"          # Compute Economic Valuation?
  #Longshore = 100         # Longshore Extent [no used]

  # FLOODING and WATER LEVELs
  mean_sea_level = 1.0    # CH Chart Datum DEM - 0m = MLLW

  # Sandy beach --- keep as default
  XelVal = 1
  sand = 1
  
  
  
  
  
  
  
  #--------------------------------------------
  # RUN FUNCTIONS...
  #--------------------------------------------

  
  # Sample shoreline points and get perpendicular lines
  fprnt("Sampling Shoreline Points ....")
  
  slp = SamplePoints(
    path_shoreline = NA, # shapefile of shoreline
    shoreline_fc = shoreline_fc,
    BufferDist = BufferDist, # Buffer distance in meters for vertical line
    RadLineDist = RadLineDist, # Line dist in km
    ShorelinePointDist = ShorelinePointDist # where to sample points on shoreline
  )
  
  perp_lines <- slp[[2]]
  shoreline_points <- slp[[1]]
  
  
  fprnt("Extracting Raster Elevations ....")
  
  point_elev <- ExtractElev(
    perp_lines = perp_lines,
    PointResolution = PointResolution,
    path_bathytopo = NA,
    r_bathytopo = r_bathytopo
  )
  
  fprnt("Smoothing Elevation Profiles...")
  
  # Smooth signal by percentage - SignalSmooth.smooth
  point_elev$elev_smooth <- SignalSmooth(
    point_elev = point_elev,
    SmoothParameter = SmoothParameter
  )
  
  
  #--------------------------------------------  
  # Clean and fix transects
  # need to make sure the direction is all the same ... need to exclude shallow islands 

  pt_exp <- CleanTransect(
    point_elev = point_elev, 
    RadLineDist = RadLineDist,
    MaxOnshoreDist = MaxOnshoreDist,
    use_trimline = use_trimline,
    trimline = trimline
  )
  
  
  
  
  
  
  
  
  fprnt("Gathering Vegetation Polygons ...")
  
  
  # Get inputs 
  shp_marsh      <- in_params$shp_marsh
  shp_kelp       <- in_params$shp_kelp
  shp_eelgrass   <- in_params$shp_eelgrass
  
  
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
  
  
  
  
  
  fprnt("Running Wave Model ...")
  
  #--------------------------------------------
  # Wave model
  #--------------------------------------------
  # determine storm surge flood
  total_wsl_adj = surge_elevation + mean_high_water + sea_level_rise
  
  fprnt(paste0("Total WSE Adj: ", total_wsl_adj))
  fprnt(paste0("Ho: ", Ho))
  fprnt(paste0("To: ", To))
  
  # run wave attenuation model
  wave_dat <- WaveModel(dat,
                        total_wsl_adj,
                        Ho=Ho,
                        To=To)
  #plot(st_geometry(wave_dat), pch=19, cex=0.1)
  fprnt("Wave model complete...")
  
  
  
  
  
  
  #--------------------------------------------
  # Calculate Erosion Distance
  #--------------------------------------------
  fprnt("Gathering shoreline inputs...")
  
  
  # Link profiles to shoreline berms
  fs <- in_params$fs
  
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
  
  fprnt("Calculate Erosion Distance...")
  
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
  
  fprnt("Beach Summary...")
  
  
  # Summarize shoreline erosion across whole shoreline
  ero_tot <- func_ErosionTotals(dat = dat, erosion = erosion,
                                Longshore = ShorelinePointDist, # USE POINT DISTANCE AS LONGSHORE
                                PropValue = PropValue, Tr = Tr,
                                disc = disc, TimeHoriz = TimeHoriz)
  
  
  

  
  #--------------------------------------------
  # Plot beach profile with flooding
  #--------------------------------------------   
  
  fprnt("Plotting Beach Profiles...")
  
  
  # Get flood distances and clean foreshore
  fo <- FloodPlot(
    dat = dat,
    erosion = erosion,
    mean_high_water = mean_high_water,
    path_output = path_output,
    export_plot = TRUE,
    total_wsl_adj =  total_wsl_adj,
    TrimOnshoreDist = FALSE
  )
  
  # Export wave profile csv with all data
  ExportProfiles(fo = fo, path_output = path_output, wave_dat = wave_dat)
  
  
  
  
  
  
  
  
  
  
  
  
  print("Function Completed...")
  
  
  return(out_params)
  
  
}