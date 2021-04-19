#Direccionar espacio de trabajo
setwd("C:/Users/Catalina/Desktop/ejemplos R")

#Activar librería
library(sf)

#Cargar Shapefile regiones
Regiones <- st_read("Regional.shp")

#Ver sistema de referencia
st_crs(Regiones)

#Atributos
names(Regiones)

#Cálculos de atributos
summary(Regiones)

#Seleccionar regiones de la Zona Norte
ZonaNorte <- Regiones[Regiones$Region %in% c("Región de Arica y Parinacota", 
                      "Región de Atacama", "Región de Antofagasta", 
                      "Región de Tarapacá", "Región de Coquimbo"),]

#Plotear Zona Norte
#plot(st_geometry (ZonaNorte))

#Base de población Censo de Población 
Poblacion <- read.csv("Poblacion2.csv", sep = ";")

#Leer base de datos población
head(Poblacion)

#Leer tabla de atributos shape Zona Norte
head(ZonaNorte)

#Unir bases de datos
ZonaNorte <- merge(ZonaNorte, Poblacion, by.x="Region", by.y="Region")

#Ver tabla de atributos
ZonaNorte


