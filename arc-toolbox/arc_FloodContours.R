tool_exec <- function(in_params, out_params) {
  

# Load package
print("Loading library...")
library(MNAI.CPBT)


# Open raster
print("Open Raster...")
TopoBathy = in_params$TopoBathy
print(TopoBathy)
rr <- arc.open(TopoBathy)
arcraster <- arc.raster(rr)
TopoBathy <- as.raster(arcraster)


 print("other inputs...")

mean_high_water = in_params$mean_high_water
total_wsl_adj = in_params$total_wsl_adj



 # Load data
 print("Get pts...")
  erosion_points = in_params$erosion_points
  importGeom = arc.open(erosion_points)
  arcgeom = arc.select(importGeom)
  erosion_points =  arc.data2sf(arcgeom)
 
 print("Build Obj...")

  erosion_totals <- list()
  erosion_totals[["erosion_points"]] <- erosion_points
  

 print("Run func...")
fc_obj <- MNAI.CPBT::FloodContours(
  TopoBathy = TopoBathy,
  mean_high_water = mean_high_water,
  total_wsl_adj = total_wsl_adj,
  erosion_totals = erosion_totals
) 


 print("func obj...")

  flood_contour <- fc_obj[["contours"]]
  r_d_veg       <- fc_obj[["r_d_veg"]]
  r_d_noveg     <- fc_obj[["r_d_noveg"]]



 print("write...")

# Set values to NA
  r_d_veg[r_d_veg>0] <- NA
  r_d_noveg[r_d_noveg>0] <- NA


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
  
  return(out_params)

  
}