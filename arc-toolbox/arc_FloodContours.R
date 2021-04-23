tool_exec <- function(in_params, out_params) {
  
  # library(arcgisbinding)
  # arc.check_product()
  
  # Load dependencies...
  path_invest = in_params$path_invest               # Path to invest tool directory
  setwd(path_invest)
  source("./arc-toolbox/arc_RLibraries.R")
  
  print("get inputs")
  
  
  
  # Open raster
  bathytopo_r     <- in_params$bathytopo_r
  rr <- arc.open(bathytopo_r)
  arcraster <- arc.raster(rr)
  r_bathytopo <- as.raster(arcraster)
  
  # other
  surge_elevation      <- in_params$surge_elevation
  mean_high_water      <- in_params$mean_high_water
  sea_level_rise       <- in_params$sea_level_rise
  
  total_wsl_adj = surge_elevation + mean_high_water + sea_level_rise
  
  
  print("start get table...")
  erosion_points       <- in_params$erosion_points
  importGeom = arc.open(erosion_points)
  arcgeom = arc.select(importGeom)
  erosion_points =  arc.data2sf(arcgeom)
  print("end get table...")
  
  
  
  #--------------------------------------------
  # Interpolate WSE and generate flood contours
  #--------------------------------------------   
  fc_obj <- func_FloodContours(
    path_bathytopo = NA,
    r_bathytopo = r_bathytopo,
    mean_high_water = mean_high_water,
    total_wsl_adj = total_wsl_adj,
    erosion_points = erosion_points
  )
  flood_contour <- fc_obj[["contours"]]
  r_d_veg       <- fc_obj[["r_d_veg"]]
  r_d_noveg     <- fc_obj[["r_d_noveg"]]
  #mapview(flood_contour)
  
  
  # Save outputs
  # flood_contour_path <- out_params$flood_contour_path
  # print("Writting output 1/3 ...")
  # print(flood_contour_path)
  # arc.write(flood_contour_path, flood_contour, overwrite = TRUE)
  # 
  
  # Save outputs
  r_d_veg_path <- out_params$r_d_veg_path
  print("Writting output 1/2 ...")
  print(r_d_veg_path)
  arc.write(r_d_veg_path, r_d_veg, overwrite = TRUE)
  
  
  # Save outputs
  r_d_noveg_path <- out_params$r_d_noveg_path
  print("Writting output 2/2 ...")
  print(r_d_noveg_path)
  arc.write(r_d_noveg_path, r_d_noveg, overwrite = TRUE)
  
  
  
}