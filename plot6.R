library("data.table")
library("ggplot2")

# retrieve and unzip the data
path <- getwd()
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, "data.zip", sep = "/"))
unzip(zipfile = "data.zip")

# read the data from RDS files and put to tables
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- data.table(NEI)
SCC <- data.table(SCC)

# subset Baltimore and Los Angeles vehicle data
v <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
v_SCC <- SCC[v,]$SCC
v_NEI <- NEI[NEI$SCC %in% v_SCC,]
baltimore <- v_NEI[v_NEI$fips==24510,]
LA <- v_NEI[v_NEI$fips=="06037",]
baltimore$city <- "Baltimore City"
LA$city <- "Los Angeles County"
both <- rbind(baltimore, LA)

# plot to a file
png(filename='plot6.png')

# plot vehicle emissions for Baltimore City and Los Angeles County
g <- ggplot(both, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="Year", y=expression("Total PM2.5 emission (tons)")) + 
  labs(title=expression("Vehicle emission in Baltimore City and Los Angeles County"))

print(g)

dev.off()