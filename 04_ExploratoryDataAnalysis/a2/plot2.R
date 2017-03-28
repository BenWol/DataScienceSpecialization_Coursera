## Answering the question:
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
##(fips == "24510") from 1999 to 2008? Use the base plotting system to make
## a plot answering this question.

## 0. set working directory where data is located
## windows:
#setwd("C:/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2/")
## mac:
setwd("/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2")

## 1. load data
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

## 2. subset data for ONLY Baltimore while including only the PM2.5 emissions and the years
pm25_years_BM <- subset(NEI,fips == "24510",select = c("Emissions","year"))

## 3. calculate the sums of PM2.5 emission values for each year
sum_pm25_per_year_BM <- with(pm25_years_BM, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_per_year_BM <- data.frame(years = names(sum_pm25_per_year_BM), sum_pm25_per_year_BM = sum_pm25_per_year_BM)

years <- as.numeric(as.character(sum_pm25_per_year_BM$years))
sum_pm25_BM <- as.numeric(sum_pm25_per_year_BM$sum_pm25_per_year_BM)

## 4. plot and save the data as sum of pm2.5 emissions over years 
## and fit a linear model through the data
png(filename = "plot2.png",width = 480, height = 480)
par(ps = 12, cex = 1, cex.main = 0.9)
plot(years,sum_pm25_BM,pch = 19,col = "dodgerblue3",main = "Total emissions from PM2.5 generally DECREASED in Baltimore from 1999 to 2008,\n yet with a bigger standard deviation than in all the U.S.!",
     ylab = "total PM2.5 emission (tons)",xlab = "year",xlim = c(1998, 2009))
abline(lm(sum_pm25_BM~years), lwd = 1,col = "dodgerblue4")
legend("bottomleft",col = c("dodgerblue3", "dodgerblue4"), legend = c("data in Baltimore", "linear model fit"),lwd=1, lty=c(NA,1), 
       pch=c(19,NA), merge=FALSE )
dev.off()
