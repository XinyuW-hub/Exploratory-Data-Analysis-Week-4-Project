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

#get the pm2.5 emissions data by years
Baltimore <- transform(Baltimore, year = factor(year))
plot2Data <- tapply(Baltimore$Emissions, Baltimore$year, sum)
plot2Data <- data.frame(plot2Data)
plot2Data$year <- rownames(plot2Data)

#export the file
png("plot2.png", width = 480, height = 480)
with(plot2Data, plot(year, plot2Data, xlab = "Year", 
                     ylab = "PM2.5 Emissions [Tons]", pch=20, type = "o",
                     main = "Total PM2.5 Emissions in Baltimore City, Maryland",))
dev.off()