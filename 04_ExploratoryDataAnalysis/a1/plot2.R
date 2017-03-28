#This script includes the code to create plot2.png of assignment1
#of the "Exploratory Data Analysis" class of the Data Science 
#Specialization course series of JHU via Coursera

## 0. set working directory and download and unzip the file from the webpage
#setwd("...");

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip";
download.file(url, destfile= "data.zip", method = "curl");
unzipped_file <- unzip("data.zip");
#unzipped_file <- "household_power_consumption.txt";

#-------------ESTIMATE OF THE MEMORY THE DATASET WILL REQUIRE-------------
#   numRow x numCol x 8 bytes/numeric value = size required in bites
nrow <- 2075259;
ncol <- 9;
num_bytes <- nrow * ncol * 8;

#   required memory is roughly double the bytes.
#   2^(30) bytes is 1 GB 
num_GB <- 2*num_bytes/2^(30);

# The current dataset if loaded fully requires roughly 0.278 GB of RAM. Should be fine!
#-------------------------------------------------------------------------

## 1. load data downloaded and unzipped file only for dates the dates 2007-02-01 (line 66638)
## and 2007-02-02 (ends line 69517) [!!! 1 line of header exists in the txt file !!!]

# in case you want to load all data
#data <- read.table(unzipped_file,header = TRUE,sep=";",col.names = c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"));

data <- read.table(unzipped_file,header = TRUE,sep=";",skip=66636,nrows=2880,col.names = c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"));

## 2. Stripping out the Date and time and merge them:
merged_date_time <- as.POSIXct(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S");
x <- merged_date_time;

## 3. Plot according to Plot2 example in assignment and save histogramm as png with 480 pixels as width and height
y<-data$Global_active_power;

png(filename = "plot2.png",width = 480, height = 480);
plot(x,y,type="n",xlab = "",ylab = "Global Active Power (kilowatts)");
par(ps = 12, cex = 1, cex.main = 1); #setting the font size accordingly
lines(x,y,lty=1);

## 4. switch print device off
dev.off();
