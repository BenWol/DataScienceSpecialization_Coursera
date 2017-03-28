## Answering the question:
## How have emissions from motor vehicle sources changed from 1999-2008
## in Baltimore City?

## 0. set working directory where data is located
## windows:
#setwd("C:/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2/")
## mac:
setwd("/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2")

## 1. load data
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

## 2. subset data for ONLY Baltimore while including the SCC code, the PM2.5 emissions and the years
pm25_SCC_years_BM <- subset(NEI,fips == 24510,select = c("SCC","Emissions","year"))

## 3. search the Source Classification Code Table (SCC) for keywords related to motor vehicle sources.

# In my search for the SCC keywords I checked "vehicle" (1138 hits), "motor" (0 hits) and "on-road" (1685 hits).
# After looking in WIKIPEDIA for a definition of motor vehicle (https://en.wikipedia.org/wiki/Motor_vehicle): 
# "A motor vehicle is a self-propelled road vehicle, commonly wheeled, that does not operate on rails, such as trains or trams."
# I decided to use the keyword "on-road". I am aware that there are also non-road vehicles like tractors
# YET I would have to hand-pick them from the whole non-road vehicles dataset. SINCE there is no specification I CALL the "IT depends on the INTERPRETATION CARD".
# Also I use EI.Sector since it seems to be more accurate.

motor_vehicles <- grepl("On-Road",SCC$EI.Sector,ignore.case = TRUE)

# built vector with the related source digit strings
SCC_motor_vehicles <- subset(SCC,motor_vehicles == TRUE)
SCC_motor_vehicles$SCC <- as.character(SCC_motor_vehicles$SCC)

## 4. subset data further to exclude lines with SCC code NOT related to motor vehicle sources
pm25_motor_vehicles_years_BM <- subset(pm25_SCC_years_BM,pm25_SCC_years_BM$SCC %in% SCC_motor_vehicles$SCC)

## 5. calculate the sums of PM2.5 emission values for each year of the data related to motor vehicle sources
sum_pm25_motor_vehicles_per_year_BM <- with(pm25_motor_vehicles_years_BM, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_motor_vehicles_per_year_BM <- data.frame(years = names(sum_pm25_motor_vehicles_per_year_BM), sum_pm25 = sum_pm25_motor_vehicles_per_year_BM)

years_MV <- as.numeric(as.character(sum_pm25_motor_vehicles_per_year_BM$years))
sum_pm25_BM_MV <- as.numeric(sum_pm25_motor_vehicles_per_year_BM$sum_pm25)

## 6. plot and save the data as sum of pm2.5 emissions over years related to motor vehicle sources
## and fit a linear model through the data
png(filename = "plot5.png",width = 480, height = 480)
par(ps = 12, cex = 1, cex.main = 0.9)
plot(years_MV,sum_pm25_BM_MV,pch = 19,col = "dodgerblue3",main = "Total emissions from PM2.5 related to motor vehicle sources\n DECREASED in Baltimore from 1999 to 2008!",
     ylab = "total PM2.5 emission (tons)",xlab = "year",xlim = c(1998, 2009))
abline(lm(sum_pm25_BM_MV~years_MV), lwd = 1,col = "dodgerblue4")
legend("topright",col = c("dodgerblue3", "dodgerblue4"), legend = c("data related to motor vehicles in Baltimore", "linear model fit"),lwd=1, lty=c(NA,1), 
       pch=c(19,NA), merge=FALSE )
dev.off()