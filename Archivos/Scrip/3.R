install.packages("raster")
library(raster)


Italia <- getData("GADM", country="ITA", level=2)
plot(Italia)

prec <- getData("worldclim", var="prec", res=.5, lon=10, lat=51)
plot(prec)

prec_ita1 <- crop(prec, Italia)
spplot(prec_ita1)

prec_ita2 <- mask(prec_ita1, Italia)
spplot(prec_ita2)

