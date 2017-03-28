setwd("C:/Users/benwo/Dropbox/Data_science/Coursera_DataScience_JHU/05_Reproducible_Research/assignments/a2")

```{r download_unzip, echo = TRUE}
if(!file.exists("repdata-data-StormData.csv.bz2")){
  url <- ""
  download.file(url,destfile = "repdata-data-StormData.csv.bz2",method = "curl")
}

if(!file.exists("activity.csv")){
  unzip("repdata-data-StormData.csv.bz2")
}
'''

storm<-read.csv("repdata-data-StormData.csv")




storm_cut <- storm[,c("EVTYPE","FATALITIES","INJURIES","PROPDMG","PROPDMGEXP","CROPDMG","CROPDMGEXP")]

b <- storm_cut$PROPDMGEXP=="+" | storm_cut$PROPDMGEXP=="-" | storm_cut$PROPDMGEXP=="?"

storm_cut[b,]

c <- storm_cut$PROPDMGEXP=="h" | storm_cut$PROPDMGEXP=="H"
storm_cut[c,]

levels(storm_cut$EVTYPE)

Astronomical Low Tide    Z 
Avalanche        Z 
Blizzard        Z 
Coastal Flood      Z 
Cold/Wind Chill      Z 
Debris Flow       C 
Dense Fog        Z 
Dense Smoke      Z 
Drought        Z 
Dust Devil        C 
Dust Storm        Z 
Excessive Heat      Z 
Extreme Cold/Wind Chill    Z 
Flash Flood        C   
Flood          C 
Frost/Freeze       Z 
Funnel Cloud      C 
Freezing Fog      Z 
Hail          C 
Heat           Z 
Heavy Rain        C 
Heavy Snow       Z 
High Surf        Z 
High Wind        Z 
Hurricane (Typhoon)      Z 
Ice Storm        Z 
Lake-Effect Snow      Z 
Lakeshore Flood      Z 
Lightning        C 
Marine Hail       M 
Marine High Wind      M 
Marine Strong Wind      M 
Marine Thunderstorm Wind    M  
Rip Current        Z 
Seiche         Z 
Sleet           Z 
Storm Surge/Tide      Z 
Strong Wind       Z 
Thunderstorm Wind      C 
Tornado        C 
Tropical Depression      Z 
Tropical Storm      Z 
Tsunami        Z 
Volcanic Ash      Z 
Waterspout        M 
Wildfire        Z 
Winter Storm      Z 
Winter Weather      Z 

## Results
Here we look at the results ...

(not more than 3 figures - at least one - panel plots allowed)
(echo = true always)



