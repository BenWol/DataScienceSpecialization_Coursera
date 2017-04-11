# https://jalapic.shinyapps.io/engsoccerbeta/
# something like this with german league
# cite the guy at the end on the shiny app and say that one can get the data from his github.

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
        headerPanel("Football Data of the German 1.Bundesliga"),
        sidebarPanel(
                conditionalPanel(condition="input.conditionedPanels==1",
                                 h2("Explore for a specific result"),
                                 sliderInput("homegoal",
                                             h3("Goals of home team"),
                                             min = 0,
                                             max = 15,
                                             value = 5),
                                 sliderInput("visgoal",
                                             h3("Goals of visiting team"),
                                             min = 0,
                                             max = 15,
                                             value = 4)
                ),
                conditionalPanel(condition="input.conditionedPanels==2",
                                 h2("Goals per Saison"),
                                 sliderInput("year",
                                             h3("Season"),
                                             min = 1963,
                                             max = 2015,
                                             value = c(1963,2015),
                                             ticks=FALSE,sep = "")
                ) 
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel("Explore", value=1,fluidRow(
                                column(10,
                                       dataTableOutput('result')
                                ))), 
                        tabPanel("Goals", value=2,plotOutput("goals"))
                        , id = "conditionedPanels"
                )
        )
))
