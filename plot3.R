#download the data
if (!file.exists("./data")){dir.create("./data")}
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(dataUrl, destfile = "./data/project.zip")
unzip("./data/project.zip")

#read the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#subset the Baltimore City data
Baltimore <- subset(NEI, fips == "24510")
Baltimore <- transform(Baltimore, year = factor(year),type = factor(type))

#group the data by type and year
library(dplyr)
plot3data <- Baltimore %>% group_by(year, type) %>% 
        summarise(totalEmissions = sum(Emissions, na.rm = TRUE))
        
#create and export the plot of emissions by type from 1999-2008
library(ggplot2)
png("plot3.png", width = 480, height = 480)
qplot(year, totalEmissions, data = plot3data, facets = .~type,
      main = "Total PM2.5 Emissions in Baltimore by Type through 1999-2008")
dev.off()