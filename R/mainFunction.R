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
  
  # areaBounderies@data$NAME_2 # for municipality
  # areaBounderies@data$NAME_1 # for provinces 
  
  # Determine mean NDVI per area for each month ----------------------------
  
  meanPerArea_01 <- extractModis(modis,areaBounderies,1) #January
  meanPerArea_08 <- extractModis(modis,areaBounderies,8) #August
  meanPerArea    <- extractModis(modis,areaBounderies) #Whole Year
  
  
  # Make plot of area NDVI means  ------------------------------------------
  # dus per plaats een bepaalde intensiteit groen
  
  
  # Select greenest area ----------------------------------------------------
  
} # end function

extractModis <- function(modis,areaBounderies,month = 0){
  if(month == 0){
    modisPerArea <- extract(modis,areaBounderies)
  }else{
    modisPerArea <- extract(modis[[month]],areaBounderies)
  }
  if(class(areaBounderies$NAME_2) == "NULL"){ #No municipalities found, thus using provinces
    names(modisPerArea) <- areaBounderies$NAME_1
  }else{
    names(modisPerArea) <- areaBounderies$NAME_2
  }
  means <- lapply(modisPerArea,function(n) mean(n,na.rm =T))
  return (means)
}