library(shiny)
library(bslib)

ui <- page_navbar(
  title = "MetaWorks 1.13",

  nav_panel(
    title = "Home",
    h2("Welcome to MetaWorks"),
    p("Your introduction and links go here.")
  ),

  nav_panel(
    title = "Create",

    layout_sidebar(
      sidebar = sidebar(
        actionButton("showUpload", "Upload"),
        actionButton("showSettings", "Settings"),
        actionButton("showReview", "Review")
      ),

      navset_hidden(
        id = "createPages",
        selected = "upload",

        nav_panel_hidden(
          value = "upload",
          h2("Upload"),
          p("Upload controls go here.")
        ),

        nav_panel_hidden(
          value = "settings",
          h2("Settings"),
          p("Configuration controls go here.")
        ),

        nav_panel_hidden(
          value = "review",
          h2("Review"),
          p("Review your job before running it.")
        )
      )
    )
  ),

  nav_panel(
    title = "Runs",
    
    layout_sidebar(
      sidebar = sidebar(
        actionButton("showDashboard", "Dashboard"),
        actionButton("showDownloadRuns", "Download Runs")
      )
    )
  ),



  nav_panel(
    title = "Help",
    layout_sidebar(
      sidebar = sidebar(
        actionButton("showSeqprep", "SEQPREP"),
        actionButton("showCutadapt", "CUTADAPT"),
        actionButton("showVSearch", "VSEARCH"),
        actionButton("showMarkers", "Markers"),
        actionButton("showITSpart", "ITSpart"),
        actionButton("showPsuedogeneFiltering", "Psuedogene Filtering"),
        actionButton("showORFFinder", "ORFFINDER"),
        actionButton("showOther", "Other")
      )
    )

  )
)

server <- function(input, output, session) {

  observeEvent(input$showUpload, {
    nav_select("createPages", selected = "upload")
  })

  observeEvent(input$showSettings, {
    nav_select("createPages", selected = "settings")
  })

  observeEvent(input$showReview, {
    nav_select("createPages", selected = "review")
  })
}

shinyApp(ui = ui, server = server)