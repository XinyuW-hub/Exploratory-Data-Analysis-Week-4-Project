#download the data
if (!file.exists("./data")){dir.create("./data")}
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(dataUrl, destfile = "./data/project.zip")
unzip("./data/project.zip")

#read and subset the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC.coal <- SCC[grepl("[Cc]oal", SCC$Short.Name), ]
NEI.coal <- NEI[NEI$SCC %in% SCC.coal$SCC, ]

#merge the two files by "SCC"
mergedData <- merge(NEI.coal, SCC.coal, by = "SCC")

#group the data by type and year
library(dplyr)
plot4data <- mergedData %>% group_by(year) %>% 
        summarise(totalEmissions = sum(Emissions, na.rm = TRUE))

#create and export the plot
library(ggplot2)
png("plot4.png", width = 480, height = 480)
g <- ggplot(plot4data, aes(x=year, y=totalEmissions))+ xlab("year")+ylab("Coal Comb-related Emissions")+
        ggtitle("Total Coal Combustion Emissions in the US through 1999-2008")
g + geom_point(col="steelblue", size = 2)
dev.off()