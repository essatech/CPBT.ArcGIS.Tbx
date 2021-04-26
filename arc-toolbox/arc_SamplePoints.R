tool_exec <- function(in_params, out_params) {
  
# Load package
print("Loading library...")
library(MNAI.CPBT)

# Get input and output parameters
print("Loading Coastline...")
Coastline0 = in_params$Coastline
importGeom = arc.open(Coastline0)
arcgeom = arc.select(importGeom)
Coastline =  arc.data2sf(arcgeom)

print("Getting numeric parameters...")
ShorelinePointDist = in_params$ShorelinePointDist # where to sample points on shoreline
BufferDist <- in_params$BufferDist
RadLineDist <- in_params$RadLineDist


print("Running function...")
slp = MNAI.CPBT::samplePoints(
  Coastline = Coastline,
  ShorelinePointDist = ShorelinePointDist,
  BufferDist = BufferDist,
  RadLineDist = RadLineDist
)

    
perp_lines <- slp[[2]]
shoreline_points <- slp[[1]]
  
print("Saving outputs...")
# Save outputs
path_pts <- out_params$shoreline_points
path_lines <- out_params$shoreline_lines

print("writing outputs...")
arc.write(path_pts, shoreline_points, overwrite = TRUE)
arc.write(path_lines, perp_lines, overwrite = TRUE)


return(out_params)
}