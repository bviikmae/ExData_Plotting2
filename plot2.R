library("data.table")

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

# find the totals for Baltimore, Maryland
total <- NEI[fips=='24510', lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

# plot to a file
png(filename='plot2.png')

# create a barplot of total emission
barplot(total[, Emissions], names = total[, year], xlab = "Year", ylab = "Emission (tons)", 
        main = "Total PM2.5 emission")

dev.off()