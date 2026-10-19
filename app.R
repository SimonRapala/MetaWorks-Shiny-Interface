#Loading in the libraries used
library(shiny)
library(bslib)
#Allows the use of external R files
source("R/fileValidation.R")

#The actual HTML and CSS displayed
ui <- page_navbar(
  #Title on the page
  title = "MetaWorks 1.13",
  #how to target and change CSS of the section
  id = "mainNavbar",
  #Moves the navbar options to the right
  nav_spacer(),
  #A general theme for the page to follow
  theme = bs_theme(
    bg = "#FFFFFF",
    fg = "#0B0F19",
    primary = "#1F2937",
    secondary = "#3B82F6",
    base_font = "Arial"
  ),
  #Imports the stylesheet allowing changing of the CSS
  header = tags$head(
    tags$link(
      rel = "stylesheet",
      href = "styles.css"
    )
  ),
  #Panels allow user to click and select the navbar options
  #changing displayed screen
  nav_panel(
    #The name of the navbar option
    title = "Home",
    #Allows for targeting selection when button is clicked
    value = "home",
    #Gives the Title and Title header thier spacing
    layout_columns(
      col_widths = breakpoints(
        md = c(4, 8)
      ),
      class = "titleContainer",
      fill = FALSE,
      #Title
      h2("Welcome", br(), "to the MetaWorks", br(),
        "Interface",
        id = "homeTitle"
      ),
      #Title header
      p("This app is intended as a interface to complement
      to MetaWorks v1.13. The interface simplifies the process of
      running MetaWorks from the CLI to a more user friendly approach.
      Keeping aggregate data and allowing users to easily tune their runs
      to their need.", id = "titleBlurb")
    ),
    #Gives the 3 cards thier spacing
    layout_columns(
      col_widths = breakpoints(
        md = c(4, 4, 4)
      ),
      fill = FALSE,
      class = "homeCardsContainer",
      #Each of the hold 2 elements that are flexboxed vertically
      card(
        class = "homeCardCreate homeCard",
        card_body(
          #Description
          p("Upload your sequence files, configure your settings and
          prepare a new MetaWorks run for processing"),
          #Button to allow alt movement to different navbar tabs
          actionButton("homeButtonCreate", "Create")
        )
      ),
      card(
        class = "homeCardRuns homeCard",
        card_body(
          p("Browse previous runs as well as overall overhead cost and
          statistic tracking, reviewing settings and files as well
          as downloading historical results"),
          actionButton("homeButtonRun", "Runs")
        )
      ),
      card(
        class = "homeCardHelp homeCard",
        card_body(
          p("Learn what each setting controls and how it can be changed,
          explore default as well as min and max values, and find guidance
          on how to configure your run"),
          actionButton("homeButtonHelp", "Help")
        )
      )
    )
  ),
  nav_panel(
    title = "Create",
    value = "create",
    #Creates the sidebar, starts collapsed, 
    #has 3 buttons for tabs inside the navbar option
    layout_sidebar(
      sidebar = sidebar(
        open = "closed",
        actionButton("showUpload", "Upload"),
        actionButton("showSettings", "Settings"),
        actionButton("showReview", "Review")
      ),
      #These are hidden pages that are loaded in when button is pressed
      navset_hidden(
        id = "createPages",
        #Allows for observer to select this option
        selected = "upload",
        nav_panel_hidden(
          value = "upload",
          layout_columns(
            id = "uploadLayout",
            col_widths = breakpoints(
              md = c(6, 6, 12)
            ),
            card(
              class = "fastqUploadCard createCard",
              card_body(
                h3(
                  "Select the raw sequence reads you would like to process",
                  br(), "(FASTQ format)"
                ),
                fileInput(inputId = "fastqUploadButton",
                          multiple = TRUE, label = "",
                          accept = "fastq.gz")
              )
            ),
            card(
              class = "fastaUploadCard createCard",
              card_body(
                h3("Select the adapter FASTA file"),
                fileInput(inputId = "fastaUploadButton", 
                          multiple = FALSE, label = "",
                          accept = ".fasta")
              )
            ),
            card(
              class = "uploadLog",
              card_body(
                h4("Upload Log"),
                verbatimTextOutput(
                  outputId = "uploadLogText",
                  placeholder = TRUE
                )
              )
            )
          )
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
  #Observers that allow use of create sidebar buttons
  observeEvent(input$showUpload, {
    nav_select("createPages", selected = "upload")
  })

  observeEvent(input$showSettings, {
    nav_select("createPages", selected = "settings")
  })

  observeEvent(input$showReview, {
    nav_select("createPages", selected = "review")
  })



  #Observers that allow use of runs sidebar button
  observeEvent(input$showDashboard, {
    nav_select("runPages", selected = "dashboard")
  })

  observeEvent(input$showDownloadRuns, {
    nav_select("runPages", selected = "downloadRuns")
  })

  #Observers that allow user of help sidebar buttons
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

  #Observers that allow the use of the buttons on the homepage cards
  observeEvent(input$homeButtonCreate, {
    nav_select("mainNavbar", selected = "create")
  })

  observeEvent(input$homeButtonRun, {
    nav_select("mainNavbar", selected = "runs")
  })

  observeEvent(input$homeButtonHelp, {
    nav_select("mainNavbar", selected = "help")
  })






  #The checks and validation for the file uploads in Create
  output$uploadLogText <- renderText({
    filenames <- c(
      input$fastqUploadButton$name,
      input$fastaUploadButton$name
    )
    req(length(filenames) > 0)
    validate(
      need(
        anyDuplicated(filenames) == 0,
        "Duplicate file names are not permitted"
      )
    )

    result <- checkFastQFiles(filenames)
    paste(result$outputLog, collapse = "\n")
  })

}

shinyApp(ui = ui, server = server)
