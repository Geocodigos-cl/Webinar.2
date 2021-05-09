#Instalar y activar librerías
install.packages("raster")
install.packages("rgdal")
install.packages("sf")
install.packages("maptools")
library(raster)
library(rgdal)
library(sf)
library(maptools)

#Establecer el directorio
setwd("C:/Users/Catalina/Desktop/Ejemplos Rstudio")

#Cargar Raster
AUrbana <- raster("aurb.tif")
RedVial <- raster("redvial.tif")
Hidrologia <- raster("hidro.tif")
Geologia <- raster("geo.tif")

#Ver atributos de los raster
AUrbana
RedVial
Hidrologia
Geologia

#Unir raster
datos_raster = stack(AUrbana, RedVial, Hidrologia, Geologia)

#Sumar raster
Sum_raster <- sum(datos_raster)
plot(Sum_raster, col=colorRampPalette(c("red", "white", "blue", "yellow"))(255))

#Multiplicar raster
Mult_raster <- AUrbana * RedVial * Hidrologia * Geologia
plot(Mult_raster,col=colorRampPalette(c("red", "white", "blue", "yellow"))(255) )
