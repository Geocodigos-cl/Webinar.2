#Direccionar espacio de trabajo
setwd("C:/Users/Catalina/Desktop/ejemplos R")

#Activar librería
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

plot(Poligonos["Id"],col=c("Dark Green","Blue","grey","white", "Cyan", "Pink", 
                           "Magenta", "Orange"))

plot(st_geometry(Puntos),add=TRUE)
plot(st_geometry(Puntos) + c(0.5,0),add=TRUE,pch=c(49,50,51),cex=1)
plot(st_geometry(Lineas),add=TRUE,lty=2,lwd = 2,col="red")

# agrega el número de las líneas
text(5,5.5,"1",pos=4,col="red",cex=1)
text(1.2,3,"2",pos=4,col="red",cex=1)
text(7.8,6,"3",pos=4,col="red",cex=1)

