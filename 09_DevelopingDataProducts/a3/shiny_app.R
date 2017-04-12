rm(list=ls())

####### loading packages  #######
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(data.table))
library(tidyr)

####### loading data set  #######
#setwd("/Users/benwo/Dropbox/DataScience/Coursera_DataScience_JHU/09_Developing_Data_Products/a3")
setwd("/Users/bwolter/PhD/private/data/DataScienceSpecialization_Coursera/09_DevelopingDataProducts/a3")
bl <- read.csv("germany_data.csv",header = TRUE,sep = ",")

####### ideas  #######
#1. tab with the option to type in any result and it shows you all those games + sort by year with slider
#2. plot overlay to switch on & off: homegoals, awaygoals in general plus by team selector
#   over time with area select and fit & forecast?!
#3. wins draws losses per team (selector) over time, points (considering 3 points rule) per team (selector) over time,
#   (places per team (selector) over time)
#4. team selector to show most games played, most (least) goals shot, most (least) goals per game

####### necessary calculations  #######
# 1. find out any (peculiar) result and who participated in BL history
home <- 8
away <- 4
bl_c <- bl[,1:5]
result <- bl_c[(bl$hgoal == home) & (bl$vgoal == away),]
result$Date
result$Season
result$home
result$visitor

# 2. goals per season (also separated in home and away) in general & per team over time in BL history
bl_g <- bl[,c(2:4,6,7)]
# (h&v) goals per season
s_first <- min(bl_g$Season)
s_last <- max(bl_g$Season)
h <- seq(length(s_first:s_last))
v <- seq(length(s_first:s_last))
for(i in seq(length(s_first:s_last))) {
  h[i] <- sum(bl_g[bl_g$Season == i+s_first-1,]$hgoal)
  v[i] <- sum(bl_g[bl_g$Season == i+s_first-1,]$vgoal)
}

# ggplot2 with loess fit
dat %>% gather(key,value,h,v,all) %>%
  ggplot(aes(x=year, y=value,colour = factor(key))) +
  geom_point(shape=16, size = 5)+
  #scale_color_manual(values=c("h"="dodgerblue4","v"="seagreen1","all"="orangered1"))
  #geom_smooth(method='loess',colour = "dodgerblue1",se=TRUE)+
  ylab("goals")+xlab("years")+
  theme(axis.title = element_text(colour="black", size=26),
        axis.text  = element_text(vjust=0.5, size=20))


# (h&v) goals per season per team
team <- "Borussia Dortmund"
bl_gt <- bl_g[bl_g$home == team | bl_g$visitor == team,]
s_first <- min(bl_g$Season)
s_last <- max(bl_g$Season)
h <- seq(length(s_first:s_last))
v <- seq(length(s_first:s_last))
for(i in seq(length(s_first:s_last))) {
  h[i] <- sum(bl_gt[bl_gt$Season == i+s_first-1 & bl_gt$home == team,]$hgoal)
  v[i] <- sum(bl_gt[bl_gt$Season == i+s_first-1 & bl_gt$visitor == team,]$vgoal)
}
all <- h + v
dat <- data.frame(s_first:s_last, h, v, all)
colnames(dat) <- c("year", "h","v","all")

# ggplot2 with loess fit
dat <- gather(dat,key,value,h,v,all)

  ggplot(dat,aes(x=year, y=value,colour = factor(key))) +
  geom_point(shape=16, size = 4)+
  scale_color_manual(values=c("h"="#999999", "v"="#E69F00", "all"="#56B4E9")) +
  geom_smooth(method='loess',se=TRUE)+
  scale_color_manual(values=c("h"="dodgerblue4","v"="chartreuse4","all"="orangered2"))+
  ylab("goals")+xlab("years")+
  theme(axis.title = element_text(color="black", size=26),
        axis.text  = element_text(vjust=0.5, size=20))


#c("dodgerblue4","seagreen4","orangered4"), size = 5)+
#        geom_smooth(method='loess',colour = c("dodgerblue1","seagreen2","orangered2"),se=TRUE)+
