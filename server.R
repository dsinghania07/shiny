shinyServer(function(input, output) {
  options(shiny.maxRequestSize=30*1024^2)
  text_1 <- reactive({
    if (is.null(input$text)) {return(NULL) }
    else{
      Data <- readLines(input$text$datapath,encoding = "UTF-8")
      return(Data)
    }
  })
  text_2 <- reactive({
        if (is.null(input$udpipe)) {   
          return(NULL) } else{
        
        a <- udpipe_load_model(file = input$udpipe$datapath)
        text1 <- udpipe_annotate(a, x = as.character(text_1()))
        text1 <- as.data.frame(text1)
        return(text1)
      }
  })

  function(input, output) {
    datasetInput <- reactive({
      switch(input$dataset,"dataset" = dataset)
    })
  }
  output$table = renderDataTable({
    text_4 <-  as.character(text_1())
    model = udpipe_load_model(file=input$udpipe$datapath)
    x <- udpipe_annotate(model, x = text_4, doc_id = seq_along(text_4))
    x <- as.data.frame(x)
    x <- select(x, -sentence)
    
 })

  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$table, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
  output$plot = renderPlot({
    text_4 <-  as.character(text_1())
    model = udpipe_load_model(file=input$udpipe$datapath)
    x <- udpipe_annotate(model, x = text_4, doc_id = seq_along(text_4))
    x <- as.data.frame(x)
    all_nouns = x %>% subset(., upos %in% "NOUN") 
    top_nouns = txt_freq(all_nouns$lemma) 
    wordcloud(top_nouns$key,top_nouns$freq,min.freq = 2,max.words = 100,random.order = FALSE,colors = brewer.pal(6, "Dark2"))
  })
  
  output$plot3 = renderPlot({
    text_4 <-  as.character(text_1())
    model = udpipe_load_model(file=input$udpipe$datapath)
    x <- udpipe_annotate(model, x = text_4, doc_id = seq_along(text_4))
    x <- as.data.frame(x)
    all_verbs = x %>% subset(., upos %in% "VERB") 
    top_verbs = txt_freq(all_verbs$lemma)
    wordcloud(top_verbs$key,top_verbs$freq,min.freq = 2,max.words = 100,random.order = FALSE,colors = brewer.pal(6, "Dark2"))
  })
    
  output$plot1 = renderPlot({
    text_4 <-  as.character(text_1())
    model = udpipe_load_model(file=input$udpipe$datapath)
    x <- udpipe_annotate(model, x = text_4, doc_id = seq_along(text_4))
    x <- as.data.frame(x)
    co_occ <- cooccurrence(
    x = subset(x, x$xpos %in% input$file), term = "lemma", 
    group = c("doc_id", "paragraph_id", "sentence_id")) 
    
    word_1 <- head(co_occ, 75)
    word_1 <- igraph::graph_from_data_frame(word_1) 
    ggraph(word_1, layout = "fr") +  
                       
                       geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
                       geom_node_text(aes(label = name), col = "darkgreen", size = 6) +
                       
                       theme_graph(base_family = "Arial Narrow") +  
                       theme(legend.position = "none") +
                       
                       labs(title = "Cooccurrence Plot", subtitle = "Language")
    
  
  })

})
