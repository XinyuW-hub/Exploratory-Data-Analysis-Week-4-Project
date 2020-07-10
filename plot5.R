#download the data
if (!file.exists("./data")){dir.create("./data")}
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(dataUrl, destfile = "./data/project.zip")
unzip("./data/project.zip")

#read and subset the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
Baltimore <- subset(NEI, fips == "24510")
SCC.veh <- SCC[grep("[Vv]eh", SCC$Short.Name), ]
Baltimore.motor <- subset(Baltimore, Baltimore$SCC %in% SCC.veh$SCC)
Baltimore.motor <- transform(Baltimore.motor, year = factor(year))

#get the emission data by years
library(dplyr)
plot5data <- Baltimore.motor %>% group_by(year) %>% 
        summarise(motorEmissions = sum(Emissions, na.rm = TRUE))

#create and export the plot
library(ggplot2)
png("plot5.png", width = 480, height = 480)
g <- ggplot(plot5data, aes(x=year, y=motorEmissions))+ xlab("year")+ylab("Motor Vehicle Emissions")+
        ggtitle("Total Annual Vehicle Motor Emissions in Baltimore")
g + geom_bar(stat = "identity", fill = "steelblue")
dev.off()