# Gert Sterenborg and Job de Pater
# 20160113
# 


# Load packages -----------------------------------------------------------

library(rgdal)
library(raster)

mainFunction <- function(country = "Netherlands", area = "city", ){
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
level <- ifelse(area == "city", 2, 1)  # greenest city or province
ISO <- data.frame(getData("ISO3") )
countryCode <- as.character(ISO[ISO$NAME== country,'ISO3'])
areaBounderies <- raster::getData('GADM',country=countryCode, level= level)


# Reproject data ----------------------------------------------------------

areaBounderies<- spTransform(areaBounderies, CRS(proj4string(modis)))


# Create objects that can be use for extraction ---------------------------

areaBounderies@data$NAME_2 # for municipality
areaBounderies@data$NAME_1 # for provinces 

# Determine mean NDVI per area for each month ----------------------------


# Make plot of area NDVI means  ------------------------------------------
# dus per plaats een bepaalde intensiteit groen


# Select greenest area ----------------------------------------------------



} # end function
