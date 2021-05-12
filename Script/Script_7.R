# Instalar y activar librerías
install.packages("gstat")
install.packages("lidR")
library (gstat)
library (lidR)

# crear un modelo de terreno digital (MDT) a partir de un conjunto de puntos terrestres utilizando diferentes métodos de interpolación
LASfile <- system.file("extdata", "Megaplot.laz", package="lidR")
lidar = readLAS(LASfile)
plot(lidar)

#Método para crear MDT
dtm1 = grid_terrain(lidar, algorithm = tin(), res = 0.5)

#Ploteado 3D
plot(dtm1)
plot_dtm3d(dtm1)

#Crear "canopy surface model"
dsm1 <- grid_canopy(lidar, res = 0.5, pitfree(c(0,2,5,10,15), c(0, 1.5)))
plot(dsm1)


