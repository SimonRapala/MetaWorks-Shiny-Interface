library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "My dashboard",

  sidebar = sidebar(
    actionButton("showHome", "Home"),
    actionButton("showCreateJob", "Create Job"),
    actionButton("showHistory", "Run History")
  ),

  navset_hidden(
    id = "mainPages",
    selected = "home",

    nav_panel_hidden(
      value = "home",
      h2("Home"),
      p("Welcome to MetaWorks.")
    ),

    nav_panel_hidden(
      value = "createJob",
      h2("Create Job"),
      p("Your upload controls will go here.")
    ),

    nav_panel_hidden(
      value = "history",
      h2("Run History"),
      p("Your previous runs will appear here.")
    )
  )
)

server <- function(input, output, session) {

  observeEvent(input$showHome, {
    nav_select(id = "mainPages", selected = "home")
  })

  observeEvent(input$showCreateJob, {
    nav_select(id = "mainPages", selected = "createJob")
  })

  observeEvent(input$showHistory, {
    nav_select(id = "mainPages", selected = "history")
  })
}

shinyApp(ui = ui, server = server)