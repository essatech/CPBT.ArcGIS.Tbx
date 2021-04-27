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



