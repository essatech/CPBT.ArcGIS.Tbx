tool_exec <- function(in_params, out_params) {
  
# Load package
library(MNAI.CPBT)

#=========================================
# Load and sanitize all non-spatial inputs
#=========================================
Hi <- in_params$Hi
To <- in_params$To
hi <- in_params$hi
hc <- in_params$hc
Cwidth <- in_params$Cwidth
Bwidth <- in_params$Bwidth


pfinal <- submergedStructure(Hi = Hi, To = To, hi = hi, hc = hc, Cwidth = Cwidth,
                             Bwidth = Bwidth)

plot(c(0, 1), c(0, 1), ann = F, bty = 'n', type = 'n', xaxt = 'n', yaxt = 'n')

text(x = 0.5, y = 0.5, paste0("Inital Wave Height: ", Hi," m.\r\n",
                              "Reduction: ", round((1-pfinal)*100,0),"%.\r\n",
                              "Final Wave Height: ", round(pfinal*Hi,2)," m.\r\n"), 
     cex = 1, col = "blue")

return(out_params)
  
  
}