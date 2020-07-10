#download the data
if (!file.exists("./data")){dir.create("./data")}
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(dataUrl, destfile = "./data/project.zip")
unzip("./data/project.zip")

#read and subset the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
##subset the data for Baltimore City and Los Angeles County
selected <- subset(NEI, fips == "24510" | fips == "06037")
SCC.veh <- SCC[grep("[Vv]eh", SCC$Short.Name), ]
selected.motor <- subset(selected, selected$SCC %in% SCC.veh$SCC)
selected.motor <- transform(selected.motor, year = factor(year), fips = factor(fips))

#group the data by fips and year
library(dplyr)
plot6data <- selected.motor %>% group_by(year, fips) %>% 
        summarise(motorEmissions = sum(Emissions, na.rm = TRUE))
plot6data$county <- rep(c("Los Angeles County", "Baltimore City"),4)
plot6data <- transform(plot6data, county=factor(county))

#create and export the plot
library(ggplot2)
png("plot6.png")
qplot(year, motorEmissions, data = plot6data, color = county, geom = c("point", "line"))+
        ggtitle("Total Annual Vehicle Emissions in Baltimore and Los Angeles")+
        xlab("year") + ylab("Total Emissions from Motor Vehicles")
dev.off()


