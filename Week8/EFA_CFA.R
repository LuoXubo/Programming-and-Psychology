options(digits=2)
library(psych)
covariances <- ability.cov$cov
correlations <- cov2cor(covariances)
correlations
KMO(correlations)

fa.parallel(correlations, n.obs=112, fa="both", n.iter=100,
            main="Scree plots with parallel analysis")
fa <- fa(correlations, nfactors=2, rotate="none", fm="pa")
fa

fa.varimax <- fa(correlations, nfactors=2, rotate="varimax", fm="pa")
fa.varimax

fa.promax <- fa(correlations, nfactors=2, rotate="promax", fm="pa")
fa.promax

factor.plot(fa.promax, labels=rownames(fa.promax$loadings))

fa.diagram(fa.promax, simple=FALSE)



library(lavaan)
data("HolzingerSwineford1939")
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
               speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
summary(fit,fit.measures=T)
fitmeasures(fit,c("chisq","df","cfi","pvalue","tli","rmsea"),output = "matrix")