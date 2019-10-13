scatter.data <- read.table("1HMP_mmtk.tsv", header=FALSE, 
        comment.char="",  row.names=1, 
        colClasses=c("character","numeric","numeric","factor"), 
        col.names=c("name","phi","psi","type")) 

scatter.data[which(scatter.data[, "type"]=="Glycine"), "phi"]
scatter.data[which(scatter.data[, "type"]=="Glycine"), "psi"]

scatter.psi <- scatter.data[which(scatter.data[,"type"]=="General"),"psi"]
scatter.phi <- scatter.data[which(scatter.data[,"type"]=="General"),"phi"]
par(pty="s")
plot(x=scatter.phi, y=scatter.psi, xlim=c(-180,180), ylim=c(-180,180), 
     main="General", pch=20, xlab=expression(phi), ylab=expression(psi), 
     cex=0.1, asp=1.0)

x = 5

if (x > 3)
        print("stop")