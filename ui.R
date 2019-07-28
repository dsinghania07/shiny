####################################################################
#### Deepak Singhania -- 11915070                               ####
#### Prakash Sijwali -- 11915011                                ####   
#### Nitesh JIndal -- 11915048                                  #### 
####################################################################

library("shiny")
shinyUI(
  fluidPage(
  titlePanel("Shiny App around the UDPipe NLP workflow"),
  sidebarLayout( 
  sidebarPanel(  
              fileInput("text", "Upload Sample Text File :"),
              fileInput("udpipe", "Upload Trained UDPipe Model:"),
              checkboxGroupInput("file", label = h3("Please select choice"), 
                                 choices = list("Adjective(JJ)" = "JJ", "Noun(NN)" = "NN", "Proper Noun(NNP)" = "NNP", "Adverb(RB)" = "RB", "Verb(VB)" = "VB"),
                                 selected = c("JJ","NN","NNP")),
              hr(),
              fluidRow(column(3, verbatimTextOutput("value"))),
              submitButton(text = "Apply Changes", icon("refresh"))
              ),
  mainPanel(
        tabsetPanel(type = "tabs",
                  tabPanel("Overview",
                           h4(p("About App")),p("This Shiny app is designed so as to know different word cloud basis noun and verb. It will
                              also explain about the Co occurrence of the data with the help of UDPIPE "),
                           h4(p("Data input")),
                           p("This app supports only text files (.txt).Please upload the file only in .txt format",align="justify"),
                           p('To use this app, click on', 
                             span(strong("Upload Sample Text File in .txt format:"),
                             'and click on',
                             span(strong("Upload Trained UDPipe Model:"), 'and upload the UDPipe file.')
                             ))),
                  tabPanel("Annoted Documents",dataTableOutput('table'),downloadButton("downloadData", "Download")
                           #selectInput("dataset","Choose a dataset:",choices = c("dataset")),
                           ),
                  
                  tabPanel("Word Cloud",h4(p("Noun")),plotOutput('plot'),h4(p("Noun")),plotOutput('plot3')),
                  #tabPanel("Word Cloud",plotOutput('plot'),plotOutput('plot3')),
                  tabPanel("Co-Occurene Plot",plotOutput('plot1'))
      ) 
    )
  ) 
)
)