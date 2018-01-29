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

# subset Baltimore vehicle data
v <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
v_SCC <- SCC[v,]$SCC
v_NEI <- NEI[NEI$SCC %in% v_SCC,]
baltimore <- v_NEI[v_NEI$fips==24510,]

# plot to a file
png(filename='plot5.png')

# plot vehicle emissions for Baltimore
g <- ggplot(baltimore,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="Year", y=expression("Total PM2.5 emission (tons)")) + 
  labs(title=expression("Vehicle emission in Baltimore"))

print(g)

dev.off()