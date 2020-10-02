Lab4\_Brian\_Wiley
================





#### Brian Wiley

### Lab 4: Normalization and Bioconductor

### AS.410.671.81.FA20 Gene Expression Data Analysis and Visualization

Links to question: [1.](#q1) [2.](#q2) [3.](#q3) [4.](#q4) [5.](#q5)
[6.](#q6) [7.](#q7) [8.](#q8) [9.](#q9) [10.](#q10) [11.](#q11)
[12.](#q12) [13.](#q13) [14.](#q14) [Bonus](#Bonus)

#### Summary

In this lab, we will be working with a few data sets, each run on a
different platform. The first data set is an R object generated from a
2-channel cDNA array that is called swirl. This data set is an
experiment that was run on a zebrafish to study the early development.
The data is named such because “swirl is a point mutant in the BMP2 gene
that affects the dorsal/ventral body axis.” The objective of the
experiment was to evaluate the transcript differences between wildtype
zebrafish and those with this mutation. As I mentioned above, swirl is
an R object, so the format and structure of this binary file has to be
accessed through various R functions. If you type “swirl”, you will
immediately see that there are attributes that make up this file (e.g.
@maInfo) beyond the typical channel information. Included is metadata
information that makes up the experimental parameters, in addition to
the raw intensity data. \*\* Found out its really
`swirl@maGnames@maInfo` or `swirl@maTargets@maInfo`.

The second 2 data sets are raw intensity files – one from an Agilent
platform and the other from an Affymetrix platform. Both of these files
are on the course website. These are not R objects, rather the Agilent
files are raw text files generated from the Agilent software and the
Affymetrix files are raw binary files generated from the Affymetrix
software.

Since both R objects and raw data files are typically what an analyst is
given when asked to analyze an experiment, this lab will give you
experience processing raw intensity files and normalizing them
appropriately. This is typically the first step in conducting any
microarray analysis, so it is important to make sure that the data is
normalized appropriately before beginning any subsequent
steps.

##### **1). Load the marray library and the swirl data set. This data set is an R metadata object, so there are multiple pieces of information (e.g., red/green background and foreground intensities, chip layout design, etc.) that are stored in this R data object.**

``` r
## load
library(marray)
```

    ## Loading required package: limma

``` r
data(swirl)
```

##### **2.) Plot an MvA plot of array 3 without any stratified lines.**

``` r
par(mfrow=c(1,1))

## just want to confirm formula matches maPlot
A = log2(sqrt((swirl@maRf[, 3]-swirl@maRb[, 3])*(swirl@maGf[, 3]-swirl@maGb[, 3])))
M = log2((swirl@maRf[, 3]-swirl@maRb[, 3])/(swirl@maGf[, 3]-swirl@maGb[, 3]))

#plot(A, M, pch=19, cex=0.7)
#plot(maA(swirl[, 3]), maM(swirl[, 3]), pch=19, cex=0.7)
maPlot(swirl[, 3], main='MvA Non-normalized Swirl Array #3', 
       legend.func = NULL, lines.func = NULL)
```

![](README_figs/README-unnamed-chunk-2-1.png)<!-- -->

##### **3.) Normalize array 3 by global median location normalization.**

``` r
## norm   Character string specifying the normalization procedures:
## This argument can be specified using the first letter of each method.
## maNorm calls switch function with maNormMain and the norm type 
mnorm3 <- maNorm(mbatch=swirl[, 3], norm="m")
class(mnorm3)
```

    ## [1] "marrayNorm"
    ## attr(,"package")
    ## [1] "marray"

##### **4.) Plot an MvA plot of the normalized array without the stratified lines or legend.**

``` r
## maPlot does maA call for x axis and maM call for y axis
## for maA: i.e as.numeric(eval(call("maA", m)))
## for maM: i.e as.numeric(eval(call("maM", m)))
## maPlot(m, x="maA", y="maM", z="maPrintTip", ...
## m  Microarray object of class "marrayRaw" and "marrayNorm".
maPlot(m=mnorm3, main='MvA Median normalized Swirl Array #3', 
       legend.func = NULL, lines.func = NULL)
```

![](README_figs/README-unnamed-chunk-4-1.png)<!-- -->

##### **5.) What is difference between the normalized data and the non-normalized data?**

The distribution of the dye intensity ratio of red to green (R/G) is
centered more at 0 (`log2(1)` where R would equal G) where “half”
(estimating looks about half) of the log2 ratios are above 0 (R \> G, or
ratio greater than 1) and “half” are below 0 (R \< G, or ratio less than
1).

``` r
par(mfrow=c(1, 2))
maPlot(m=swirl[, 3], main='MvA Non-normalized\nSwirl Array #3', 
       legend.func = NULL, lines.func = NULL)
maPlot(m=mnorm3, main='MvA Median normalized\nSwirl Array #3', 
       legend.func = NULL, lines.func = NULL)
```

![](README_figs/README-unnamed-chunk-5-1.png)<!-- -->

##### **6.) Repeat \#3 and \#4 applying loess global intensity normalization.**

``` r
lnorm3 <- maNorm(mbatch=swirl[, 3], norm="l")
maPlot(m=lnorm3, main='MvA Loess normalized Swirl Array #3', 
       legend.func = NULL, lines.func = NULL)
```

![](README_figs/README-unnamed-chunk-6-1.png)<!-- -->

##### **7.) Which of the two normalizations appears to be better for this array?**

I don’t think one normalization technique is better than the other. Both
look split between half R \> G and half R \< G. The global median
location normalization has a total sum for M that is slightly higher
than the loess normalization.

``` r
par(mfrow=c(1, 3))
maPlot(m=swirl[, 3], main='MvA Non-normalized\nSwirl Array #3', 
       legend.func = NULL)
maPlot(m=mnorm3, main='MvA Median normalized\nSwirl Array #3', 
       legend.func = NULL, col.main="blue")
maPlot(m=lnorm3, main='MvA Loess normalized\nSwirl Array #3', 
       legend.func = NULL, col.main="red")
```

![](README_figs/README-unnamed-chunk-7-1.png)<!-- -->

``` r
sum(maM(mnorm3))
```

    ## [1] 309.963

``` r
sum(maM(lnorm3))
```

    ## [1] 313.93

##### **8.) Now we would like to read in raw GenePix files for 2 cDNA arrays that represent 2 patient samples. Go to the course website and retrieve the compressed file called ‘GenePix files’. Open it up and put the contents in a directory. Now using the sample code below, read in the 2 array files.**

`> dir.path <- "C:\\Documents and Settings\\higgsb\\Desktop\\"` `>
a.cdna <- read.GenePix(path=dir.path,name.Gf = "F532 Median",name.Gb
="B532 Median", name.Rf = "F635 Median", name.Rb = "B635 Median",name.W
="Flags")`

``` r
## set path in initial r setup chunk so don't need here
## found out from old code from 'sma' package
## Usage
##    sma::read.genepix(name, dir = ".", sep = "\t", header = T, skip = 26 ...
## you need to skip all the lines until you get to the header lines whic is 29
## marray should have documented this
a.cdna <- read.GenePix(fnames=c("patient1.gpr", "patient2.gpr"),
                       path="/home/coyote/JHU_Fall_2020/Data_Analysis/Datasets",
                       name.Gf="F532 Median", name.Gb="B532 Median",
                       name.Rf="F635 Median", name.Rb="B635 Median",
                       name.W="Flags", skip=29)
```

    ## Warning in grep(layout.id["Block"], colnames(dat)): input string 33 is invalid
    ## in this locale

    ## Warning in grep(layout.id["Row"], colnames(dat)): input string 33 is invalid in
    ## this locale

    ## Warning in grep(layout.id["Column"], colnames(dat)): input string 33 is invalid
    ## in this locale

    ## Reading ...  /home/coyote/JHU_Fall_2020/Data_Analysis/Datasets/patient1.gpr 
    ## Reading ...  /home/coyote/JHU_Fall_2020/Data_Analysis/Datasets/patient2.gpr

##### **9.) Using the a.cdna object, which is analogous to the swirl metadata object, normalize both arrays and provide MvA plots for each array normalized by the following 3 methods: no normalization, print-tip loess normalization, and scale print-tip normalization using the MAD. Hint: use the `par(mfrow=c(3,1))` function to put the 3 plots for a single patient array on the same page.**

The non normalization looks better for patient 2 than patient 1,
i.e. patient 2 looks more normal without performing any normalization.
You do see, however, it looks like that for some genes the log R/G
intensity ratios (M) are correlated with the average intensities as
there are some groups of points that are linear. For each of the
normalization methods for each patient it doesn’t look like there is
much better results from one method vs. another.

``` r
## print-tip loess normalization
## does this perform the normalization 1 array at a time?
## Yes, see next chunk when comparing normalizing on
## all (batch) arrays in marrayRaw vs 1 at a time

## print-tip loess normalization
ptl.norm <- maNorm(a.cdna, norm="p")

## scale print-tip normalization using the MAD
sptMAD.norm <- maNorm(a.cdna, norm="s")

## look at both patients side by side
## order: bottom, left, top, and right.
par(mfrow=c(3,2), mar=c(5.1, 4.1, 5.1, 2.1))

maPlot(m=a.cdna[, 1], main='MvA Non-normalized\nPatient #1', 
       legend.func = NULL, lines.func = NULL, cex.main=1.5)
maPlot(m=a.cdna[, 2], main='MvA Non-normalized\nPatient #2', 
       legend.func = NULL, lines.func = NULL, cex.main=1.5)
maPlot(m=ptl.norm[, 1], main='MvA print-tip loess normalization\nPatient #1', 
       legend.func = NULL, lines.func = NULL, cex.main=1.5)
maPlot(m=ptl.norm[, 2], main='MvA print-tip loess normalization\nPatient #2', 
       legend.func = NULL, lines.func = NULL, cex.main=1.5)
maPlot(m=sptMAD.norm[, 1], main='MvA scale print-tip normalization MAD\nPatient #1', 
       legend.func = NULL, lines.func = NULL, cex.main=1.5)
maPlot(m=sptMAD.norm[, 2], main='MvA scale print-tip normalization MAD\nPatient #2', 
       legend.func = NULL, lines.func = NULL, cex.main=1.5)
```

![](README_figs/README-unnamed-chunk-9-1.png)<!-- -->

Just testing if normalization is array independent in marrayRaw objects.

``` r
## this just testing for patient 1
## would normalization in batch object be different
## than 1 array at a time normalization calls

## print-tip loess normalization on single array
ptl.norm.2 <- maNorm(a.cdna[, 2], norm="p")

## scale print-tip normalization using the MAD on single array
sptMAD.norm.2 <- maNorm(a.cdna[, 2], norm="s")

par(mfrow=c(2,2))

maPlot(m=ptl.norm[, 2], main='Both array print-tip loess normalization\nPatient #1', 
       legend.func = NULL, lines.func = NULL)
maPlot(m=ptl.norm.2[, 1], main='Single array print-tip loess normalization\nPatient #1', 
       legend.func = NULL, lines.func = NULL)
maPlot(m=sptMAD.norm[, 2], main='Both array scale print-tip normalization MAD\nPatient #1', 
       legend.func = NULL, lines.func = NULL)
maPlot(m=sptMAD.norm.2[, 1], main='Single array scale print-tip normalization MAD\nPatient #1', 
       legend.func = NULL, lines.func = NULL)
```

![](README_figs/README-unnamed-chunk-10-1.png)<!-- -->

``` r
## looks like the same left vs right for each normalization type
## not dependent on running normalization on each array individually
```

Looks like the same left vs right for each normalization type so you can
do it for all patients/samples/arrays at
once.

##### **10.) Finally, we would like to create a data matrix that can be written out to a file with 19,200 rows and 2 columns (i.e. each patient array). Using the functions `maM()`, `maGnames()`, and `maLabels()`, figure out how to create the data matrix, get the probe IDs, and assign the probe IDs to the row names. Do this for the 2 normalized metadata objects that you created in \#9 above (don’t worry about the unnormalized data matrix).**

A lot of these probe ids are “N/A”. For instance for the one that are
“N/A” but have a name prefix, should we make this the row names? Just
thinking out loud. Example:

`"Row" "Name"` `"F12650:Data not found::::10:33438" "N/A"`

Should the row name be `F12650` instead of `N/A`?

``` r
## matrix print-tip loess normalization
M.matrix.ptl.norm <- as.matrix(maM(ptl.norm))
row.names(M.matrix.ptl.norm) <- maLabels(maGnames(ptl.norm))
colnames(M.matrix.ptl.norm) <- gsub(pattern="\\.gpr$", ".M", basename(colnames(M.matrix.ptl.norm)))
dim(M.matrix.ptl.norm)
```

    ## [1] 19200     2

``` r
head(M.matrix.ptl.norm)
```

    ##          patient1.M patient2.M
    ## 36894   -0.03311015  0.1505862
    ## N/A      0.13049475  0.1713035
    ## 5548382  0.52435894  0.3575525
    ## N/A     -0.78083988 -1.5229202
    ## 29305   -0.49450905 -0.6409908
    ## 28821   -0.83639640 -0.7880698

``` r
## scale print-tip normalization using the MAD
M.matrix.sptMAD.norm <- as.matrix(maM(sptMAD.norm))
row.names(M.matrix.sptMAD.norm) <- maLabels(maGnames(sptMAD.norm))
colnames(M.matrix.sptMAD.norm) <- gsub(pattern="\\.gpr$", ".M", basename(colnames(M.matrix.sptMAD.norm)))
dim(M.matrix.sptMAD.norm)
```

    ## [1] 19200     2

``` r
head(M.matrix.sptMAD.norm)
```

    ##          patient1.M patient2.M
    ## 36894   -0.04261438  0.1453677
    ## N/A      0.16795314  0.1653669
    ## 5548382  0.67487566  0.3451614
    ## N/A     -1.00497921 -1.4701431
    ## 29305   -0.63645739 -0.6187771
    ## 28821   -1.07648317 -0.7607591

``` r
## alternatively put in list
M.norm.data <- list(print.tip.loess.normalization = M.matrix.ptl.norm, 
                     scale.print.tip.normalization.MAD = M.matrix.sptMAD.norm)
lapply(M.norm.data, dim)
```

    ## $print.tip.loess.normalization
    ## [1] 19200     2
    ## 
    ## $scale.print.tip.normalization.MAD
    ## [1] 19200     2

``` r
lapply(M.norm.data, head)
```

    ## $print.tip.loess.normalization
    ##          patient1.M patient2.M
    ## 36894   -0.03311015  0.1505862
    ## N/A      0.13049475  0.1713035
    ## 5548382  0.52435894  0.3575525
    ## N/A     -0.78083988 -1.5229202
    ## 29305   -0.49450905 -0.6409908
    ## 28821   -0.83639640 -0.7880698
    ## 
    ## $scale.print.tip.normalization.MAD
    ##          patient1.M patient2.M
    ## 36894   -0.04261438  0.1453677
    ## N/A      0.16795314  0.1653669
    ## 5548382  0.67487566  0.3451614
    ## N/A     -1.00497921 -1.4701431
    ## 29305   -0.63645739 -0.6187771
    ## 28821   -1.07648317 -0.7607591

##### **11.) Load the following libraries: affy, limma, simpleaffy, affyPLM, and fpc.**

``` r
library(affy)
library(limma)
#BiocManager::install("simpleaffy")
library(simpleaffy)
#BiocManager::install("affyPLM")
library(affyPLM)
library(fpc)
```

##### **12.) Now we would like to read in 3 raw Affymetrix .CEL files and normalize them with 2 different algorithms. These 3 arrays represent 3 normal healthy subjects that should have similar expression profiles. They are on the course website in the compressed file called Affymetrix .CEL files. Use the following code below to read in a metadata object for the 3 arrays (dir.path should be the same as above).**

`> fns <- sort(list.celfiles(path=dir.path,full.names=TRUE))` `>
data.affy <-
ReadAffy(filenames=fns,phenoData=NULL)`

``` r
## again dir.path was set using root.dir = "~/JHU_Fall_2020/Data_Analysis/Datasets"
## in the intial setup chunk
filenames <- list.celfiles(pattern="normal[0-9].CEL", full.names=T)

## Value
##    An AffyBatch object
## affy::rma can only be called on this type of object, not
## ExpressionSet or any other class that extends eSet, i.e
## names(getClass("eSet")@subclasses), rma cannot be called on
## those types of objects
data.affy <- affy::ReadAffy(filenames=filenames, phenoData=NULL)
```

##### **13.) Using the 2 functions: `justMAS()` and `rma()`, in addition to `exprs()`, create the normalized data matrices with 54,675 rows and 3 columns for the 2 different normalization algorithms.**

Just interesting to see rma() runs about twice as fast as justMAS().

``` r
## justMAS() matrix
## Start the clock!
ptm <- proc.time()
## not sure why they are saying Value in ?justMAS
## is an AffyBatch object when it returns an 
## ExpressionSet ojbect like rma. ArrayExpress incorrectly 
## documents this as well for some normalization methods
justMAS.matrix <- as.matrix(exprs(justMAS(data.affy)))
```

    ## Warning: replacing previous import 'AnnotationDbi::tail' by 'utils::tail' when
    ## loading 'hgu133plus2cdf'

    ## Warning: replacing previous import 'AnnotationDbi::head' by 'utils::head' when
    ## loading 'hgu133plus2cdf'

``` r
dim(justMAS.matrix)
```

    ## [1] 54675     3

``` r
head(justMAS.matrix)
```

    ##           normal1.CEL normal2.CEL normal3.CEL
    ## 1007_s_at    6.650203    6.327235    6.706209
    ## 1053_at      6.401678    6.890641    6.821390
    ## 117_at       6.472329    9.352613    9.412042
    ## 121_at       6.659493    6.631289    7.192615
    ## 1255_g_at    4.342176    3.704580    3.412193
    ## 1294_at      8.126401    7.878973    7.901108

``` r
## Stop the clock
print("Time for justMAS() normalization")
```

    ## [1] "Time for justMAS() normalization"

``` r
proc.time() - ptm
```

    ##    user  system elapsed 
    ##  10.807   0.164  10.972

``` r
## rma() matrix
## Start the clock!
ptm <- proc.time()
rma.matrix <- as.matrix(exprs(affy::rma(data.affy)))
```

    ## Background correcting
    ## Normalizing
    ## Calculating Expression

``` r
dim(rma.matrix)
```

    ## [1] 54675     3

``` r
head(rma.matrix)
```

    ##           normal1.CEL normal2.CEL normal3.CEL
    ## 1007_s_at    6.732547    6.772589    6.950047
    ## 1053_at      6.986680    6.986680    6.986680
    ## 117_at       7.334083    9.792765    9.794139
    ## 121_at       7.179351    7.439034    7.677756
    ## 1255_g_at    3.423446    3.423446    3.423446
    ## 1294_at      8.402456    8.402456    8.402456

``` r
## Stop the clock
print("Time for rma() normalization")
```

    ## [1] "Time for rma() normalization"

``` r
proc.time() - ptm
```

    ##    user  system elapsed 
    ##   4.545   0.032   4.586

Seeing what are the densities after normalization. Looks like the
densities with justMAS has median more centered near the mean over rma
normalization but the smoothness and like densities look better for rma.
I am assuming for next question this will result in higher correlation
for rma. Also we can see the mean for justMAS has mean around 5 with
negative values while values for rma are never negative?

``` r
## plot densitites to check normalization
library(reshape2)
library(ggplot2)
library(gridExtra)
library(ggpubr) # for get_legend() function

melted.justMAS.matrix <- melt(justMAS.matrix)
g.justMAS <- ggplot(melted.justMAS.matrix, aes(x=value, fill=Var2)) +
  geom_histogram(aes(y = ..density.., group=Var2, fill=Var2, alpha=0.6), 
                 position="identity",
                 bins=20) +
  stat_density(aes(group=Var2, color=Var2), position="identity", geom="line", show.legend=F) +
  labs(fill="Samples") +
  ggtitle("Normalization with justMAS()") +
  xlab("Intensities") +
  ylab("Density") +
  scale_alpha(guide="none")

melted.rma.matrix <- melt(rma.matrix)
g.rma <- ggplot(melted.rma.matrix, aes(x=value, fill=Var2)) +
  geom_histogram(aes(y = ..density.., group=Var2, fill=Var2, alpha=0.6), 
                 position="identity",
                 bins=20) +
  stat_density(aes(group=Var2, color=Var2), position="identity", geom="line", show.legend=F) +
  labs(fill="Samples") +
  ggtitle("Normalization with rma()") +
  xlab("Intensities") +
  ylab("") +
  theme(legend.position="none") +
  scale_alpha(guide="none")

## get legend https://rpkgs.datanovia.com/ggpubr/reference/get_legend.html
## for some reason fit I call this and grid.arrange in same 
## chunk it give a blank plot first and then the real plot
legend <- get_legend(g.justMAS)

## remove legend from g.justMAS
g.justMAS <- g.justMAS + theme(legend.position="none")

## plot
library(grid)
grid.arrange(g.justMAS, g.rma, legend, ncol=3, widths=c(2.3, 2.3, 0.8))
```

![](README_figs/README-unnamed-chunk-16-1.png)<!-- -->

``` r
min(melted.rma.matrix$value)
```

    ## [1] 2.678663

``` r
#grid.arrange(g.justMAS, g.rma, legend, ncol=3, widths=c(2.3, 2.3, 0.8))
```

##### **14.) Now use the cor() function to calculate the correlation between the 3 arrays for both normalized data matrices. Since these 3 subjects are all healthy normal individuals, we would expect to see somewhat good correlation structure between them all when looking across all genes on the array. Which normalization method has a higher overall correlation structure for these 3 normal healthy subjects? Show how you arrived at this answer.**

The assumption is correct. The densities are all the same for rma as we
saw above. This doesn’t necessarily cause higher correlation because
intensities could be mixed however having similar density functions is
more likely going to be associated with higher correlation than
dissimilar densities, all things else being equal. There is much higher
correlation between samples after rma
normalization.

``` r
## with such little data points might as well do a lower triangular corplot
low.tri <- function(x) {
  x[upper.tri(x)] <- NA
  return(x)
}

## get correlation and melt for ggplot
low.cor.justMAS <- round(low.tri(cor(justMAS.matrix)), 2)
melted.cor.justMAS <- melt(low.cor.justMAS, na.rm=T)

g.cor.justMAS <- ggplot(melted.cor.justMAS, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile(color="white") +
  geom_text(aes(Var1, Var2, label = value), color = "black", size = 4) +
  scale_fill_gradient2(low="yellow", mid="orange", high="red",
                       midpoint=0.75, limit=c(.5,1),
                       name="Pearson\nCorr.") +
  theme(axis.text.x=element_text(angle=45, vjust=0.6),
        axis.title=element_blank(),
        plot.title=element_text(hjust=0.5)) +
  ggtitle("Correlation for Normalization with justMAS()")

## get correlation and melt for ggplot
low.cor.rma <- round(low.tri(cor(rma.matrix)), 2)
melted.cor.rma <- melt(low.cor.rma, na.rm=T)

g.cor.rma <- ggplot(melted.cor.rma, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile(color="white") +
  geom_text(aes(Var1, Var2, label = value), color = "black", size = 4) +
  scale_fill_gradient2(low="yellow", mid="orange", high="red",
                       midpoint=0.75, limit=c(.5,1),
                       name="Pearson\nCorr.") +
  theme(axis.text.x=element_text(angle=45, vjust=0.6),
        axis.title=element_blank(),
        plot.title=element_text(hjust=0.5)) +
  ggtitle("Correlation for Normalization with rma()")


grid.arrange(g.cor.justMAS, g.cor.rma, ncol=2)
```

![](README_figs/README-unnamed-chunk-18-1.png)<!-- -->

##### **Bonus: Dendogram Time\! Check out heatmap2 to see if rma() also shows higher correlation of samples with rma normalization.**

After scaling the `column` this basically gives us another way to
visualize the density plots above. This just also gives us correlation
from a gene perspective within each of the normalization types.

``` r
## check first 500 genes

## https://www.biostars.org/p/191971/
## https://stackoverflow.com/questions/15114347/to-display-two-heatmaps-in-same-pdf-side-by-side-in-r
library(gridGraphics)
library(grid)  
library(gplots)
```

    ## 
    ## Attaching package: 'gplots'

    ## The following object is masked from 'package:stats':
    ## 
    ##     lowess

``` r
grab.grob <- function() {
  grid.echo()
  grid.grab()
}

l <- list(justMAS=justMAS.matrix, 
          rma=rma.matrix)

## setting scale to be 'column', probabaly not okay 
## help says "There is some empirical evidence from genomic plotting that this is useful."
## https://stackoverflow.com/questions/15351575/moving-color-key-in-r-heatmap-2-function-of-gplots-package
## https://bioinformatics.stackexchange.com/questions/4742/how-to-scale-the-size-of-heat-map-and-row-names-font-size
lmat = rbind(c(0,0,0,0), c(0,4,3,0), c(0,2,1,0), c(0,0,0,0))
lhei = c(0.3, 1.5, 5, 0.35)
lwid = c(0.3, 1.1, 3, 0.3)
gl <- lapply(seq_along(l), function(i) {
  heatmap.2(l[[i]][1:500, ], trace="none", main=names(l)[[i]], 
            margins = c(10,10), scale="column", cexCol=1.3, 
            lmat=lmat, lhei=lhei, lwid = lwid)
  grab.grob()
})
```

![](README_figs/README-unnamed-chunk-19-1.png)<!-- -->![](README_figs/README-unnamed-chunk-19-2.png)<!-- -->![](README_figs/README-unnamed-chunk-19-3.png)<!-- -->![](README_figs/README-unnamed-chunk-19-4.png)<!-- -->![](README_figs/README-unnamed-chunk-19-5.png)<!-- -->![](README_figs/README-unnamed-chunk-19-6.png)<!-- -->

``` r
grid.arrange(grobs=gl, ncol=2, clip=T)
```

![](README_figs/README-unnamed-chunk-19-7.png)<!-- -->

I have seen people do colored dendrograms and Horizontal color bars with
RowSideColors using `dendextend` package to make the dendrogram
groupings more visually appealing and grouping is easier to see. I was
be able to manipulate this manually and I added an answer to
stackoverflow
[here](https://stackoverflow.com/questions/15660363/how-to-change-position-of-rowsidecolors-in-r-heatmap-2/64139880#64139880)

``` r
#install.packages("dendextend")
## New order, gplots package owners added 
## LIFO queue for RowSideColors as 1 and moved 
## everything down a number.  Silly.  Should add 
## 'stack like' with keys.  This is the orginal order
## https://stackoverflow.com/questions/15351575/moving-color-key-in-r-heatmap-2-function-of-gplots-package
## New order is:
#   2. Heatmap,
#   3. Row dendrogram,
#   4. Column dendrogram,
#   5. Key,
#   1. RowSideColors
lmat=rbind(c(5,0,4), c(3,1,2))
lhei=c(1.,4)
lwid=c(1.5,0.25,4)

library(dendextend)
```

    ## 
    ## ---------------------
    ## Welcome to dendextend version 1.14.0
    ## Type citation('dendextend') for how to cite the package.
    ## 
    ## Type browseVignettes(package = 'dendextend') for the package vignette.
    ## The github page is: https://github.com/talgalili/dendextend/
    ## 
    ## Suggestions and bug-reports can be submitted at: https://github.com/talgalili/dendextend/issues
    ## Or contact: <tal.galili@gmail.com>
    ## 
    ##  To suppress this message use:  suppressPackageStartupMessages(library(dendextend))
    ## ---------------------

    ## 
    ## Attaching package: 'dendextend'

    ## The following object is masked from 'package:ggpubr':
    ## 
    ##     rotate

    ## The following object is masked from 'package:stats':
    ## 
    ##     cutree

``` r
library(colorspace)

## got this from tutorial by Yang Liu
## https://liuyanguu.github.io/post/2018/07/16/how-to-draw-heatmap-with-colorful-dendrogram/
gl <- lapply(seq_along(l), function(i) {
  dend1 <- as.dendrogram(hclust(dist(l[[i]][1:500, ])))
  num.clust <- 8
  dend1 <- color_branches(dend1, k=num.clust, col=heat_hcl)
  dend1 <- color_labels(dend1, k=num.clust, col=heat_hcl)
  
  col.labels <- get_leaves_branches_col(dend1)
  col.labels <- col.labels[order(order.dendrogram(dend1))]
  dend1 <- set(dend1, "labels_cex", 0.5)
  par(cex.main=0.8)

  heatmap.2(l[[i]][1:500, ], trace="none", main=names(l)[[i]], 
            margins = c(10,10), scale="column", cexCol=1.2,
            Rowv=dend1, col=diverge_hcl,
            lmat=lmat, lhei=lhei, lwid = lwid,
            RowSideColors=col.labels, colRow=col.labels)
  grab.grob()
})
```

![](README_figs/README-unnamed-chunk-20-1.png)<!-- -->![](README_figs/README-unnamed-chunk-20-2.png)<!-- -->![](README_figs/README-unnamed-chunk-20-3.png)<!-- -->![](README_figs/README-unnamed-chunk-20-4.png)<!-- -->![](README_figs/README-unnamed-chunk-20-5.png)<!-- -->![](README_figs/README-unnamed-chunk-20-6.png)<!-- -->

``` r
grid.arrange(grobs=gl, ncol=2, clip=T)
```

![](README_figs/README-unnamed-chunk-20-7.png)<!-- -->