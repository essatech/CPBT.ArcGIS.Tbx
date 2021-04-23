#--------------------------------------------
# Source All Custom Invest Functions
#--------------------------------------------
custom_functions = list.files(path="./R/", pattern="*.R")
sapply(paste0("./R/", custom_functions), source)


#--------------------------------------------
# Load All External Libraries
#--------------------------------------------
library(sp)
library(sf)
library(mapview)
library(geosphere)
library(raster)
library(pracma)
library(dplyr)
library(fields)
library(e1071)
library(gstat)
library(jsonlite)
library(rgdal)
library(rootSolve)