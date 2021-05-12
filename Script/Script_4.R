#Instslar y activar libreria
install.packages("raster")
library(raster)

#Crear matrices
m1 <- matrix(c(1,1,2,2,1,1,2,2,1,1,3,3),ncol=4,nrow=3,byrow=TRUE)
print(m1)

m2 <- matrix(c(1,2,3,4,2,NA,2,2,3,4,3,1),ncol=4,nrow=3,byrow=TRUE)
print(m2)

#Crear raster
r1 <- raster(m1)
r2 <- raster(m2)

#Extencion de localizacion (xmin, xmax, ymin, ymax)
extent(r1) <- extent(r2) <- extent(c(0,4,0,3))

#Asignar colores y plotear
colortable(r1) <- c("lightblue","purple","lightgreen", "pink", "orange")
plot(r1,axes=TRUE)

colortable(r2) <- c("lightblue","purple","lightgreen", "pink", "orange")
plot(r2,axes=TRUE)

#Propiedades del raster
res(r1)
res(r2)

#?lgebra de mapas
sum1 <- r1 + 2; print(as.matrix(sum1))
sum2 <- r1 + 2*r2 ;print(as.matrix(sum2))

#Crear matriz
m3 <- matrix(c(1,3,5,5,5,4,5,1,5,1,2,5),ncol=4,nrow=3,byrow=TRUE)
print(m3)

#Crear raster
r3 <- raster(m3)

#Extencion de localizacion (xmin, xmax, ymin, ymax)
extent(r3) <- extent(c(0,4,3,6))
mosaico <- merge(r1,r3)
extent(mosaico)
plot(mosaico)

