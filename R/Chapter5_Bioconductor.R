r <- rnorm(10000, mean = 2000, sd = 50)
g <- rnorm(10000, mean = 1000, sd = 50)
r2 <- rnorm(10000, mean = 200, sd = 50)
g2 <- rnorm(10000, mean = 100, sd = 50)
ratio <- r2/g2
ratio <- ratio[ratio>0 & ratio<6]
par(mfrow = c(2, 2))
hist(r/g, breaks = 33)
hist(ratio, breaks = 33)
hist(log2(r/g), breaks = 33)
hist(log2(r2/g2), breaks = 33, col = "azure")

library(vsn)
data(kidney)
library(CCl4)
data("CCl4")
selArrays <- with(pData(CCl4),
     (Cy3 == "CCl4" & RIN.Cy3 > 9) |
     (Cy5 == "CCl4" & RIN.Cy5 > 9))
selFeatures <- !is.na(featureData(CCl4)$ID)
CCl4s <- CCl4[selFeatures, selArrays]
exprs(kidney)
par(mfrow = c(1, 1))

plty <- 1
pcol <- c("green1", "red3")
multidensity(exprs(kidney), xlim = c(-200, 1000), lty = c(1,2), col = pcol, lwd = 2)
abline(v=0)
multidensity(cbind(assayData(CCl4s)$G[, 1],assayData(CCl4s)$R[, 1]),
             lty = c(1,2), col = pcol, lwd = 2, xlim = c(0, 200), legend = F)
legend(x = "topright", legend = c("green", "red"), lty = c(1,2), col = pcol, lwd = 2)

px <- seq(-100, 500, length=50)
f <- function(x, b) log2(x+b)
h <- function(x, a) log2((x+sqrt(x^2+a^2))/2)
matplot(x=px, y = cbind(h(px, 50), f(px, 50)), type = "l", lty=1:2, ylab = "h, f")
log2(1e8+50)
abline(h=log2(1e8+50))

plot(assayData(CCl4)$R[, 1], assayData(CCl4)$G[, 1], col = "grey", pch = ".",
     xlim = c(30, 300), ylim = c(30, 300), asp=1)
abline(0, 1, lty = 2, col = "blue", lwd = 3)
abline(18, 1.2, lty = 3, col = "red", lwd = 3)

CCl4sn <- justvsn(CCl4s, backgroundsubtract=TRUE)
r <- assayData(CCl4svn)$R
g <- assayData(CCl4svn)$G
meanSdPlot(cbind(r, g), ylim=c(0,1.4))
asd <- assayData(CCl4svn)
A <- (asd$R+asd$G)/2
M <- asd$R-asd$G
par(mfrow=c(1,2))
qplot(A[, 6], M[, 6], asp=1, xlab="A", ylab="M", alpha=I(0.005))
plot(A[, 6], M[, 6], asp=1, xlab="A", ylab="M", pch=".")
abline(h=0, col="blue")
smoothScatter(A[, 6], M[, 6], asp=1, nrpoints = 100, xlab="A", ylab="M")
abline(h=0, col="blue")


colors <- brewer.pal(6, "Accent")
par(xpd=F)
multidensity(M, xlim=c(-2,2), ylim=c(0.05,1.3), col = colors, lwd = 2, legend = F, bw=.1)
abline(v=0, col="grey")
abline(h=0)
#par(xpd=T)
legend(.53,1.2, legend=colnames(M), fill = colors, cex = .7)

plot(rnorm(50, 2, 2), rnorm(50, 5, 1))
abline(v=0, col="grey")

CCl4vsn = vsn2(CCl4s)
class(CCl4vsn)
coef(CCl4vsn)

exprs(kidney)
kidspike <- kidney
sel <- runif(nrow(kidspike)) < 1/3
delta <- 100 + .4*abs(rowMeans(exprs(kidspike)[sel, ]))
exprs(kidspike)[sel, ] <- exprs(kidspike)[sel, ] + cbind(-delta, +delta)

ltsq <- c(1, 0.8, 0.5)
quantKid <- lapply(ltsq, function(p) vsn2(kidspike, lts.quantile=p))
getMA <- function(x) data.frame(A = rowSums(exprs(x))/2,
                                M = as.vector(diff(t(exprs(x))))
                                )
ma <- lapply(quantKid, getMA)

for (i in seq_along(ma)) {
    ma[[i]]$group <- factor(ifelse(sel, "up", "unchanged"))
    ma[[i]]$lts.quantile <- factor(ltsq[i])
}
ma_all <- do.call("rbind", ma)

library(lattice)
lp <- xyplot(M ~ A | lts.quantile, data=ma_all, group=group, layout = c(1,3),
             pch = ".", ylim = c(-3,3), xlim = c(6,16), auto.key = T,
             panel = function(...){
                 panel.xyplot(...)
                 panel.abline(h=0)
             },
             strip = function(...){
                 strip.default(...,
                               strip.names=T,
                               strip.levels=T)
             })


print(lp)


normctrl <- sample(which(!sel), 100)
sapply(c(kidney, kidspike), nrow)
fit <- vsn2(kidspike[normctrl, ], lts.quantile=1)
vkidctrl <- predict(fit, newdata=kidspike)
ma <- getMA(vkidctrl)
ma$group <- factor("other", levels=c("other", "normilization control"))
ma$group[normctrl] <- "normilization control"

lp <- xyplot(M ~ A, data=ma, group=group,
            pch = 20, ylim = c(-3,3), xlim = c(6,16), auto.key = T,
            panel = function(...){
                panel.xyplot(...)
                panel.abline(h=0)
            },
            strip = function(...){
                strip.default(...,
                              strip.names=T,
                              strip.levels=T)
            })

print(lp)


# single color norm.
esG <- channel(CCl4s, "G")
exprs(esG) <- exprs(esG) - exprs(channel(CCl4s, "Gb"))
vsn_esG <- justvsn(esG)

library(RColorBrewer)
startedlog <- function(x) log2(x+5)
colors <- brewer.pal(6, "Dark2")
par(mfrow = c(1,2))
multiecdf(startedlog(exprs(esG)), col=colors, main="Before Normilization",
          legend = F)
multiecdf(startedlog(exprs(vsn_esG)), col=colors, main="After Normilization",
          legend = F)

getMA <- function(x) data.frame(A = rowSums(exprs(x))/2,
                                M = as.vector(diff(t(exprs(x))))
)
par(mfrow=c(1,1))
smoothScatter(getMA(vsn_esG[, 1:2]))
abline(h=0)


# The interpretation of glog-ratios
head(exprs(kidney))
g <- exprs(kidney)[, "green"]
r <- exprs(kidney)[, "red"]
Aspike <- 2^seq(2, 16, by=.5)
sel <- sample(nrow(kidney), length(Aspike))
r[sel] <- Aspike*sqrt(2)
g[sel] <- Aspike/sqrt(2)

A <- (log2(r) + log2(g))/2
M.naive <- log2(r) - log2(g)
fit <- vsn2(cbind(g, r))
M.vsn <- exprs(fit)[, 2] - exprs(fit)[, 1]

plot(A, M.naive, pch=20, col = "grey", ylim=c(-3, 3), xlim=c(2,16))
points(A, M.vsn, pch=20, col = "mistyrose")
lines(A[sel], M.naive[sel], lwd=2, lty=2)
lines(A[sel], M.vsn[sel], lwd=2, col="red")

# Reference normalization
ref <- vsn2(CCl4s[, 1:5], backgroundsubtract=T)
x6 <- justvsn(CCl4s[, 6], reference = ref, backgroundsubtract=T)

plot(assayData(x6)$G, assayData(CCl4sn)$G[, 6], asp=1)
abline(0, 1, col="red")
