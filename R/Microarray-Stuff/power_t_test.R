data("mtcars")

mtcars

attach(mtcars)
mpg
detach(mtcars)

g1 <- c(0.340, 0.232, 0.760, 0.610, 0.224)
g2 <- c(0.238, 0.075, 0.624, 0.978, 0.198)

test = t.test(g1, g2, alternative="two.sided")
test$p.value
var1 = var(g1)
var2 = var(g2)
n1 = length(g1)
n2 = length(g2)
sp = sqrt(((n1-1)*var1+(n2-1)*var2)/(n1+n2-2))

power.t.test(n=5, delta = mean(g2)-mean(g1),
             sd = sp,
             type = "two.sample", sig.level = 0.10,
             alternative = "two.sided")

power.t.test(n=5, delta = (mean(g2)-mean(g1))/sp,
             type = "two.sample", sig.level = 0.10,
             alternative = "two.sided")

set.seed(100)
ngenes = 10000
ncases = 10
row_names = paste("g", 1:ngenes, sep = "")
col_names = c(paste("T", 1:ncases, sep = ""), 
             paste("C", 1:ncases, sep = ""))
l = list(row_names, col_names)
data = matrix(rnorm(ngenes*2*ncases), nrow=ngenes, ncol=ncases*2,
              dimnames=l)
labels = c(rep("tumor", ncases), rep("control", ncases))
mytest = function(x) {
  tumors = x[labels=="tumor"]
  controls = x[labels=="control"]
  p = t.test(tumors, controls, var.equal = T)$p.value
  foldchange = mean(tumors)-mean(controls)
  return(c(foldchange, p))
}
results = t(apply(data, 1, mytest))
colnames(results) = c("logFC", "p")
results <- results[order(results[,"p"]), ]
sum(results[, "p"]<.001)
sum(results[, "p"]<.01)
sum(results[, "p"]<.1)

prob_wrong <- function(p, R) {
  1-(1-p)^R
}
prob_wrong(.01, 10)
colors()[552]

# test = rnorm(10)
# z_scores = (test-mean(test))/sd(test)
# rms_z = sqrt(sum(z_scores**2)/length(z_scores))
# plot(z_scores)
# plot(density(test))
# pdf(test)
# dev.off()
# hist(test, freq = FALSE)
# curve(dnorm,-5,5,add=T,col="blue")
# w<-rnorm(1000) 
# hist(w,col="red",freq=F,xlim=c(-5,5))
# curve(dnorm,-5,5,add=T,col="blue")

library(ALL)
data("ALL")
bio = which(ALL$mol.biol %in% c("BCR/ABL", "NEG"))
isB = grep("^B", ALL$BT)
bcell_fusion = ALL[, intersect(bio, isB)]   

#BiocManager::install("MLInterfaces")

library(c)

set.seed(1234)
smp = sample(1:ncol(bcell_fusion), size = 50)
dim(bcell_fusion)
dim(bcell_fusion[1:4000, ])
nn1 = MLearn(mol.biol~., bcell_fusion[1:2000, ], nnetI, 
             trainInd=smp, size=5, maxit=100, decay=0.01,
             MaxNWts=63136)
confuMat(nn1)

ggg = MLearn(mol.biol~., bcell_fusion[1:2000, ],  
             BgbmI(n.trees.pred=25000,thresh=.5), 
             trainInd=smp, n.trees=25000)
confuMat(ggg)
library(hgu95av2)
par(las=2, mar=c(6,9,5,5))
plot(getVarImp(ggg))
ggg@testPredictions
acc(confuMat(ggg))
17/29
MLInterfaces::Predict()
pred <- predict(nn1, bcell_fusion[1:2000, -smp])
table(pred$testPredictions)

?pnorm
2 * pnorm(0.84, lower.tail = F)

2 * pnorm(abs(-1.96), lower.tail = F)
qnorm(1-.025)
qnorm(.95)

choose(1391, 3)
