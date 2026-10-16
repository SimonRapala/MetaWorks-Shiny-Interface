library(shiny)
library(bslib)

ui <- page_navbar(
  title = "MetaWorks 1.13",
  id = "mainNavbar",
  nav_spacer(),
  theme = bs_theme(
    bg = "#FFFFFF",
    fg = "#0B0F19",
    primary = "#1F2937",
    secondary = "#3B82F6",
    base_font = "Arial"
  ),
  header = tags$head(
    tags$link(
      rel = "stylesheet",
      href = "styles.css"
    )
  ),
  nav_panel(
    col_widths = breakpoints(
      md = c(4, 8)
    ),
    title = "Home",
    value = "home",
    layout_columns(
      class = "titleContainer",
      h2("Welcome", br(), "to the MetaWorks", br(),
        "Interface",
        id = "homeTitle"
      ),

      p("This app is intended as a interface to complement
      to MetaWorks v1.13. The interface simplifies the process of
      running MetaWorks from the CLI to a more user friendly approach.
      Keeping aggregate data and allowing users to easily tune thier runs
      to thier need.", id = "titleBlurb")

    ),
    layout_columns(
      col_widths = breakpoints(
        md = c(4, 4, 4)
      ),
      fill = FALSE,
      class = "homeCardsContainer",
      card(
        class = "homeCardCreate homeCard",
        card_body(
          p("Upload your sequence files, configure your settings and
          prepare a new MetaWorks run for processing"),
          actionButton("homeButtonCreate", "Create")
        )
      ),
      card(
        class = "homeCardRuns homeCard",
        card_body(
          p("Browse previous runs as well as overall overhead cost and
          statistic tracking, reviewing settigns and files as well
          as downloading historical results"),
          actionButton("homeButtonRun", "Runs")
        )
      ),
      card(
        class = "homeCardHelp homeCard",
        card_body(
          p("Learn what each setting controls and how it can be changed,
          explore default as well as min and max values, ad find guidance
          on how to configure your run"),
          actionButton("homeButtonHelp", "Help")
        )
      )
    )
  ),
  nav_panel(
    title = "Create",
    value = "create",
    layout_sidebar(
      sidebar = sidebar(
        open = "closed",
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
    value = "runs",
    layout_sidebar(
      sidebar = sidebar(
        open = "closed",
        actionButton("showDashboard", "Dashboard"),
        actionButton("showDownloadRuns", "Download Runs")
      ),
      navset_hidden(
        id = "runPages",
        selected = "dashboard",
        nav_panel_hidden(
          value = "dashboard",
          h2("Dashboard"),
          p("Info on past runs")
        ),
        nav_panel_hidden(
          value = "downloadRuns",
          h2("Download Runs"),
          p("Download your runs here")
        )
      )
    )
  ),
  nav_panel(
    title = "Help",
    value = "help",
    layout_sidebar(
      sidebar = sidebar(
        open = "closed",
        actionButton("showSeqprep", "SEQPREP"),
        actionButton("showCutadapt", "CUTADAPT"),
        actionButton("showVsearch", "VSEARCH"),
        actionButton("showMarkers", "Markers"),
        actionButton("showItspart", "ITSpart"),
        actionButton("showPseudogene", "Psuedogene Filtering"),
        actionButton("showOrffinder", "ORFFINDER"),
        actionButton("showOther", "Other")
      ),
      navset_hidden(
        id = "helpPages",
        selected = "seqprep",
        nav_panel_hidden(
          value = "seqprep",
          h2("SEQPREP"),
          p("Help for SEQPREP settings will appear here.")
        ),
        nav_panel_hidden(
          value = "cutadapt",
          h2("CUTADAPT"),
          p("Help for CUTADAPT settings will appear here.")
        ),
        nav_panel_hidden(
          value = "vsearch",
          h2("VSEARCH"),
          p("Help for VSEARCH settings will appear here.")
        ),
        nav_panel_hidden(
          value = "markers",
          h2("Markers"),
          p("Help for choosing a genetic marker will appear here.")
        ),
        nav_panel_hidden(
          value = "itspart",
          h2("ITSpart"),
          p("Help for choosing an ITS region will appear here.")
        ),
        nav_panel_hidden(
          value = "rdp",
          h2("RDP"),
          p("Help for RDP classifier settings will appear here.")
        ),
        nav_panel_hidden(
          value = "pseudogene",
          h2("Pseudogene Filtering"),
          p("Help for pseudogene filtering will appear here.")
        ),
        nav_panel_hidden(
          value = "orffinder",
          h2("ORFFINDER"),
          p("Help for ORFfinder settings will appear here.")
        ),
        nav_panel_hidden(
          value = "other",
          h2("Other"),
          p("Additional help will appear here.")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  #
  observeEvent(input$showUpload, {
    nav_select("createPages", selected = "upload")
  })

  observeEvent(input$showSettings, {
    nav_select("createPages", selected = "settings")
  })

  observeEvent(input$showReview, {
    nav_select("createPages", selected = "review")
  })


  observeEvent(input$showDashboard, {
    nav_select("runPages", selected = "dashboard")
  })

  observeEvent(input$showDownloadRuns, {
    nav_select("runPages", selected = "downloadRuns")
  })

  observeEvent(input$showSeqprep, {
    nav_select("helpPages", selected = "seqprep")
  })

  observeEvent(input$showCutadapt, {
    nav_select("helpPages", selected = "cutadapt")
  })

  observeEvent(input$showVsearch, {
    nav_select("helpPages", selected = "vsearch")
  })

  observeEvent(input$showMarkers, {
    nav_select("helpPages", selected = "markers")
  })

  observeEvent(input$showItspart, {
    nav_select("helpPages", selected = "itspart")
  })

  observeEvent(input$showRdp, {
    nav_select("helpPages", selected = "rdp")
  })

  observeEvent(input$showPseudogene, {
    nav_select("helpPages", selected = "pseudogene")
  })

  observeEvent(input$showOrffinder, {
    nav_select("helpPages", selected = "orffinder")
  })

  observeEvent(input$showOther, {
    nav_select("helpPages", selected = "other")
  })

  observeEvent(input$homeButtonCreate, {
    nav_select("mainNavbar", selected = "create")
  })

  observeEvent(input$homeButtonRun, {
    nav_select("mainNavbar", selected = "runs")
  })

  observeEvent(input$homeButtonHelp, {
    nav_select("mainNavbar", selected = "help")
  })
}

shinyApp(ui = ui, server = server)
