tool_exec <- function(in_params, out_params) {

# Make sure remotes is installed
if(!("remotes" %in% rownames(installed.packages()))){
    install.packages("remotes")
}

print("Load remotes")
library(remotes)

# Remove package if already installed and reinstall
if("MNAI.CPBT" %in% rownames(installed.packages())){
    print("Remove old package")
    #remove.packages("MNAI.CPBT")
}

print("Install MNAI.CPBT")
remotes::install_github("essatech/MNAI.CPBT", upgrade ='always', force = TRUE)

# Load package
print("Load MNAI.CPBT")
library(MNAI.CPBT)

print("Complete...")

return(out_params)

}