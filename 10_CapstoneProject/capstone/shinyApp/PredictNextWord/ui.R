library(shiny)
library(data.table)
library(wordcloud)

# Define UI for application that runs the word prediction after given input sentence:
shinyUI(navbarPage(theme = "bootstrap.css",
  title = 'Predict next word!',
  tabPanel('app',
            sidebarLayout(
               sidebarPanel(
                 textInput("sentence", "Enter a sentence in English language ...", "Winter is"),
                 radioButtons("model", "Applied model: n-gram probabilities using",
                              c( "Back-off & Kneser-Ney smoothing"= T,"Back-off & no smoothing"= F)
                 )#,
                 #includeMarkdown("copyright.Rmd")
               ),
               mainPanel(
                 h3("The top5 predicted words are ..."),
                 tableOutput('result'),
                 plotOutput("plot"),
                 tags$style(type="text/css",
                            ".shiny-output-error { visibility: hidden; }",
                            ".shiny-output-error:before { visibility: hidden; }"),
                 includeMarkdown("copyright.Rmd")
               )
            )
           ),
  tabPanel("about this application",
           includeMarkdown("aboutTheApp.Rmd"),
           includeMarkdown("copyright.Rmd")
  ),
  tabPanel('theoretical background',
           withMathJax(),
           #p("Description of the used models as RMarkdown document."),
           includeMarkdown("theoreticalExplanations.Rmd"),
           includeMarkdown("copyright.Rmd")
           )
  )
)