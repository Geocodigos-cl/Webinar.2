#Cargar Librer?as
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
setwd("C:/Users/Catalina/Desktop/Archivos Webinar/SuperClass")

################################################################################################

#Cargar las imagenes raster de 20 metros
B11_20 <- raster("B11_20m.jp2")
B12_20 <- raster("B12_20m.jp2")

#Convertir raster de 20metros de pixel a 10metros de pixel
B11_10m <- disaggregate(B11_20, fact=2) #Reducir de 20metros a 10metros la resoluci?n de pixel

writeRaster(B11_10m,"B11_10m.tif",driver="GeoTiff") #Guardar nuevo raster

B12_10m <- disaggregate(B12_20, fact=2) #Reducir de 20metros a 10metros la resoluci?n de pix

writeRaster(B12_10m,"B12_10m.tif",driver="GeoTiff")#Guardar nuevo raster

################################################################################################

#Cargar bandas 
B2 <- raster("B02_10m.jp2")
B3 <- raster("B03_10m.jp2")
B4 <- raster("B04_10m.jp2")
B8 <- raster("B08_10m.jp2")
B11 <- raster("B11_10m.tif")
B12 <- raster("B12_10m.tif")

#Leer Shapefile del ?rea de estudio 
AEstudio <- readShapeSpatial("AreaEstudio.shp")
plot(AEstudio)

#Cortar Raster
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

#Uni?n y asignaci?n de nombres a las bandas
Bandas <-stack(CorteB2, CorteB3, CorteB4, CorteB8, CorteB11, CorteB12)
names(Bandas)<- c("Blue", "Green", "Red", "NIR", "Swir1", "Swir2")

plot(Bandas)

#guardar raster de bandas
writeRaster(Bandas,"Bandas.tif",driver="GeoTiff")

################################################################################################

#C?lculo del NDVI (NIR - R)/(NIR + R)
nir <- Bandas$NIR # Infrarojo cercano
red <- Bandas$Red # Rojo

ndvi <- (nir-red)/(nir+red) #NDVI
ndvi[ndvi>1] <- 1; ndvi[ndvi< (-1)] <- -1 #Reescalado para evitar outliers

names(ndvi) <- "NDVI"

#Visualizaci?n NDVI guardada en el objeto ndvi_plot
ndvi_plot <- ggR(ndvi, geom_raster = TRUE,alpha = 1)+
  scale_fill_gradientn(colours = rev(terrain.colors(100)), 
                       name = "NDVI") + 
  theme(legend.positio = "bottom")


#Visualizaci?n falso color guardada en el objecto falso_color
falso_color_ndvi <- ggRGB(Bandas, r= "NIR" , g="Green" , b="Blue",
                          stretch = "lin")

#Representaci?n final
grid.arrange(ndvi_plot, falso_color_ndvi, ncol=2)


writeRaster(ndvi,"NDVI.tif",driver="GeoTiff")

################################################################################################

#Cálculo del NDBI (SWIR1 - NIR)/(SWIR1 + NIR)
nir <- Bandas$NIR # Infrarojo cercano
swir1 <- Bandas$Swir1 # Swir1

ndbi <- (swir1-nir)/(swir1+nir) #NBDI
ndbi[ui>1] <- 1; ndbi[ndbi< (-1)] <- -1 #Reescalado para evitar outliers

names(ndbi) <- "NDBI"

#Visualización NDBI guardada en el objeto ndwi_plot
ndbi_plot <- ggR(ndbi, geom_raster = TRUE,alpha = 1)+
  scale_fill_gradientn(colours = rev(terrain.colors(100)), 
                       name = "NDBI") + 
  theme(legend.positio = "bottom")


#Visualización falso color guardada en el objecto falso_color
falso_color_ndbi <- ggRGB(Bandas, r= "NIR" , g="Green" , b="Blue",
                          stretch = "lin")

#Representación final
grid.arrange(ndbi_plot, falso_color_ndbi, ncol=2)


writeRaster(ndbi,"NDBI.tif",driver="GeoTiff")

################################################################################################

#Uni?n de bandas espectrales con los ?ndices
Bandas2 <- stack(Bandas,ndvi,ndbi)
writeRaster(Bandas2,"Bandas_indices.tif",driver="GeoTiff")

################################################################################################

#Cargar raster con las bandas e ?ndices
sentinel<- stack("Bandas_indices.tif")
#plot(sentinel)

#Cargar shapefile con los pol?gonos de control
train <-readOGR("PControl.shp")
plot(train)
train
names(train)

################################################################################################

#Desagrupar y Seleccionar la muestra aleatoria de los pol?gonos de control por cada categor?a
AU <- subset(train, Tipo == "Zona construida")
AU <- subset(AU[1:5,], Tipo == "Zona construida") #5 del total de los pol?gonos sera?n considerados

VG <- subset(train, Tipo == "Area verde")
VG <- subset(VG[1:5,], Tipo == "Area verde") #5 del total de los pol?gonos sera?n considerados

SN <- subset(train, Tipo == "Suelo desnudo")
SN <- subset(SN[1:5,], Tipo == "Suelo desnudo") #5 del total de los pol?gonos sera?n considerados

CA <- subset(train, Tipo == "Cuerpo de agua")
CA <- subset(CA[1:5,], Tipo == "Cuerpo de agua") #5 del total de los pol?gonos sera?n considerados

#Volver a juntar los pol?gonos de cada categor?a
train <- bind(CA,SN,VG,AU)
train

################################################################################################

#Generar clasificaci?n supervisada con MLC
beginCluster() 

supervised <- superClass(sentinel, trainData = train, polygonBasedCV = T, nSamples = 3015, minDist = 1,
                         responseCol = "Tipo", model="mlc", trainPartition = 0.80, 
                         kfold = 4, verbose = T, mode = "classification", predict = TRUE) 

endCluster()


#Crear confusion matrix 
getValidation(supervised, metrics = "caret")

################################################################################################


#Asigar colores a las clasificaciones
colors <- c("green","cyan", "chocolate4", "azure3")
#plot(supervised$map)

#Plotear
plot(supervised$map, col = colors, legend = FALSE)
legend(as.character(supervised$classMapping$class), x = "topleft", col = colors, title = "Classes",
       lwd = 5, bty = "n")


#Guardar Raster
writeRaster(supervised$map,"SuperClass_RF.tif",driver="GeoTiff")
