PP_CC_95 <- c(1.8, 38.3, 35.7, 31.8, 30.7, 40.9, 61.5, 19.1, 5.2 ,13.1, 0, 0)
names(PP_CC_95) =  c("enero", "febrero", "marzo", "abril", "mayo", "junio", 
                     "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre")
PP_CC_95

plot(PP_CC_95)

plot(PP_CC_95, pch=19, cex=2, col="#00ff0060")
