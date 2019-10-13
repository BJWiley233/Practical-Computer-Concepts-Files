library(swirl)
install_from_swirl("Statistical Inference")
swirl()
require(data.table)
d1 <- data.table(x=letters[1:5], start=c(1,5,19,30,7), end=c(3,11,22,39,25))
d1
d2 <- data.table(x=letters[6:11],start=c(1.5,21.8,70,24,32,25), end=c(2.5,23,73,26,37,60))
d2
setkey(d1, start, end)
foverlaps(d2, d1, type = "any", mult = "all", nomatch = 0L)
?foverlaps
length(names(d2))
names(d2[,2:3, with = FALSE])
names(d2[2])
test<- as.data.frame(d2)
names(test)
names(test[2:3])

knownGene <- data.table(read.table("~/Human__knownGene.bed",header = FALSE, sep="\t",stringsAsFactors=FALSE))
#knownGene <- read.table("~/Human__knownGene.bed",header = FALSE, sep="\t",stringsAsFactors=FALSE)
head(knownGene)
nrow(knownGene)
nrow(repeats)
names(knownGene) <- c("chr", "start", "end", "name", "score", "strand")
?read.table
repeats <- data.table(read.table("~/repeats.bed",header = FALSE, sep="\t",stringsAsFactors=FALSE, col.names = c("chr", "start", "end", "name", "score", "strand")))
head(repeats)
setkey(knownGene, start, end)
join <- foverlaps(repeats, knownGene, type = "any", mult = "all", nomatch = 0L)
length(unique(join$name))
class(repeats)
require(dplyr)
head(join)
joinCount <- join %>%
        group_by(name) %>%
        summarise(n = n())
nrow(joinCount)
library(sqldf)
sf3 <- sqldf("SELECT DISTINCT j1.name as Name,j1.chr as Chromosome,j1.start as Start_Position,j1.end as End_Position,jc.n as Count
                FROM join1 j1
                LEFT JOIN joinCount jc USING(name)
                ORDER BY jc.n DESC")
head(sf3, n = 12)
unique(join1$name)
nrow(sf3)
left_join(join1, joinCount, by = "name") %>% 
        select(name, chr, start, end, n) %>% 
        distinct(name, .keep_all = TRUE) %>% 
        arrange(desc(n))
?arrange
dice_high*c(1,2,3,4,5,6)

mean(rlnorm(1000000,30,1))
exp(30.5)
a <- rlnorm(1000000,7,1)
mean(log(a))        
exp(mean(log(a)))
exp(7)

large <- rbinom(n=10,size = 1, p = .7)
phat<- mean(large)
phat
?qt
qt(.975,phat)
?rep

head(large)

a <- matrix(rbinom(10,1,.7)
mean(a)
?sapply()
?replicate()
nrep <- 10000
n <- 5000
b <- matrix(rbinom(n*nrep,1,.7), ncol = n, nrow = nrep)
means <- apply(b,1,mean)
phat <- mean(means)
int <- BinomCI(phat*n,n,.95, method = "wald")
sum(in.interval.lo(means,int[2],int[3]))/nrep
phat + c(-1,1)*qt(.975,n-1)*sqrt(phat*(1-phat)/n)

?BinomCI
?foverlaps
(5+5+4+6+2)/5
(5*5*5*6*2)^(1/5)

c <- c(5,5,4,6,2)
exp(sum(log(c))/5+.5)

?BinomCI
install.packages("DescTools")
library(DescTools)

BinomCI(7,10,.95, method = "wald")

install.packages("kimisc")
require(kimisc)
product(rlnorm(5,1))
mean(log(rlnorm(100,5,1)))
exp(mean(log(rlnorm(1000000,5,2))))
exp(5)
mean(rlnorm(1000000,5,2))
exp(5+2^2/2)

install.packages("plot3D")
require(plot3D)
arrows3D(x0 = c(0,0), y0 = c(0,0), z0 = c(0,0),
         x1 = c(1,2), y1 = c(4,8), z1 = c(3,6), colvar = 1:2, main = "arrows3D", ticktype = "detailed", colkey = FALSE, xlim = c(0,20), ylim = c(0,20), zlim = c(0,20))
#scale = TRUE, 
?arrows3D
par(mar = c(1,1,1,1))


library(purrr)

map_chr(c(5, 4, 3, 2, 1), function(x){
        c("one", "two", "three", "four", "five")[x]
})
c("one", "two", "three", "four", "five")[5]
