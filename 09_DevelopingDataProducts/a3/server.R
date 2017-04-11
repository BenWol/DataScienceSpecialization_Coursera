# http://deanattali.com/blog/advanced-shiny-tips/

# load packages
library(shiny)
library(plotly)
library(dplyr)
library(tidyr)

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
                h <- seq(length(input$year[1]:input$year[2]))
                v <- seq(length(input$year[1]:input$year[2]))
                for(i in seq(length(input$year[1]:input$year[2]))) {
                        h[i] <- sum(bl_g[bl_g$Season == i+input$year[1]-1,]$hgoal)
                        v[i] <- sum(bl_g[bl_g$Season == i+input$year[1]-1,]$vgoal)
                }
                all <- h + v
                dat <- data.frame(input$year[1]:input$year[2], h, v, all)
                colnames(dat) <- c("year", "h","v","all")
                
                # ggplot2 with loess fit
                dat %>% gather(key,value,h,v,all) %>%
                ggplot(aes(x=year, y=value,label = key))+
                geom_point()+
                geom_point(shape=16,colour = "dodgerblue4", size = 5)+
                geom_smooth(method='loess',colour = "dodgerblue1",se=TRUE)+
                ylab("goals")+xlab("years")+
                theme(axis.title = element_text(colour="black", size=26),
                      axis.text  = element_text(vjust=0.5, size=20))
       })
})