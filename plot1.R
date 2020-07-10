#download the data
if (!file.exists("./data")){dir.create("./data")}
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(dataUrl, destfile = "./data/project.zip")
unzip("./data/project.zip")

#read the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#create a plot by dividing the data by years and sum the emissiosn
NEI <- transform(NEI, year = factor(year))
plot1Data <- tapply(NEI$Emissions, NEI$year, sum)
plot1Data <- data.frame(plot1Data)
plot1Data$Year <- row.names(plot1Data)

png("plot1.png", width = 480, height = 480)
with(plot1Data, plot(Year, plot1Data, xlab = row.names(plot1Data), 
                     ylab = "PM2.5 Emissions", pch=20, main = "Total PM2.5 Emissions",
                     type = "o"))
dev.off()