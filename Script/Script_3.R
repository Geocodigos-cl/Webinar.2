#Direccionar espacio de trabajo
setwd("C:/Users/Catalina/Desktop/Webinar2")

#Instslar y activar librerias
install.packages("sf")
install.packages("rgdal")
library(sf)
library(rgdal)

#Cargar Shapefile Red Hidrgrafica
Hidro <- st_read("Red_Hidrografica.shp")

#Ver sistema de referencia
st_crs(Hidro)

#Atributos
names(Hidro)

#View(Hidro)

#Seleccionar la hidrologia de la Region de Valparaiso
HidroValp <- Hidro[Region = "Región de Valparaíso",]

#Seleccionar Comuna de Quintero
H.Quintero1 <- Hidro[Hidro$Comuna %in% c("Quintero"),]

#Plotear a comuna de Quintero
plot(st_geometry (H.Quintero1))

#Disolver la red hidroligica (para calcular su longitud)
H.Quintero2 <- st_collection_extract(H.Quintero1,type="LINESTRING")
LongHidroQ <- st_length(H.Quintero1) / 1000 # km
head(LongHidroQ)

#Area de influencia (200m)
Buffer <- st_buffer(H.Quintero2,dist=200)
plot(st_geometry(Buffer),axes=F)
