tool_exec <- function(in_params, out_params) {
  
# Load package
library(MNAI.CPBT)

#=========================================
# Load and sanitize all non-spatial inputs
#=========================================
wind_speed <- in_params$wind_speed
fetch_distance <- in_params$fetch_distance
water_depth <- in_params$water_depth


waveHeightPeriod <- windWave(wind_speed = wind_speed,
                             fetch_distance = fetch_distance,
                             water_depth = water_depth) 

Ho = waveHeightPeriod[[1]]
To = waveHeightPeriod[[2]]

t=seq(0,12,0.1)
y=sin(t)*Ho
t <- t * (To/(2*pi))
plot(t,y,type="l",
     xlab=paste0("Period (To): ", round(To, 1), " seconds"),
     ylab=paste0("Height (Ho): ", round(Ho, 2), " meters"),
     main=paste0("Height (Ho): ", round(Ho, 2), " meters\r\n",
                 "Period (To): ", round(To, 1), " seconds"))
  

  
return(out_params)
  
  
}