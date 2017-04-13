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
                                 h2("Search for specific results"),
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
                                             ticks=FALSE,sep = ""),
                                 checkboxInput("show_home","Show home goals data",value=TRUE),
                                 checkboxInput("show_visitor","Show visitor goals data",value=TRUE),
                                 checkboxInput("show_all","Show all goals data",value=TRUE),
                                 checkboxInput("show_fit","Show fit line",value=FALSE),
                                 checkboxInput("show_fit_error","Show error of fit line",value=FALSE)
                ) 
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel("Search results", value=1,fluidRow(
                                column(10,
                                       dataTableOutput('result')
                                ))), 
                        tabPanel("Goals per saison", value=2,plotOutput("goals"))
                        , id = "conditionedPanels"
                )
        )
))
