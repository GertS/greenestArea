# Gert Sterenborg and Job de Pater
# 20160113
# 


# Load packages -----------------------------------------------------------

library(rgdal)
library(raster)

mainFunction <- function(country = "NLD", area = city, ){
# Download and read data --------------------------------------------------

dir.create("data", showWarnings = FALSE)

# Download and unzip
modis.url <- "https://github.com/GeoScripting-WUR/VectorRaster/raw/gh-pages/data/MODIS.zip"
inputZip <- list.files(path='data', pattern= '^.*\\.zip$')
if (length(inputZip) == 0){
  download.file(url = modis.url, destfile = 'data/modis.zip', method = 'wget')
}
modisData <- unzip('data/modis.zip', exdir='data/modis')

# Identify the right file and merge all layers in brick
modisPath <- list.files(path='data/modis', pattern = glob2rx('*.grd'), full.names = TRUE)
modis <- brick(modisPath)

# Download city bounderies of country
level <- ifelse(area == 'City' # make loop to set level 
areaBounderies <- raster::getData('GADM',country=country, level= level)


# Reproject data ----------------------------------------------------------


# Determine mean NDVI per area for each month ----------------------------
# use funciton extract

# Make plot of area NDVI means  ------------------------------------------
# dus per plaats een bepaalde intensiteit groen


# Select greenest area ----------------------------------------------------



} # end function
