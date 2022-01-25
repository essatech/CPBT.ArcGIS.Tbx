# CPBT.ArcGIS.Tbx

## *The Municipal Natural Asset Initiative Coastal Protection and Benefit Tool*

<img src='logo.png' align="right" height="138.5" style="padding: 15px;"/>

<!-- badges: start -->
[![Lifecycle:
Stable](https://img.shields.io/badge/lifecycle-stable.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->


The **CPBT (Coastal Protection and Benefit Tool)** ArcGIS Toolbox contains functions to model coastal wave attenuation, shoreline erosion and flooding. This package is an adaptation of the Natural Capital [InVEST](https://naturalcapitalproject.stanford.edu/software/invest) Wave Attenuation and Erosion Reduction ArcGIS Toolbox originally developed by Greg Guannel. Functions and workflows have been modified for evaluating municipal natural assets. This tool is a software product of the [Municipal Natural Asset Initiative MNAI](https://mnai.ca/) developed in conjunction with [ESSA Technologies Ltd.](https://essa.com/) and [CBCL Ltd.](https://www.cbcl.ca/).


## Guidance Document

We recommend that all interested users consult the CPBT: Guidance Document to understand the use cases, strengths, and limitations of this toolbox.
[TODO: ADD LINK TO GUIDANCE DOCUMENT - IN PREP](https://mnai.ca/key-documents/).

## Installation

The **MNAI.CPBT** ArcGIS Toolbox requires ArcGIS Pro (basic or above) and the R-ArcGIS Bridge. To install this toolbox please follow the steps below: 

1. Ensure you have a working installation of ArcGIS Pro on your computer.
2. Install R for Windows (64 bit). [Download Link](https://cran.r-project.org/bin/windows/base/).
3. Install the R-ArcGIS-Bridge. Go to the [Bridge Repository](https://github.com/R-ArcGIS/r-bridge-install). Click the green Code button then click download zip. Unzip the files on your computer and then open ArcGIS Pro. Add the unzipped folder (r-bridge-install-master) as a new folder connection in the Catalogue Pane. Expand the R Integration.pyt toolbox and then click on the Install R bindings.
4. Download and install the MNAI.CPBT following the same method as above. Click the green Code button then click download zip. Unzip the files on your computer and then open ArcGIS Pro. Add the unzipped folder (CPBT.ArcGIS.tbx) as a new folder connection in the Catalogue Pane. 
5. Expand the MNAI_CPBT.tbx red toolbox and click the blue script icon named Install the CPBT. A function box will open with no parameters. Then click the Run button in the bottom corner. This will install dependencies needed. A message should appear stating Completed with warning (which is ok).

The above steps only need to be run once. If you wish to use the **MNAI.CPBT** ArcGIS Toolbox on another new or existing project, simply add the toolbox folder as a folder connection and the functions should be ready for use. If you encounter in issues with subsequent usages try running the * Install the CPBT * script again. If you encounter any problems in the installation process try updating the version of R on your computer (if it is below version 4.0.3).

## Troubleshooting 

The most likely source of potential errors are due to either installation issues or mismatched projections between input files. If you experience errors run through the following steps:
1. When you launch ArcGIS Pro right click on the launch icon and click run as administrator. Some errors may be due to write permissions from user accounts.
2. Download and install RTools (64 bit) [download link]( https://cran.r-project.org/bin/windows/Rtools/rtools40.html). RTools should not be a requirement for the CPBT, but there may be some issues trying to install the raster package. Restart your computer after you install RTools.
3. Check to see if there are errors with the R raster package installation. Open R or RStudio, enter library(raster) and hit enter. If there are any errors or warning messages try reinstalling the R raster package by running the following command in R:
```
install.packages('raster', repos='https://rspatial.r-universe.dev')
library(raster)
```
4. Try installing the CPBT from within R rather than within ArcGIS Pro. Close ArcGIS Pro and any other instances of R. Open R or RStudio and run the following commands
```
print("Install the remotes package to download the CPBT...")
install.packages("remotes", dependencies=TRUE, repos='http://cran.rstudio.com/')
print("Load remotes...")
library(remotes)
print("Install the MNAI.CPBT...")
remotes::install_github("essatech/MNAI.CPBT", upgrade ='always', force = TRUE)
# Choose 1: All if prompt to install dependencies
```
5. Open ArcGIS Pro and try running the CPBT again.
 



