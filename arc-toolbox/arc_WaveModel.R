tool_exec <- function(in_params, out_params) {
  
  
  
  
  # Load package
  print("Loading library...")
  library(MNAI.CPBT)


   # Get inputs 
  dat         <- in_params$dat
  total_wsl_adj   <- in_params$total_wsl_adj
  Ho   <- in_params$Ho
  To   <- in_params$To
  tran_force   <- in_params$tran_force

  
  # Load data
  importGeom = arc.open(dat)
  arcgeom = arc.select(importGeom)
  dat =  arc.data2sf(arcgeom)
  
  
  
  wave_dat <- MNAI.CPBT::WaveModel(
              dat = dat,
              total_wsl_adj = total_wsl_adj,
              Ho = Ho,
              To = To,
              tran_force = tran_force,
              print_debug = FALSE
  )
  
  # Save outputs
  wave_dat_path <- out_params$wave_dat_path
  print("Writting output ...")
  print(wave_dat_path)
  
  arc.write(wave_dat_path, wave_dat, overwrite = TRUE)
  
  print("Function Completed...")
  
  
  return(out_params)
  
  
  

  
  
  
}