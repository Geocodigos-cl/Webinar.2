#Direccionar espacio de trabajo
setwd("C:/Users/Catalina/Desktop/Webinar2")

#Instslar y activar libreria
install.packages("sf")
library(sf)

#Cargar Shapefile Puntos
Puntos <- st_read("Punto.shp")

#Cargar Shapefile Lineas
Lineas <- st_read("Linea.shp")

#Calcula longitud
st_length(Lineas)

#Cargar Shapefile Pligono
Poligonos <- st_read("Poligono.shp")

#Calcular Area
st_area(Poligonos)

#Ploteado de archivos vectoriales
plot(Poligonos["Id"],col=c("Dark Green","Blue","grey","white", "Cyan", "Pink", 
                           "Magenta", "Orange"))
plot(Puntos["Id"],col=c("Dark Green","Blue","grey","white", "Cyan", "Pink", 
                           "Magenta", "Orange"))
plot(Lineas["Id"],col=c("Dark Green","Blue","grey","white", "Cyan", "Pink", 
                           "Magenta", "Orange"))

