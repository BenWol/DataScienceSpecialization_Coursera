## Answering the question:
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
## variable, which of these four sources have seen decreases in emissions
## from 1999-2008 for Baltimore City? Which have seen increases in emissions
## from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.

## 0. set working directory where data is located
## windows:
#setwd("C:/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2/")
## mac:
setwd("/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2")

## 1. load data
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

## 2. subset data for different types for ONLY Baltimore while including only the PM2.5 emissions and the years
pm25_POINT_years_BM <- subset(NEI,fips == 24510 & type == "POINT",select = c("Emissions","year"))
pm25_NONPOINT_years_BM <- subset(NEI,fips == 24510 & type == "NONPOINT",select = c("Emissions","year"))
pm25_ON_ROAD_years_BM <- subset(NEI,fips == 24510 & type == "ON-ROAD",select = c("Emissions","year"))
pm25_NON_ROAD_years_BM <- subset(NEI,fips == 24510 & type == "NON-ROAD",select = c("Emissions","year"))

## 3a. calculate the sums of PM2.5 emission values for each year for POINT type
sum_pm25_per_year_POINT_BM <- with(pm25_POINT_years_BM, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_per_year_POINT_BM <- data.frame(years = names(sum_pm25_per_year_POINT_BM), sum_pm25 = sum_pm25_per_year_POINT_BM)

sum_pm25_per_year_POINT_BM$years <- as.numeric(as.character(sum_pm25_per_year_POINT_BM$years))
sum_pm25_per_year_POINT_BM$sum_pm25 <- as.numeric(sum_pm25_per_year_POINT_BM$sum_pm25)
sum_pm25_per_year_POINT_BM$types <- c("POINT","POINT","POINT","POINT")

## 3b. calculate the sums of PM2.5 emission values for each year for NONPOINT type
sum_pm25_per_year_NONPOINT_BM <- with(pm25_NONPOINT_years_BM, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_per_year_NONPOINT_BM <- data.frame(years = names(sum_pm25_per_year_NONPOINT_BM), sum_pm25 = sum_pm25_per_year_NONPOINT_BM)

sum_pm25_per_year_NONPOINT_BM$years <- as.numeric(as.character(sum_pm25_per_year_NONPOINT_BM$years))
sum_pm25_per_year_NONPOINT_BM$sum_pm25 <- as.numeric(sum_pm25_per_year_NONPOINT_BM$sum_pm25)
sum_pm25_per_year_NONPOINT_BM$types <- c("NONPOINT","NONPOINT","NONPOINT","NONPOINT")

## 3c. calculate the sums of PM2.5 emission values for each year for ON-ROAD type
sum_pm25_per_year_ON_ROAD_BM <- with(pm25_ON_ROAD_years_BM, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_per_year_ON_ROAD_BM <- data.frame(years = names(sum_pm25_per_year_ON_ROAD_BM), sum_pm25 = sum_pm25_per_year_ON_ROAD_BM)

sum_pm25_per_year_ON_ROAD_BM$years <- as.numeric(as.character(sum_pm25_per_year_ON_ROAD_BM$years))
sum_pm25_per_year_ON_ROAD_BM$sum_pm25 <- as.numeric(sum_pm25_per_year_ON_ROAD_BM$sum_pm25)
sum_pm25_per_year_ON_ROAD_BM$types <- c("ON-ROAD","ON-ROAD","ON-ROAD","ON-ROAD")

## 3d. calculate the sums of PM2.5 emission values for each year for NON-ROAD type
sum_pm25_per_year_NON_ROAD_BM <- with(pm25_NON_ROAD_years_BM, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_per_year_NON_ROAD_BM <- data.frame(years = names(sum_pm25_per_year_NON_ROAD_BM), sum_pm25 = sum_pm25_per_year_NON_ROAD_BM)

sum_pm25_per_year_NON_ROAD_BM$years <- as.numeric(as.character(sum_pm25_per_year_NON_ROAD_BM$years))
sum_pm25_per_year_NON_ROAD_BM$sum_pm25 <- as.numeric(sum_pm25_per_year_NON_ROAD_BM$sum_pm25)
sum_pm25_per_year_NON_ROAD_BM$types <- c("NON-ROAD","NON-ROAD","NON-ROAD","NON-ROAD")

## 4. create full data table to use in ggplot2 (probably there is a more elegant way)
sum_pm25_per_year_type_BM <- rbind(sum_pm25_per_year_POINT_BM,sum_pm25_per_year_NONPOINT_BM,sum_pm25_per_year_ON_ROAD_BM,sum_pm25_per_year_NON_ROAD_BM)

## 5. ggplot and save the data as sum of pm2.5 emissions over years and depending on type
## and fit a linear model through the data
library(ggplot2)
png(filename = "plot3.png",width = 720, height = 480)
print(qplot(years, sum_pm25, data = sum_pm25_per_year_type_BM, facets = . ~ types, geom = c("point", "smooth"), method="lm",
            main = "The sources 'NON-ROAD', 'NONPOINT' and 'ON-ROAD' show DECREASING emissions from 1999 to\n 2008. The 'POINT' type of source had INCREASING emissions (with high standard deviation) in that time."))
dev.off()