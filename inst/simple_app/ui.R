shinyUI(
  fluidPage(
    theme = shinytheme("yeti"),
    titlePanel("Network Explorer"),
    fluidRow(
      column(
        width = 6,
        textInput(
          inputId = "pid",
          label   = "Enter PID(s) of interest (if multiple, separate with commas)",
          value   = ""
        ),
        tags$br(),
        fluidRow(
          align = "center",
          actionButton(
            inputId = "submit",
            label   = "Submit")
          )),
      column(
        width = 6,
        fluidRow(
          uiOutput("download_ui")
        )
      )
    ),
    tags$hr(),
    fluidRow(
      column(width = 12,
      mainPanel(
        width = 12,
      tabsetPanel(type = "tabs",
                  tabPanel("Network",
                            visNetworkOutput("visplot")),
                  tabPanel("Edges",
                            DT::dataTableOutput("edges")),
                  tabPanel("Nodes",
                            DT::dataTableOutput("nodes"))
                  )
      )

      )
    ),
    tags$br(),
    fluidRow(
      tags$p(
        tags$b("About:"),
        "This application was created by Christopher Callaghan as part of a larger discussion on using R Shiny with portable databases. All code can be found on GitHub,",
        tags$a("by clicking here.", href="https://github.com/cllghn/retl4aws"),
        style = "text-align:center; padding: 2px; background: #e7e7e7")
        )
    )
  )
