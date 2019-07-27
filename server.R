shinyServer(function(input, output) {
  options(shiny.maxRequestSize=30*1024^2)
  text <- reactive({
    if (is.null(input$text)) {return(NULL) }
    else{
      Data <- readLines(input$text$datapath,encoding = "UTF-8")
      return(Data)
    }
  })
  text1 <- reactive({
        if (is.null(input$udpipe)) {   
          return(NULL) } else{
        
        a <- udpipe_load_model(file = input$udpipe$datapath)
        text1 <- udpipe_annotate(a, x = as.character(text()))
        text1 <- as.data.frame(text1)
        return(text1)
      }
  })
# Calc and render plot    
  output$plot = renderPlot({
    inputText <-  as.character(text())
    model = udpipe_load_model(file=input$udpipe$datapath)
    x <- udpipe_annotate(model, x = inputText, doc_id = seq_along(inputText))
    x <- as.data.frame(x)
    if (input$Language == "English"){
      all_words = x %>% subset(., xpos %in% input$file);
    }
    else{
      y <- input$file
      for(i in seq_len(length(input$file))){
        if (input$file[i] == "JJ"){
          y[i] <- "ADJ"
        }
        else if (input$file[i] == "NN"){
          y[i] <- "NOUN"
        }
        else if (input$file[i] == "NNP"){
          y[i] <- "PROPN"
        }
        else if (input$file[i] == "RB"){
          y[i] <- "ADV"
        }
        else{
          y[i] <- "VB"
        }
      }
      all_words = x %>% subset(., upos %in% y);
    }
    top_words = txt_freq(all_words$lemma)
    wordcloud(words = top_words$key, 
              freq = top_words$freq, 
              min.freq = 2, 
              max.words = 100,
              random.order = FALSE, 
              colors = brewer.pal(6, "Dark2"))
  })
  
  
  output$plot1 = renderPlot({
    inputText <-  as.character(text())
    model = udpipe_load_model(file=input$udpipe$datapath)
    x <- udpipe_annotate(model, x = inputText, doc_id = seq_along(inputText))
    x <- as.data.frame(x)
    if (input$Language == "English"){
      co_occ <- cooccurrence(
        x = subset(x, x$xpos %in% input$file), term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id")) 
    }
    else{
      y <- input$file
      for(i in seq_len(length(input$file))){
        if (input$file[i] == "JJ"){
          y[i] <- "ADJ"
        }
        else if (input$file[i] == "NN"){
          y[i] <- "NOUN"
        }
        else if (input$file[i] == "NNP"){
          y[i] <- "PROPN"
        }
        else if (input$file[i] == "RB"){
          y[i] <- "ADV"
        }
        else{
          y[i] <- "VB"
        }
      }
      co_occ <- cooccurrence(
        x = subset(x, x$upos %in% y), term = "lemma", 
        group = c("doc_id", "paragraph_id", "sentence_id"))
    }
    wordnetwork <- head(co_occ, 75)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork) 
    windowsFonts(devanew=windowsFont("Devanagari new normal"))
    suppressWarnings(ggraph(wordnetwork, layout = "fr") +  
                       
                       geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
                       geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
                       
                       theme_graph(base_family = "Arial Unicode MS") +  
                       theme(legend.position = "none") +
                       
                       labs(title = "Cooccurrence Plot", subtitle = "Speech TAGS as chosen"))
  })
  
  output$Text_Data = renderText({
    inputText <-  as.character(text())
    inputText
  })
})
