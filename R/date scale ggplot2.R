library(reshape2)

setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y"))

#files <- file("~/household_power_consumption.txt")
data <- read.table("~/household_power_consumption.txt", sep = ';', 
                        header = TRUE, na.strings = '?',
                        colClasses = c("myDate", "character", "numeric", "numeric",
                                       "numeric", "numeric", "numeric", "numeric", "numeric"))
head(data$Date)
#files <- file("~/household_power_consumption.txt")
data2 <- read.table(text = grep("^[1,2]/2/2007",readLines("~/household_power_consumption.txt"),value=TRUE), sep = ';', 
        header = TRUE, na.strings = '?',
        col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        colClasses = c("myDate", "character", "numeric", "numeric",
        "numeric", "numeric", "numeric", "numeric", "numeric"))
head(data2$Time)

hist(data2$Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red")

data2$dateTime <- as.POSIXct(paste(data2$Date, data2$Time, sep = " "))

plot(data2$dateTime, data2$Global_active_power, type = "l")          
require(ggplot2)

plot(data2$dateTime, data2$Sub_metering_1, type = "n")
lines(data2$dateTime, data2$Sub_metering_1, col = "red")
lines(data2$dateTime, data2$Sub_metering_2, col = "darkgreen")
lines(data2$dateTime, data2$Sub_metering_3, col = "blue")
legend("topright", lty = 1, col = c("red", "darkgreen", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
#########################################################################################
p1 <- ggplot(data = dtMelt, aes(x = dateTime, y = value, group = variable)) + 
        geom_line(aes(color=variable), size = .2) +
        #stat_smooth(aes(color=variable), method = "auto", formula = y ~ x, se = FALSE, size = 1) +
        #geom_text(aes(x=100, y=93, label="First Label", color="power1"), show_guide=F) +
        #geom_text(aes(x=250, y=72, label="Second Label", color="power2"), show_guide=F) +
        guides(color = guide_legend(title=NULL)) +
        scale_x_datetime(breaks = pretty_breaks(3), date_labels = c("Thu", "Fri", "Sat"))
        
## Change Label colors in legend from https://stackoverflow.com/questions/23588127/match-legend-text-color-in-geom-text-to-symbol     
library(grid)
g <- ggplotGrob(p1)
grid.ls(grid.force(g))

names.grobs <- grid.ls(grid.force(g))$name 
labels <- names.grobs[which(grepl("label", names.grobs))]

gt <- ggplot_build(p1)
colours <- unique(gt$data[[1]][, "colour"])

# Edit the 'label' grobs - change their colours
# Use the `editGrob` function
for(i in seq_along(labels)) {
        g <- editGrob(grid.force(g), gPath(labels[i]), grep = TRUE,  
                      gp = gpar(col = colours[i]))
}

grid.newpage()
grid.draw(g)
   
#########################################################################
ggplot(data = dt, aes(x = speed, y = value, group = variable)) + 
        geom_point(aes(color=variable), size = 2) +
        stat_smooth(aes(color=variable), method = lm, formula = y ~ poly(x, 2), se = FALSE, size = 1) +
        geom_text(aes(x=100, y=93, label="First Label", color="power1"), show_guide=F) +
        geom_text(aes(x=250, y=72, label="Second Label", color="power2"), show_guide=F) +
        guides(color = guide_legend(title=NULL))

par(col = c("red", "blue", "green"))
       
tab5rows <- read.table("~/household_power_consumption.txt", header = TRUE,  sep = ";", nrows = 5)
classes <- sapply(tab5rows, class)

tab10rows <- read.table("~/household_power_consumption.txt", header = TRUE,  sep = ";", nrows = 10,
                        colClasses = c("myDate", "myTime", "numeric", "numeric",
                                       "numeric", "numeric", "numeric", "numeric", "numeric"))
sapply(tab10rows, class)

pdf(file = "myplot.pdf")
par(mfrow = c(1,1))
hist(data2$Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red")
dev.off()                                                                                                                                                                                                                                                     "6/09/2007"), class = "factor")), .Names = c("func_loc", "order_type", 
                                                                                                                                                                                                                                                                                                                                                      "actual_finish"), row.names = c(NA, 10L), class = "data.frame")


