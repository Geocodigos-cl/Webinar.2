## Webinar N°2
En este webinar se verá el geoprocesamiento de archivos vectoriales y raster.
En el siguiente [link](https://drive.google.com/drive/folders/1C8UxSV7bQzPTtq8ln-DKNUvuKa72x5pY?usp=sharing) se encuentran los materiales necenesarios para que ustedes puedan desarrollar lo expuesto en los siguientes scripts:

#### Script N°1 "Análisis archivos vectoriales"
##### Direccionar espacio de trabajo
```r
setwd("C:/Users/NOMBRE")
```
##### instalar y activar librería "sp"
```r
install.packages("sf")
library(sf)
```
##### Cargar Shapefile Puntos
```r
Puntos <- st_read("Punto.shp")
```
##### Cargar Shapefile Lineas
```r
Lineas <- st_read("Linea.shp")
```
##### Calcula longitud
```r
st_length(Lineas)
```
##### Cargar Shapefile Pligono
```r
Poligonos <- st_read("Poligono.shp")
```
##### Calcular Area
```r
st_area(Poligonos)

plot(Poligonos["Id"],col=c("Dark Green","Blue","grey","white", "Cyan", "Pink", 
                           "Magenta", "Orange"))

plot(st_geometry(Puntos),add=TRUE)
plot(st_geometry(Puntos) + c(0.5,0),add=TRUE,pch=c(49,50,51),cex=1)
plot(st_geometry(Lineas),add=TRUE,lty=2,lwd = 2,col="red")
```
##### Agrega el número de las líneas
```r
text(5,5.5,"1",pos=4,col="red",cex=1)
text(1.2,3,"2",pos=4,col="red",cex=1)
text(7.8,6,"3",pos=4,col="red",cex=1)
```
#### Script N°2 "Unión de base de datos con archivo vectorial"
##### Direccionar espacio de trabajo
```r
setwd("C:/Users/NOMBRE")
```
##### Activar librería
```r
library(sf)
```
##### Cargar Shapefile regiones
```r
Regiones <- st_read("Regional.shp")
```
##### Ver sistema de referencia
```r
st_crs(Regiones)
```
##### Atributos Shapefile
```r
names(Regiones)
```
##### Cálculos de atributos
```r
summary(Regiones)
```
##### Seleccionar regiones de la Zona Norte
```r
ZonaNorte <- Regiones[Regiones$Region %in% c("Región de Arica y Parinacota", 
                      "Región de Atacama", "Región de Antofagasta", 
                      "Región de Tarapacá", "Región de Coquimbo"),]
```
##### Plotear Zona Norte
```r
plot(st_geometry (ZonaNorte))
```
##### Base de población Censo de Población 
```r
Poblacion <- read.csv("Poblacion2.csv", sep = ";")
```
##### Leer base de datos población
```r
head(Poblacion)
```
##### Leer tabla de atributos shape Zona Norte
```r
head(ZonaNorte)
```
##### Unir bases de datos
```r
ZonaNorte <- merge(ZonaNorte, Poblacion, by.x="Region", by.y="Region")
```
##### Ver tabla de atributos
```r
ZonaNorte
```
#### Script N°3 "Ejemplo análisis hidrológico"
##### Direccionar espacio de trabajo
```r
setwd("C:/Users/NOMBRE")
```
##### Activar librería
```r
library(sf)
library(rgdal)
```
##### Cargar Shapefile Red Hídrgráfica
```r
Hidro <- st_read("Red_Hidrografica.shp")
```
##### Ver sistema de referencia
```r
st_crs(Hidro)
```
##### Atributos
```r
names(Hidro)
```
##### Ver Hidro
```r
View(Hidro)
```
##### Seleccionar la hidrología de la Región de Valparaíso
```r
HidroValp <- Hidro[Region = "Región de Valparaíso",]
```
##### Seleccionar Comuna de Quintero
```r
H.Quintero1 <- Hidro[Hidro$Comuna %in% c("Quintero"),]
```
##### Plotear a comuna de Quintero
```r
plot(st_geometry (H.Quintero1))
```
##### Disolver la red hidrológica (para calcular su longitud)
```r
H.Quintero2 <- st_collection_extract(H.Quintero1,type="LINESTRING")
LongHidroQ <- st_length(H.Quintero1) / 1000 # km
```
##### Leer tabla de atributos
```r
head(LongHidroQ)
```
##### Área de influencia (200m)
```r
Buffer <- st_buffer(H.Quintero2,dist=200)
```
##### Plotear Buffer
```r
plot(st_geometry(Buffer),axes=F)
```
#### Script N°4 "Raster"
##### Direccionar espacio de trabajo
```r
setwd("C:/Users/NOMBRE")
```
##### Instalar y activar librería
```r
install.packages("raster")
library(raster)
```
##### Crear matrices
```r
m1 <- matrix(c(1,1,2,2,1,1,2,2,1,1,3,3),ncol=4,nrow=3,byrow=TRUE)
print(m1)
m2 <- matrix(c(1,2,3,4,2,NA,2,2,3,4,3,1),ncol=4,nrow=3,byrow=TRUE)
print(m2)
```
##### Crear raster
```r
r1 <- raster(m1)
r2 <- raster(m2)
```
##### Extención de localización (xmin, xmax, ymin, ymax)
```r
extent(r1) <- extent(r2) <- extent(c(0,4,0,3))
```
##### Asignar colores y plotear
```r
colortable(r1) <- c("lightblue","purple","lightgreen", "pink", "orange")
plot(r1,axes=TRUE)
colortable(r2) <- c("lightblue","purple","lightgreen", "pink", "orange")
plot(r2,axes=TRUE)
```
##### Propiedades del raster
```r
res(r1)
res(r2)
```
##### Álgebra de mapas
```r
sum1 <- r1 + 2; print(as.matrix(sum1))
sum2 <- r1 + 2*r2 ;print(as.matrix(sum2))
```
##### Crear matriz
```r
m3 <- matrix(c(1,3,5,5,5,4,5,1,5,1,2,5),ncol=4,nrow=3,byrow=TRUE)
print(m3)
```
##### Crear raster
```r
r3 <- raster(m3)
```
##### Extención de localización (xmin, xmax, ymin, ymax)
```r
extent(r3) <- extent(c(0,4,3,6))
mosaico <- merge(r1,r3)
extent(mosaico)
plot(mosaico)
```
#### Script N°5 "Álegra de mapas"
##### Direccionar espacio de trabajo
```r
setwd("C:/Users/NOMBRE")
```
##### Instalar y activar librerías
```r
install.packages("raster")
install.packages("rgdal")
install.packages("sf")
install.packages("maptools")
library(raster)
library(rgdal)
library(sf)
library(maptools)
```
##### Cargar Raster
```r
AUrbana <- raster("aurb.tif")
RedVial <- raster("redvial.tif")
Hidrologia <- raster("hidro.tif")
Geologia <- raster("geo.tif")
```
##### Ver atributos de los raster
```r
AUrbana
RedVial
Hidrologia
Geologia
```
##### Unir raster
```r
datos_raster = stack(AUrbana, RedVial, Hidrologia, Geologia)
```
##### Sumar raster
```r
Sum_raster <- sum(datos_raster)
plot(Sum_raster, col=colorRampPalette(c("red", "white", "blue", "yellow"))(255))
```
##### Multiplicar raster
```r
Mult_raster <- AUrbana * RedVial * Hidrologia * Geologia
plot(Mult_raster,col=colorRampPalette(c("red", "white", "blue", "yellow"))(255) )
```

#### Script N°6 "Machine learning"
##### Direccionar espacio de trabajo
```r
setwd("C:/Users/NOMBRE")

```
##### Instalar y activar librerias
```r
install.packages("raster")
install.packages("sp")
install.packages("reshape2")
install.packages("RStoolbox")
install.packages("randomForest")
install.packages("ggplot2")
install.packages("maptools")
install.packages("rgdal")
install.packages("rgeos")
install.packages("gridExtra")
install.packages("RColorBrewer")
install.packages("caret")
install.packages("e1071")
install.packages("snow")
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
```
##### Cargar las imagenes raster de 20 metros
```r
B11_20 <- raster("B11_20m.jp2")
B12_20 <- raster("B12_20m.jp2")
```
##### Convertir raster de 20metros de pixel a 10metros de pixel y guardar
```r
B11_10m <- disaggregate(B11_20, fact=2) 

writeRaster(B11_10m,"B11_10m.tif",driver="GeoTiff")

B12_10m <- disaggregate(B12_20, fact=2) 

writeRaster(B12_10m,"B12_10m.tif",driver="GeoTiff")
```
##### Cargar bandas
```r
B2 <- raster("B02_10m.jp2")
B3 <- raster("B03_10m.jp2")
B4 <- raster("B04_10m.jp2")
B8 <- raster("B08_10m.jp2")
B11 <- raster("B11_10m.tif")
B12 <- raster("B12_10m.tif")
```
##### Leer Shapefile del area de estudio 
```r
AEstudio <- readShapeSpatial("AreaEstudio.shp")
plot(AEstudio)
```
##### Cortar Raster
```r
RasterClipB2 <- crop(B2, AEstudio)
RasterClipB3 <- crop(B3, AEstudio)
RasterClipB4 <- crop(B4, AEstudio)
RasterClipB8 <- crop(B8, AEstudio)
RasterClipB11 <- crop(B11, AEstudio)
RasterClipB12 <- crop(B12, AEstudio)

CorteB2 <- mask(RasterClipB2, mask = AEstudio)
CorteB3 <- mask(RasterClipB3, mask = AEstudio)
CorteB4 <- mask(RasterClipB4, mask = AEstudio)
CorteB8 <- mask(RasterClipB8, mask = AEstudio)
CorteB11 <- mask(RasterClipB11, mask = AEstudio)
CorteB12 <- mask(RasterClipB12, mask = AEstudio)
```
##### Union y asignacion de nombres a las bandas
```r
Bandas <-stack(CorteB2, CorteB3, CorteB4, CorteB8, CorteB11, CorteB12)
names(Bandas)<- c("Blue", "Green", "Red", "NIR", "Swir1", "Swir2")

plot(Bandas)
```
##### Guardar raster de bandas
```r
writeRaster(Bandas,"Bandas.tif",driver="GeoTiff")
```
##### Calculo del NDVI (NIR - R)/(NIR + R)
```r
nir <- Bandas$NIR # Infrarojo cercano
red <- Bandas$Red # Rojo

ndvi <- (nir-red)/(nir+red) #NDVI
ndvi[ndvi>1] <- 1; ndvi[ndvi< (-1)] <- -1 #Reescalado para evitar outliers

names(ndvi) <- "NDVI"
```
##### Visualizacion NDVI guardada en el objeto ndvi_plot
```r
ndvi_plot <- ggR(ndvi, geom_raster = TRUE,alpha = 1)+
  scale_fill_gradientn(colours = rev(terrain.colors(100)), 
                       name = "NDVI") + 
  theme(legend.positio = "bottom")
```
##### Visualizacion falso color guardada en el objecto falso_color
```r
falso_color_ndvi <- ggRGB(Bandas, r= "NIR" , g="Green" , b="Blue",
                          stretch = "lin")
```
##### Representacion final
```r
grid.arrange(ndvi_plot, falso_color_ndvi, ncol=2)

writeRaster(ndvi,"NDVI.tif",driver="GeoTiff")
```
##### Cálculo del NDBI (SWIR1 - NIR)/(SWIR1 + NIR)
```r
nir <- Bandas$NIR # Infrarojo cercano
swir1 <- Bandas$Swir1 # Swir1

ndbi <- (swir1-nir)/(swir1+nir) #NBDI
ndbi[ui>1] <- 1; ndbi[ndbi< (-1)] <- -1 #Reescalado para evitar outliers

names(ndbi) <- "NDBI"
```
##### Visualización NDBI guardada en el objeto ndwi_plot
```r
ndbi_plot <- ggR(ndbi, geom_raster = TRUE,alpha = 1)+
  scale_fill_gradientn(colours = rev(terrain.colors(100)), 
                       name = "NDBI") + 
  theme(legend.positio = "bottom")
```
##### Visualización falso color guardada en el objecto falso_color
```r
falso_color_ndbi <- ggRGB(Bandas, r= "NIR" , g="Green" , b="Blue",
                          stretch = "lin")
```
##### Representación final
```r
grid.arrange(ndbi_plot, falso_color_ndbi, ncol=2)


writeRaster(ndbi,"NDBI.tif",driver="GeoTiff")
```
##### Union de bandas espectrales con los indices
```r
Bandas2 <- stack(Bandas,ndvi,ndbi)
writeRaster(Bandas2,"Bandas_indices.tif",driver="GeoTiff")
```
##### Cargar raster con las bandas e indices
```r
sentinel<- stack("Bandas_indices.tif")

plot(sentinel)
```
##### Cargar shapefile con los poligonos de control
```r
train <-readOGR("PControl.shp")
plot(train)
train
names(train)
```
##### Desagrupar y Seleccionar la muestra aleatoria de los poligonos de control por cada categoria
```r
AU <- subset(train, Tipo == "Zona construida")
AU <- subset(AU[1:5,], Tipo == "Zona construida") 

VG <- subset(train, Tipo == "Area verde")
VG <- subset(VG[1:5,], Tipo == "Area verde") 

SN <- subset(train, Tipo == "Suelo desnudo")
SN <- subset(SN[1:5,], Tipo == "Suelo desnudo") 

CA <- subset(train, Tipo == "Cuerpo de agua")
CA <- subset(CA[1:5,], Tipo == "Cuerpo de agua") 
```
##### Volver a juntar los pol?gonos de cada categor?a
```r
train <- bind(CA,SN,VG,AU)
train
```
##### Generar clasificacion supervisada con MLC
```r
beginCluster() 

supervised <- superClass(sentinel, trainData = train, polygonBasedCV = T, 
              nSamples = 3015, minDist = 1, responseCol = "Tipo", 
              model="mlc", trainPartition = 0.80,
              kfold = 4, verbose = T, mode = "classification", 
              predict = TRUE) 

endCluster()
```
##### Crear confusion matrix 
```r
getValidation(supervised, metrics = "caret")
```
##### Asigar colores a las clasificaciones
```r
colors <- c("green","cyan", "chocolate4", "azure3")
plot(supervised$map)
```
##### Plotear
```r
plot(supervised$map, col = colors, legend = FALSE)
legend(as.character(supervised$classMapping$class), x = "topleft", 
col = colors, title = "Classes",
       lwd = 5, bty = "n")
```
##### Guardar Raster de la clasificacion
```r
writeRaster(supervised$map,"SuperClass_RF.tif",driver="GeoTiff")
```
#### Script N°7 "Lidar"
##### Instalar y activar librería "gstat" y "lidR"
```r
install.packages("gstat")
install.packages("lidR")
library (gstat)
library (lidR)
```r
##### crear un modelo de terreno digital (MDT) a partir de un conjunto de puntos terrestres utilizando diferentes métodos de interpolación
```r
LASfile <- system.file("extdata", "Megaplot.laz", package="lidR")
lidar = readLAS(LASfile)
plot(lidar)
```r
##### Método para crear MDT
```r
dtm1 = grid_terrain(lidar, algorithm = tin(), res = 0.5)
```r
##### Ploteado 3D
```r
plot(dtm1)
plot_dtm3d(dtm1)
```r
##### Crear "canopy surface model"
```r
dsm1 <- grid_canopy(lidar, res = 0.5, pitfree(c(0,2,5,10,15), c(0, 1.5)))
plot(dsm1)
```r
