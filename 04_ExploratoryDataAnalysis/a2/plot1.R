## Answering the question:
## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
## Using the base plotting system, make a plot showing the total PM2.5 emission from
## all sources for each of the years 1999, 2002, 2005, and 2008.

## 0. set working directory where data is located
## windows:
#setwd("C:/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2/")
## mac:
setwd("/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2")

## 1. load data
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

## 2. subset data to include only the PM2.5 emissions and the years
pm25_years <- subset(NEI,select = c("Emissions","year"))

## 3. calculate the sums of PM2.5 emission values for each year
sum_pm25_per_year <- with(pm25_years, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_per_year <- data.frame(years = names(sum_pm25_per_year), sum_pm25_per_year = sum_pm25_per_year)

years <- as.numeric(as.character(sum_pm25_per_year$years))
sum_pm25 <- as.numeric(sum_pm25_per_year$sum_pm25_per_year)

## 4. plot and save the data as sum of pm2.5 emissions over years 
## and fit a linear model through the data
png(filename = "plot1.png",width = 480, height = 480)
par(ps = 12, cex = 1, cex.main = 0.9)
plot(years,sum_pm25,pch = 19,col = "dodgerblue3",main = "Total emissions from PM2.5 DECREASED in the United States from 1999 to 2008!",
     ylab = "total PM2.5 emission (tons)",xlab = "year",xlim = c(1998, 2009))
abline(lm(sum_pm25~years), lwd = 1,col = "dodgerblue4")
legend("topright",col = c("dodgerblue3", "dodgerblue4"), legend = c("data", "linear model fit"),lwd=1, lty=c(NA,1), 
       pch=c(19,NA), merge=FALSE )
dev.off()
