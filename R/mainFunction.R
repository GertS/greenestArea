# Gert Sterenborg and Job de Pater
# 20160113
# 


# Load packages -----------------------------------------------------------

library(rgdal)
library(raster)

mainFunction <- function(country = "Netherlands", area = "provinces" ){
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
  areaBounderies <- raster::getData('GADM',country=countryCode, level= level, path = "data")
  if (level == 1){
    areaBounderies <- areaBounderies[areaBounderies$ENGTYPE_1 != "Water body",]
  }else{
    areaBounderies <- areaBounderies[areaBounderies$ENGTYPE_2 != "Water body",]
  }
  
  
  # Reproject data ----------------------------------------------------------
  
  areaBounderies<- spTransform(areaBounderies, CRS(proj4string(modis)))
  
  # Determine mean NDVI per area for each month ----------------------------
  
  meanPerArea_01 <- extractModis(modis,areaBounderies,1) #January
  meanPerArea_08 <- extractModis(modis,areaBounderies,8) #August
  meanPerArea    <- extractModis(modis,areaBounderies) #Whole Year
  
  
  # Make plot of area NDVI means  ------------------------------------------
  
  # Define color  pallet (usage of spplot or ggplot is probably more convenient)
  rbPal <- colorRampPalette(c('yellow',"white",'green'))
  col <- function(ndvi){
    rbPal(12)[as.numeric(cut(unlist(ndvi),breaks = 10))]
  }
  
  # plot
  par(mfrow=c(1,3))
    plot(areaBounderies, col= col(meanPerArea), main='Whole year')
    plot(areaBounderies, col= col(meanPerArea_01), main='January') 
    plot(areaBounderies, col= col(meanPerArea_08), main='August')
    
  
  
  # Select greenest area ----------------------------------------------------
  maxJan <- which.max(meanPerArea_01)
  maxAug <- which.max(meanPerArea_08)
  maxAll <- which.max(meanPerArea)
  
  print(paste("The greenest area in January is:",names(maxJan)))
  print(paste("The greenest area in August is :",names(maxAug)))
  print(paste("The greenest area overall is   :",names(maxAll)))
  
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