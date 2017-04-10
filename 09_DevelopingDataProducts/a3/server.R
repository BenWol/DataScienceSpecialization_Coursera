# load packages
library(shiny)

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
                plot(input$year[1]:input$year[2],h+v)
        })
})