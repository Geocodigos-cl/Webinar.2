#Cargar Librerías
library(raster)
library(sp)
library(reshape2)
library(RStoolbox)
library(randomForest)
library(ggplot2)
library(maptools)
library(rgdal)
library(rgeos)
library(gridExtra)
library(RColorBrewer)
library(caret)
library(e1071)
library(snow)

################################################################################################
#Establecer el directorio
setwd("C:/Users/Catalina/Desktop/ejemplos R")

################################################################################################

#Cargar las imagenes raster de 20 metros
B11_20 <- raster("B11_20m.jp2")
B12_20 <- raster("B12_20m.jp2")

#Convertir raster de 20metros de pixel a 10metros de pixel
B11_10m <- disaggregate(B11_20, fact=2) #Reducir de 20metros a 10metros la resolución de pixel

writeRaster(B11_10m,"B11_10m.tif",driver="GeoTiff") #Guardar nuevo raster

B12_10m <- disaggregate(B12_20, fact=2) #Reducir de 20metros a 10metros la resolución de pix

writeRaster(B12_10m,"B12_10m.tif",driver="GeoTiff")#Guardar nuevo raster

################################################################################################

#Cargar bandas 
B2 <- raster("B02_10m.jp2")
B3 <- raster("B03_10m.jp2")
B4 <- raster("B04_10m.jp2")
B8 <- raster("B08_10m.jp2")
B11 <- raster("B11_10m.tif")
B12 <- raster("B12_10m.tif")

#Unión y asignación de nombres a las bandas
Bandas <-stack(B2, B3, B4, B8, B11, B12)

writeRaster(Bandas,"Bandas.tif",driver="GeoTiff")
