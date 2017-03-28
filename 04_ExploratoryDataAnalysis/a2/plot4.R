## Answering the question:
## Across the United States, how have emissions from coal combustion-related sources
## changed from 1999-2008?

## 0. set working directory where data is located
## windows:
#setwd("C:/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2/")
## mac:
setwd("/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/04_Exploratory_Data_Analysis/assignments/a2")


## 1. load data
#NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")

## 2. subset data to include only the SCC code, the PM2.5 emissions and the years
pm25_SCC_years <- subset(NEI,select = c("SCC","Emissions","year"))

## 3. search the Source Classification Code Table (SCC) for keywords related to coal combustion-related sources.

# looking at the Short.Name - description containing both "coal" and "comb" (for combustion)
#coal_comb <- grepl("coal",SCC$Short.Name,ignore.case = TRUE) & grepl("comb",SCC$Short.Name,ignore.case = TRUE)
# looking at the EI.Sector - description containing both "coal" and "comb" (for combustion)
coal_comb <- grepl("coal",SCC$Short.Name,ignore.case = TRUE) #& grepl("comb",SCC$EI.Sector,ignore.case = TRUE)
# I use EI.Sector since it seems to be more accurate. After check the end result changes only slightly using EI.Sector or Short.Name,
# YET doesn't change the end result!!!

# built vector with the related source digit strings
SCC_coal_comb <- subset(SCC,coal_comb == TRUE)
SCC_coal_comb$SCC <- as.character(SCC_coal_comb$SCC)

## 4. subset data further to exclude lines with SCC code NOT related to coal combustion-related sources
pm25_coal_comb_years <- subset(pm25_SCC_years,pm25_SCC_years$SCC %in% SCC_coal_comb$SCC)
                         
## 5. calculate the sums of PM2.5 emission values for each year of the data related to coal combustion-related sources
sum_pm25_per_year_comb_years <- with(pm25_coal_comb_years, tapply(Emissions, year, sum, na.rm = T))
sum_pm25_per_year_comb_years <- data.frame(years = names(sum_pm25_per_year_comb_years), sum_pm25 = sum_pm25_per_year_comb_years)

years_CC <- as.numeric(as.character(sum_pm25_per_year_comb_years$years))
sum_pm25_CC <- as.numeric(sum_pm25_per_year_comb_years$sum_pm25)

## 6. plot and save the data as sum of pm2.5 emissions over years related to coal combustion-related sources
## and fit a linear model through the data
#png(filename = "plot4.png",width = 480, height = 480)
par(ps = 12, cex = 1, cex.main = 0.9)
plot(years_CC,sum_pm25_CC,pch = 19,col = "dodgerblue3",main = "Total emissions from PM2.5 of coal combustion-related sources DECREASED\n in the United States from 1999 to 2008!",
     ylab = "total PM2.5 emission (tons)",xlab = "year",
     xlim = c(1998, 2009), ylim = c(3e+5, 6e+5))
abline(lm(sum_pm25_CC~years_CC), lwd = 1,col = "dodgerblue4")
legend("bottomleft",col = c("dodgerblue3", "dodgerblue4"), legend = c("data of coal combustion-related sources", "linear model fit"),lwd=1, lty=c(NA,1), 
       pch=c(19,NA), merge=FALSE )
#dev.off()