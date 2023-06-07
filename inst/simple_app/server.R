shinyServer(function(input, output) {
  # Get data dynamically =======================================================
  get_data <- eventReactive(input$submit, {
    # Validate wheter or not the input is not empty:
    validate(
      need(
        input$pid != "",
        "Input is empty, please try again."
      )
    )
    # Validate wheter the input does not contain letters:
    validate(
      need(
        grepl("[A-Za-z]",
              input$pid) == FALSE,
        "Input contains letters, please try again."
      )
    )
    # Validate wheter the input only contains commas as punctuation:
    validate(
      need(
        grepl("(?!,)[[:punct:]]",
              input$pid,
              perl = TRUE) == FALSE,
        "Input contains improper punctuation, please try again."
      )
    )
    # Get data for reactive function:
    listed_data <- retrieve_data(pid = input$pid,
                                 n   = 2)
  })
  # Get a network ==============================================================
  output$visplot <- renderVisNetwork({
    visNetwork(nodes = get_data()[["nodes"]],
               edges = get_data()[["edges"]]) %>%
      visIgraphLayout(layout = "layout_with_fr") %>%
      visOptions(highlightNearest = TRUE,
                 nodesIdSelection = TRUE,
                 manipulation     = TRUE)%>%
      visInteraction(navigationButtons = TRUE,
                     keyboard          = TRUE)
  })
  # Get an edge list ===========================================================
  output$edges <- DT::renderDataTable({
    get_data()[["edges"]] %>%
      DT::datatable(rownames   = FALSE,
                    extensions = 'Buttons',
                    options    = list(
                      dom      = 'Bfrtip',
                      buttons  = c('copy', 'csv')
      ))
  })
  # Get an nodes list ==========================================================
  output$nodes <- DT::renderDataTable({
    get_data()[["nodes"]] %>%
      select(-title) %>%
      DT::datatable(rownames   = FALSE,
                    extensions = list('Buttons',
                                      'Scroller'),
                    options    = list(
                      dom      = 'Bfrtip',
                      buttons  = c('copy', 'csv'),
                      scrollY  = 400,
                      scrollX  = TRUE,
                      scroller = TRUE
                    ))
  })
  # Get dynamic UI =============================================================
  output$download_ui <- renderUI({
    if (!is.null(get_data())) {
      column(
        width = 12,
        column(
          width = 12,
          tags$p(
            tags$b("Insight: ")
          ),
          tags$p(
            sprintf("The node you queried returned %s neighbors.",
              nrow(get_data()[["nodes"]])-1),
            tags$br(),
            "Beyond the dynamic graphical representation of the network you can tab over to see the edges (relationships) and nodes (non-relational characteristics) in the graph."
            )
        )
      )
    }
  })
})
