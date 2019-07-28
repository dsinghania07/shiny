####################################################################
#### Deepak Singhania -- 11915070                               ####
#### Prakash Sijwali --                                         ####   
#### Nitesh JIndal --                                           #### 
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
                           h4(p("Data input")),
                           p("This app supports only text files (.txt) data file.Please upload the file only in .txt format",align="justify"),
                           p('To use this app, click on', 
                             span(strong("Upload Sample Text File in .txt format:"),
                             'and click on',
                             span(strong("Upload Trained UDPipe Model:"), 'and upload the UDPipe file.')
                             ))),
                  tabPanel("Annoted Documents",dataTableOutput('table'),downloadButton("downloadData", "Download")
                           #selectInput("dataset","Choose a dataset:",choices = c("dataset")),
                           ),
                  
                  tabPanel("Word Cloud",plotOutput('plot'),plotOutput('plot3')),
                  tabPanel("Co-Occurene Plot",plotOutput('plot1'))
      ) 
    )
  ) 
)
)