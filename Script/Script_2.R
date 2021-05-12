#Direccionar espacio de trabajo
setwd("C:/Users/Catalina/Desktop/Webinar2")

#Instslar y activar libreria
install.packages("sf")
library(sf)

#Cargar Shapefile regiones
Regiones <- st_read("Regional.shp")

#Ver sistema de referencia
st_crs(Regiones)

#Atributos
names(Regiones)

#Calculos de atributos
summary(Regiones)

#Seleccionar regiones de la Zona Norte
ZonaNorte <- Regiones[Regiones$Region %in% c("Regi?n de Arica y Parinacota", 
                      "Regi?n de Atacama", "Regi?n de Antofagasta", 
                      "Regi?n de Tarapac?", "Regi?n de Coquimbo"),]

#Plotear Zona Norte
#plot(st_geometry (ZonaNorte))

#Base de poblacion Censo de Poblacion 
Poblacion <- read.csv("Poblacion2.csv", sep = ";")

#Leer base de datos poblacion
head(Poblacion)

#Leer tabla de atributos shape Zona Norte
head(ZonaNorte)

#Unir bases de datos
ZonaNorte <- merge(ZonaNorte, Poblacion, by.x="Region", by.y="Region")

#Ver tabla de atributos
ZonaNorte


