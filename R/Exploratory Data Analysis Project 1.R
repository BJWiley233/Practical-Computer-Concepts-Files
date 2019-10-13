library(reshape2)

setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y"))

data2 <- read.table(text = grep("^[1,2]/2/2007",readLines("~/household_power_consumption.txt"),value=TRUE), sep = ';', 
                    header = TRUE, na.strings = '?',
                    col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                    colClasses = c("myDate", "character", "numeric", "numeric",
                                   "numeric", "numeric", "numeric", "numeric", "numeric"))

data2$dateTime <- as.POSIXct(paste(data2$Date, data2$Time, sep = " "))

###################################### PLOT 1
hist(data2$Global_active_power, xlab = "Global Active Power (kilowatts)", main = "Global Active Power", col = "red")

###################################### PLOT 2
plot(data2$dateTime, data2$Global_active_power, type = "l")          

###################################### PLOT 3
require(ggplot2)

p1 <- ggplot(data = dtMelt, aes(x = dateTime, y = value, group = variable)) + 
        geom_line(aes(color=variable), size = .2) +
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


###################################### PLOT 4
library(gridBase)

plot.new()
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))

#Draw ggplot
pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 1))
par(fig = gridFIG(), new = TRUE)
with(data2, plot(data2$dateTime, data2$Global_active_power, type = "l"))
popViewport()

#Draw bsae plot
pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 2))
par(fig = gridFIG(), new = TRUE)
with(data2, plot(data2$dateTime, data2$Voltage, type = "l"))
popViewport()

pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1))
print(grid.draw(g), newpage = FALSE)
popViewport()

pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 2))
par(fig = gridFIG(), new = TRUE)
with(data2, plot(data2$dateTime, data2$Global_reactive_power, type = "l"))
popViewport()