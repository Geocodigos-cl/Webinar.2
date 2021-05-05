library (gstat)
library (lidR)


# function to create a digital terrain model from a set of ground points using different interpolation methods
LASfile <- system.file("extdata", "Megaplot.laz", package="lidR")
lidar = readLAS(LASfile)
plot(lidar)

# We should define the method to create the dtm
dtm1 = grid_terrain(lidar, algorithm =  knnidw(k = 6, p = 2), res = 0.5)
dtm2 = grid_terrain(lidar, algorithm = tin(), res = 0.5)
dtm3 = grid_terrain(lidar, algorithm = kriging (k = 10), res = 0.5)   # takes very long
## Not run:
plot(dtm1)
plot(dtm2)
plot(dtm3)
plot_dtm3d(dtm1)
plot_dtm3d(dtm2)
plot_dtm3d(dtm3)
#######################################################################################################
# the function to Create a canopy surface model (i.e. canopz height model, CHM) using a point cloud. For each pixel the function returns
#the highest point found (point-to-raster)

#LASfile <- system.file("extdata", "Megaplot.laz", package="lidR")
#lidar = readLAS(LASfile)
# Local maximum algorithm with a resolution of 2 meters
dsm1 <- grid_canopy(lidar, res = 0.5, pitfree(c(0,2,5,10,15), c(0, 1.5)))
plot(dsm1)

# Basic triangulation and rasterization of first returns
dsm2 <- grid_canopy(lidar, res = 0.5, dsmtin())
plot(dsm2)

# Points-to-raster algorithm with a resolution of 0.5 meters replacing each
# point by a 20-cm radius circle of 8 points
dsm3 <- grid_canopy(lidar, res = 0.5, p2r(0.2))
plot(dsm3)

## calculating a CHM out of DTM and DSM

chm1<- dsm1 - dtm1
chm2<- dsm2 - dtm2
chm3<- dsm3 - dtm2 # /dtm1, no difference here

plot(chm1)
plot(chm2)
plot(chm3)

# and so on... not use dtm3 due to calculation time

## ForestTools package example (https://cran.r-project.org/web/packages/ForestTools/vignettes/treetopAnalysis.html)

#install.packages("ForestTools")
library(ForestTools)
library(raster)

## Detecting tree tops using a moving window filter to find the highest points for each cell

# defining variable moving window function 

lin <- function(x){x * 0.02 + 0.6}

# calculating the treetops with a minimum height of 2 and the predefined moving window options

ttops <- vwf(CHM = chm, winFun = lin, minHeight = 2)

# view the result

plot(chm)
plot(ttops, col = "blue", pch = 20, cex = 0.5, add = TRUE)

# get mean treetop height

mean(ttops$height)

## outlining tree crowns

crowns <- mcws(treetops = ttops, CHM = chm, minHeight = 1.5, verbose = FALSE, format = "raster")
plot(crowns, col = sample(rainbow(50), length(unique(crowns[])), add = TRUE))

# optionally: set format = "polygons" to get a shapefile output with corresponding height and crown area information 
# Caution: Takes much longer to process and requires more disk space

crownsPoly <- mcws(treetops = ttops, CHM = chm, format = "polygons", minHeight = 1.5, verbose = FALSE)
plot(chm)
plot(crownsPoly, border = "blue", lwd = 0.5, add = TRUE)


## compute average circular diameter of the crowns
## assuming that each crown has a roughly circular shape

crownsPoly[["crownDiameter"]] <- sqrt(crownsPoly[["crownArea"]]/ pi) * 2
mean(crownsPoly$crownDiameter)

## statistics

sp_summarise(ttops)

sp_summarise(crownsPoly, variables = c("crownArea", "height"))