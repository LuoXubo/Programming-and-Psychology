####Moderation analysis####
##generate data####
N  <- 100 
X  <- abs(rnorm(N, 6, 4)) 
X1 <- abs(rnorm(N, 60, 30)) 
Z  <- rnorm(N, 30, 8) 
Y  <- abs((-0.8*X) * (0.2*Z) - 0.5*X - 0.4*X1 + 10 + rnorm(N, 0, 3)) 
Moddata <- data.frame(X, X1, Z, Y)

##standardize data####
Xc    <- c(scale(X, center=TRUE, scale=FALSE)) #Centering IV; 
Zc    <- c(scale(Z,  center=TRUE, scale=FALSE))

##regression analysis####
fitMod <- lm(Y ~ Xc + Zc + Xc*Zc)
summary(fitMod)

##plot figure####
library(interactions)
interact_plot(fitMod,pred = Xc,modx = Zc,plot.points = FALSE,interval = TRUE)


####Mediation analysis####
##generate data####
N <- 100 #
X <- rnorm(N, 175, 7) 
M <- 0.7*X + rnorm(N, 0, 5) 
Y <- 0.4*M + rnorm(N, 0, 5) 
Meddata <- data.frame(X, M, Y)

#1. 总效应
fit <- lm(Y ~ X, data=Meddata)
summary(fit)
#2. 路径a
fita <- lm(M ~ X, data=Meddata)
summary(fita)
#3. 路径b
fitb <- lm(Y ~ M + X, data=Meddata)
summary(fitb)

library(multilevel)
library(bda)
#Sobel test
mediation.test(M,X,Y)

library(mediation)

fitM <- lm(M ~ X,     data=Meddata) 
fitY <- lm(Y ~ X + M, data=Meddata) 

###ACME stands for average causal mediation effects(indirect effect:a*b);
####ADE stands for average direct effects (c');Total effect:c
fitMed <- mediate(fitM, fitY, treat="X", mediator="M",sims = 5000,boot = T)
summary(fitMed)
plot(fitMed)

