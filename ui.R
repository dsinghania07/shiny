
library("shiny")
tags$style(type="text/css",
           ".shiny-output-error { visibility: hidden; }",
           ".shiny-output-error:before { visibility: hidden; }"
)

shinyUI(
  fluidPage(
  
    titlePanel("UDPipe NLP Workflow"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("text", "Upload Sample Text File :"),
              fileInput("udpipe", "Upload Trained UDPipe Model:"),
              checkboxGroupInput("checkGroup", label = h3("Speech Tags to be Selected"), 
                                 choices = list("Adjective(JJ)" = "JJ", "Noun(NN)" = "NN", "Proper Noun(NNP)" = "NNP", "Adverb(RB)" = "RB", "Verb(VB)" = "VB"),
                                 selected = c("JJ","NN","NNP")),
              selectInput("Language", label = h3("Select Language"), 
                          choices = list("English" = "English", "Spanish" = "Spanish","Hindi" = "Hindi", "Tamil" = "Tamil", "Dutch" = "Dutch", "German" = "German", "Other" = "Other"), 
                          selected = "English"),
              hr(),
              fluidRow(column(3, verbatimTextOutput("value"))),
              submitButton(text = "Apply Changes", icon("refresh"))),
      
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Overview",
                           h4(p("Data input")),
                           p("This app supports only text files (.txt) data file.Please ensure that the text files are saved in UTF-8 Encoding format.",align="justify"),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Upload Sample Text File in .txt format:"),
                             'and click on',
                             span(strong("Upload Trained UDPipe Model:"), 'and upload the UDPipe file.'),
                             span(strong("SELECT LANGUAGE as well!!!"))))),
                  tabPanel("Word Cloud",plotOutput('plot')),
                  tabPanel("Co-Occurence Plot",plotOutput('plot1')),
                  tabPanel("Data",p(span(strong('Unable to display Indian Regional Languages data unfortunately!!'))),textOutput('Text_Data'))
      ) # end of tabsetPanel
    )# end of main panel
  ) # end of sidebarLayout
)  # end of fluidPage
) # end of UI