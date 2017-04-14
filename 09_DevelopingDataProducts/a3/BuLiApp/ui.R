# https://jalapic.shinyapps.io/engsoccerbeta/
# something like this with german league
# cite the guy at the end on the shiny app and say that one can get the data from his github.

library(shiny)
library(openssl)
library(dplyr)
library(tidyr)
library(ggplot2)

# load data
bl <- read.csv("germany_data.csv",header = TRUE,sep = ",")

# Define UI for application that draws a histogram
shinyUI(pageWithSidebar(
        headerPanel("Football Data of the German 1. Bundesliga"),
        sidebarPanel(
                conditionalPanel(condition="input.conditionedPanels==1",
                                 h2("Search for specific results"),
                                 h4("In case you wonder whether a specific result has ever occurred in the history of the German 1. Bundesliga,
                                     or how many times, when and by which teams, look them up here!"),
                                 h4(" "),
                                 h4("Choose a specific result with the sliders, and
                                     all respective matches are listed on the right."),
                                 sliderInput("homegoal",
                                             h3("Goals of home team"),
                                             min = 0,
                                             max = 15,
                                             value = 5),
                                 sliderInput("visgoal",
                                             h3("Goals of visiting team"),
                                             min = 0,
                                             max = 15,
                                             value = 4),
                                 h4(" "),
                                 h4("The data and ideas are taken from: https://github.com/jalapic/engsoccerdata")
                ),
                conditionalPanel(condition="input.conditionedPanels==2",
                                 h2("Goals per Saison"),
                                 h4("Find out how many goals all or individual teams scored per season over the course of all Bundeliga seasons."),
                                 h4(" "),
                                 h4("Choose a time span with the slider, the team of your choice (or all teams), and select the data for all goals, or goals shot as
                                    the home or visiting team. Select to fit a line (with/without error) throught the data."),
                                 sliderInput("year",
                                             h3("Season"),
                                             min = 1963,
                                             max = 2015,
                                             value = c(1963,2015),
                                             ticks=FALSE,sep = ""),
                                 selectInput("team", label = "Select team:",
                                             c("all teams",levels(bl$home)),selected="all"),
                                 checkboxInput("show_home","Show home goals data",value=TRUE),
                                 checkboxInput("show_visitor","Show visitor goals data",value=TRUE),
                                 checkboxInput("show_all","Show all goals data",value=TRUE),
                                 checkboxInput("show_fit","Show fit line",value=FALSE),
                                 checkboxInput("show_fit_error","Show error of fit line",value=FALSE),
                                 h4(" "),
                                 h4("The data and ideas are taken from: https://github.com/jalapic/engsoccerdata")
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
