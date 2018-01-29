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

# Subset coal combustion data
comb <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
comb_SCC <- SCC[comb & coal,]$SCC
comb_NEI <- NEI[NEI$SCC %in% comb_SCC,]

# plot to a file
png(filename='plot4.png')

# plot coal combustion source emissions
g <- ggplot(comb_NEI,aes(factor(year),Emissions/10^5)) +
  geom_bar(stat="identity",fill="grey",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="Year", y=expression("Total PM2.5 emission (10^5 tons)")) + 
  labs(title=expression("Coal combustion emission"))

print(g)

dev.off()