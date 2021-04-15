#Direccionar espacio de trabajo
setwd("C:/Users/Catalina/Desktop/ejemplos R")

#Activar librería
library(raster)
library(sf)

#Cargar shapefile
Geologia <- st_read("Union.shp")

#Plotear
plot(Geologia["Geologia"], axes = T,cex.lab=0.8)

#Ver la tabla de atributos del shapefile
Geologia

