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

# Open the Buildings layer

    print("Loading Bldgs...")
    Bldgs0 = in_params$Bldgs
    importGeom = arc.open(Bldgs0)
    arcgeom = arc.select(importGeom)
    Bldgs0 =  arc.data2sf(arcgeom)
    Bldgs = Bldgs0



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
  



# Run the flood function

    print("Run func FloodContours...")

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


# Run the depth-damage function

    print("Loading hazus data")
    data(HAZUS)
    print("nrow HAZUS")
    print(nrow(HAZUS))

    print("Running DepthDamageFlood function")

    dd_flood <- MNAI.CPBT::DepthDamageFlood(
        Bldgs = Bldgs,
        flood_contours = fc_obj,
        HAZUS = HAZUS
    )


    print("write outputs...")


# Save outputs - flood contours
    flood_countours <- out_params$flood_countours


    print("Writting flood contour ...")

    if(length(flood_countours) == 0){
    
    print("User is not exporting flood_countours ...")

    } else {
    
    print("exporting flood_countours ...")

    print(flood_countours)
    arc.write(flood_countours, flood_contour, overwrite = TRUE)
    
    }



 
  
# Save outputs - depth damage summary
  dd_summary <- out_params$dd_summary
  print("Writting output dd_summary table ...")
  print(dd_summary)
  arc.write(dd_summary, dd_flood, overwrite = TRUE)
    

  print("Return output parameters ...")
  return(out_params)

  
}