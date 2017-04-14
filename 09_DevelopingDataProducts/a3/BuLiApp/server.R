# http://deanattali.com/blog/advanced-shiny-tips/
# https://github.com/jalapic/shinyapps/tree/master/engsoccerbeta
# name the guy at the end

# load packages
library(shiny)
library(openssl)
library(dplyr)
library(tidyr)
library(ggplot2)

# load data
bl <- read.csv("germany_data.csv",header = TRUE,sep = ",")
bl_c <- bl[,1:5]
bl_g <- bl[,c(2:4,6,7)]

# Define server for application
shinyServer(function(input, output) {
        
        # search for the historic results
        result <- reactive({
                bl_c[(bl$hgoal == input$homegoal) & (bl$vgoal == input$visgoal),]
        })
        output$result <- renderDataTable({result()})
        
        # calculate goals per saison
        output$goals <- renderPlot({
           if (input$team == "all teams") {
                h <- seq(length(input$year[1]:input$year[2]))
                v <- seq(length(input$year[1]:input$year[2]))
                for(i in seq(length(input$year[1]:input$year[2]))) {
                        h[i] <- sum(bl_g[bl_g$Season == i+input$year[1]-1,]$hgoal)
                        v[i] <- sum(bl_g[bl_g$Season == i+input$year[1]-1,]$vgoal)
                }
                all <- h + v
                dat <- data.frame(input$year[1]:input$year[2], h, v, all)
                colnames(dat) <- c("year", "home","visitor","all")
                
                if (!input$show_home & !input$show_visitor & !input$show_all) {
                } else {
                    if (!input$show_home) {
                      dat <- select(dat,-home)
                    }
                    if (!input$show_visitor) {
                      dat <- select(dat,-visitor)
                    }
                    if (!input$show_all) {
                      dat <- select(dat,-all)
                    }
                  }
                dat <- dat %>% gather(key,value,2:length(dat))
                
                # ggplot2 with loess fit
                g <- ggplot(dat,aes(x=year, y=value,colour = key)) +
                  ylab("goals")+xlab("years")+
                  theme(axis.title = element_text(color="black", size=26),
                        axis.text  = element_text(vjust=0.5, size=20))
                if (input$show_home | input$show_visitor | input$show_all) {
                  g <- g + geom_point(shape=16, size = 3)
                }
                if (input$show_fit) {
                g <- g + geom_smooth(method='loess',se=input$show_fit_error)
                }
                g <- g + scale_color_manual(values=c("home"="dodgerblue4","visitor"="chartreuse4","all"="orangered2"))+
                     theme(legend.text=element_text(size=20),legend.title=element_blank())
                g
           } else {
                   team <- input$team
                   bl_gt <- bl_g[bl_g$home == team | bl_g$visitor == team,]
                   s_first <- input$year[1]
                   s_last <- input$year[2]
                   h <- seq(length(s_first:s_last))
                   v <- seq(length(s_first:s_last))
                   for(i in seq(length(s_first:s_last))) {
                           h[i] <- sum(bl_gt[bl_gt$Season == i+s_first-1 & bl_gt$home == team,]$hgoal)
                           v[i] <- sum(bl_gt[bl_gt$Season == i+s_first-1 & bl_gt$visitor == team,]$vgoal)
                   }
                   all <- h + v
                   dat <- data.frame(input$year[1]:input$year[2], h, v, all)
                   colnames(dat) <- c("year", "home","visitor","all")
                   
                   if (!input$show_home & !input$show_visitor & !input$show_all) {
                   } else {
                           if (!input$show_home) {
                                   dat <- select(dat,-home)
                           }
                           if (!input$show_visitor) {
                                   dat <- select(dat,-visitor)
                           }
                           if (!input$show_all) {
                                   dat <- select(dat,-all)
                           }
                   }
                   dat <- dat %>% gather(key,value,2:length(dat))
                   
                   # ggplot2 with loess fit
                   g <- ggplot(dat,aes(x=year, y=value,colour = key)) +
                           ylab("goals")+xlab("years")+
                           theme(axis.title = element_text(color="black", size=26),
                                 axis.text  = element_text(vjust=0.5, size=20))
                   if (input$show_home | input$show_visitor | input$show_all) {
                           g <- g + geom_point(shape=16, size = 3)
                   }
                   if (input$show_fit) {
                           g <- g + geom_smooth(method='loess',se=input$show_fit_error)
                   }
                   g <- g + scale_color_manual(values=c("home"="dodgerblue4","visitor"="chartreuse4","all"="orangered2"))+
                           theme(legend.text=element_text(size=20),legend.title=element_blank())
                   g
           }
       })
})