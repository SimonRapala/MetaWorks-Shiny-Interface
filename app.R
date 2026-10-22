# Loading in the libraries used
library(shiny)
library(bslib)
library(shinyFiles)
# Allows the use of external R files
source("R/fileValidation.R")

# The actual HTML and CSS displayed
ui <- page_navbar(
  # Title on the page
  title = "MetaWorks 1.13",
  # how to target and change CSS of the section
  id = "mainNavbar",
  # Moves the navbar options to the right
  nav_spacer(),
  # A general theme for the page to follow
  theme = bs_theme(
    bg = "#FFFFFF",
    fg = "#0B0F19",
    primary = "#1F2937",
    secondary = "#3B82F6",
    base_font = "Arial"
  ),
  # Imports the stylesheet allowing changing of the CSS
  header = tagList(
    # Allows inputs to be enabled and disabled from the server
    shinyjs::useShinyjs(),
    tags$head(
      tags$link(
        rel = "stylesheet",
        href = "styles.css"
      )
    )
  ),
  # Panels allow user to click and select the navbar options
  # changing displayed screen
  nav_panel(
    # The name of the navbar option
    title = "Home",
    # Allows for targeting selection when button is clicked
    value = "home",
    # Gives the Title and Title header thier spacing
    layout_columns(
      col_widths = breakpoints(
        md = c(4, 8)
      ),
      class = "titleContainer",
      fill = FALSE,
      # Title
      h2("Welcome", br(), "to the MetaWorks", br(),
        "Interface",
        id = "homeTitle"
      ),
      # Title header
      p("This app is intended as a interface to complement
      to MetaWorks v1.13. The interface simplifies the process of
      running MetaWorks from the CLI to a more user friendly approach.
      Keeping aggregate data and allowing users to easily tune their runs
      to their need.", id = "titleBlurb")
    ),
    # Gives the 3 cards thier spacing
    layout_columns(
      col_widths = breakpoints(
        md = c(4, 4, 4)
      ),
      fill = FALSE,
      class = "homeCardsContainer",
      # Each of the hold 2 elements that are flexboxed vertically
      card(
        class = "homeCardCreate homeCard",
        card_body(
          # Description
          p("Upload your sequence files, configure your settings and
          prepare a new MetaWorks run for processing"),
          # Button to allow alt movement to different navbar tabs
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
    # Creates the sidebar, starts collapsed,
    # has 3 buttons for tabs inside the navbar option
    layout_sidebar(
      sidebar = sidebar(
        open = "closed",
        actionButton("showUpload", "Upload"),
        actionButton("showSettings", "Settings"),
        actionButton("showReview", "Review")
      ),
      # These are hidden pages that are loaded in when button is pressed
      navset_hidden(
        id = "createPages",
        # Allows for observer to select this option
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
                shinyFilesButton(
                  id = "fastqUploadButton",
                  multiple = TRUE, label = "Browse",
                  title = "Select Read Fiels"
                )
              )
            ),
            card(
              class = "fastaUploadCard createCard",
              card_body(
                h3("Select the adapter FASTA file"),
                shinyFilesButton(
                  id = "fastaUploadButton",
                  multiple = FALSE, label = "Browse",
                  title = "Select Adapter File"
                )
              )
            ),
            card(
              class = "uploadLog",
              card_body(
                h4("Upload Log"),
                uiOutput(
                  "uploadLogText"
                )
              )
            )
          )
        ),
        nav_panel_hidden(
          value = "settings",
          h2("Settings"),
          # Creates the tabs used to group the settings by processing step
          navset_pill(
            id = "settingsTabs",
            # Settings used when merging the forward and reverse reads
            nav_panel(
              title = "SEQPREP",
              layout_columns(
                col_widths = breakpoints(
                  md = c(6, 6, 6, 6, 12)
                ),
                # Each card holds a title, a tooltip and the setting input
                card(
                  card_header(
                    # Allows CSS to space the title and question mark apart
                    class = "settingsHeader",
                    "Phred Quality Cutoff",
                    # Displays the explanation when hovering over the icon
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Minimum base quality accepted during
                      read merging. Increase for stricter accuracy with
                      high-quality data; decrease when retaining
                      lower-quality reads is more important."
                    )
                  ),
                  card_body(
                    div(
                      # CSS places the range and default label below the input
                      class = "labelsBelow",
                      numericInput(
                        inputId = "phredQualityCutoff",
                        label = "[Min: 0; Default: 13; Max: 40]",
                        value = 13,
                        min = 0,
                        max = 40,
                        step = 1
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Minimum Read Overlap",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Minimum overlapping bases
                      required to merge paired reads. Increase
                      for greater merging confidence; decrease
                      for longer amplicons with limited overlap."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "minimumReadOverlap",
                        label = "[Min: 10 bp; Default: 25 bp; Max: 100 bp]",
                        value = 25,
                        min = 10,
                        max = 100,
                        step = 1
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Maximum Mismatch Fraction",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Maximum fraction of mismatched bases
                      allowed in the overlap. Decrease for stricter
                      error control; increase slightly for lower-quality data."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "maximumMismatchFraction",
                        label = "[Min: 0; Default: 0.02; Max: 0.2]",
                        value = 0.02,
                        min = 0,
                        max = 0.2,
                        step = 0.01
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Minimum Matching-Overlap Fraction",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Minimum fraction of overlapping bases that
                      must agree. Increase to prioritize accuracy; decrease
                      to retain more reads from lower-quality runs."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "minimumMatchOverlapFraction",
                        label = "[Min: 0.70; Default: 0.90; Max: 1.00]",
                        value = 0.9,
                        min = 0.7,
                        max = 1.0,
                        step = 0.01
                      )
                    )
                  )
                ),
                card(
                  class = "seqprepLog",
                  card_header(
                    h4("SEQPREP Log")
                  ),
                  card_body(
                    verbatimTextOutput(
                      outputId = "seqprepLogText",
                      placeholder = TRUE
                    )
                  )
                )
              )
            ),
            # Settings used when trimming primers and low-quality sequence
            nav_panel(
              title = "CUTADAPT",
              layout_columns(
                col_widths = breakpoints(
                  md = c(6, 6, 6, 6, 6, 6, 12)
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Minimum Retained Sequence Length",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Minimum read length retained after primer and quality
                      trimming. Increase for longer amplicons; decrease for
                      short markers or degraded DNA."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "minimumRetainedSequenceLength",
                        label = "[Min: NA; Default: 150 bp; Max: NA]",
                        value = 150,
                        step = 1
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "End-quality Cutoffs",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Quality thresholds for trimming the 5′ and 3′ read ends.
                      Increase to remove low-quality tails; decrease to preserve
                      more sequence when read quality is high."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "endQualityCutoffs",
                        label = "5′ end [Min: NA; Default: 20; Max: NA]",
                        value = 20,
                        step = 1
                      ),
                      # Separate input allows each read end to have its own cutoff
                      numericInput(
                        inputId = "endQualityCutoff3Prime",
                        label = "3′ end [Min: NA; Default: 20; Max: NA]",
                        value = 20,
                        step = 1
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Maximum Primer Error Rate",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Maximum mismatch proportion allowed during primer
                      matching.Increase when variation near primer sites
                      is expected; decrease when false primer matches are
                       a concern."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "maximumPrimerErrorRate",
                        label = "[Min: NA; Default: 0.1 (10%); Max: NA]",
                        value = 0.1,
                        step = 0.01
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Minimum Primer Overlap",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Minimum matching bases required to detect a primer.
                       Increase to reduce accidental matches; decrease only
                       for highly degraded reads or expected partial primers."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "minimumPrimerOverlap",
                        label = "[Min: NA; Default: 3 bases; Max: NA]",
                        value = 3,
                        step = 1
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Maximum Ambiguous Bases",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Maximum number of ambiguous bases (N) permitted in a
                      read. Increase for lower-quality data; decrease for
                      stricter quality filtering."
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      numericInput(
                        inputId = "maximumAmbiguousBases",
                        label = "[Min: NA; Default: 3; Max: NA]",
                        value = 3,
                        step = 1
                      )
                    )
                  )
                ),
                card(
                  card_header(
                    class = "settingsHeader",
                    "Reverse-Complement Search",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Searches for primers in the reverse-complement
                      orientation as well. Enable when reads may occur
                      in either orientation. [Default: No]"
                    )
                  ),
                  card_body(
                    div(
                      class = "labelsBelow",
                      checkboxInput(
                        inputId = "reverseComplementSearch",
                        label = "Reverse-Complement Search",
                        value = FALSE
                      )
                    )
                  )
                ),
                card(
                  class = "cutadaptLog",
                  card_header(
                    h4("CUTADAPT Log")
                  ),
                  card_body(
                    verbatimTextOutput(
                      outputId = "cutadaptLogText",
                      placeholder = TRUE
                    )
                  )
                )
              )
            ),
            # Settings for VSEARCH
            nav_panel(
              title = "VSEARCH",
              layout_columns(
                # Gives each setting half the row and the log the full row
                col_widths = breakpoints(
                  md = c(6, 6, 12)
                ),
                # Sets the minimum number of reads needed to keep a variant
                card(
                  card_header(
                    class = "settingsHeader",
                    "Minimum Reads per Cluster",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Minimum reads supporting a sequence variant during denoising.
                      Increase to remove more low-abundance noise; decrease for low-
                      depth samples or when rare taxa are important."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      numericInput(
                        inputId = "minimumReadsPerCluster",
                        label = "[Min: NA; Default: 8; Max: NA]",
                        value = 8,
                        step = 1
                      )
                    )
                  )
                ),
                # Sets how many CPU threads VSEARCH can use
                card(
                  card_header(
                    class = "settingsHeader",
                    "VSEARCH Thread Count",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Number of CPU threads used during processing. Increase when more
                      CPU resources are available; decrease on smaller or shared
                      computers."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      numericInput(
                        inputId = "vsearchThreadCount",
                        label = "[Min: NA; Default: 15; Max: NA]",
                        value = 15,
                        step = 1
                      )
                    )
                  )
                ),
                # Holds the messages returned by settings validation later
                card(
                  class = "vsearchLog",
                  card_header(
                    h4("VSEARCH Log")
                  ),
                  card_body(
                    verbatimTextOutput(
                      outputId = "vsearchLogText",
                      placeholder = TRUE
                    )
                  )
                )
              )
            ),
            # Settings for Classification
            nav_panel(
              title = "Classification",
              layout_columns(
                # Gives each setting half the row and the log the full row
                col_widths = breakpoints(
                  md = c(6, 6, 6, 6, -3, 6, -3, 12)
                ),
                # Allows selection of the marker used for the run
                card(
                  card_header(
                    class = "settingsHeader",
                    "Genetic Marker",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Marker being analyzed. Choose the marker that matches your uploaded reads and
                      primers."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "geneticMarker",
                        label = "[Default: COI]",
                        choices = c(
                          "16S (built-in available)" = "16S",
                          "16S_vertebrate (external classifier required)" = "16S_vertebrate",
                          "18S_eukaryota (external classifier required)" = "18S_eukaryota",
                          "18S_diatom (external classifier required)" = "18S_diatom",
                          "12S_fish (external classifier required)" = "12S_fish",
                          "12S_vertebrate (external classifier required)" = "12S_vertebrate",
                          "ITS_fungi (built-in available)" = "ITS_fungi",
                          "28S_fungi (built-in available)" = "28S_fungi",
                          "rbcL_eukaryota (external classifier required)" = "rbcL_eukaryota",
                          "rbcL_diatom (external classifier required)" = "rbcL_diatom",
                          "rbcL_landPlant (external classifier required)" = "rbcL_landPlant",
                          "ITS_plants (external classifier required)" = "ITS_plants",
                          "COI (classifier included)" = "COI"
                        ),
                        selected = "COI",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Selects the region used when processing ITS reads
                card(
                  card_header(
                    class = "settingsHeader",
                    "ITS Region",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "ITS region being processed. Choose ITS1 or ITS2 to match your
                      primers. Only applies to ITS datasets."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "itsRegion",
                        label = "[Default: ITS2]",
                        choices = c(
                          "ITS1",
                          "ITS2"
                        ),
                        selected = "ITS2",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Sets the memory amount that will later be written as -Xmx8g
                card(
                  card_header(
                    class = "settingsHeader",
                    "RDP Memory Allocation",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Maximum RAM allocated to the classifier. Increase for large
                      datasets or memory errors; decrease when the computer has less
                      available RAM."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      numericInput(
                        inputId = "rdpMemoryAllocation",
                        label = "[Min: NA; Default: 8 GB; Max: NA]",
                        value = 8,
                        step = 1
                      )
                    )
                  )
                ),
                # Displays the classifier source choices for the new layout
                card(
                  card_header(
                    class = "settingsHeader",
                    "Classifier Source",
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Choose the included COI classifier, an RDP built-in model,
                      or an external trained classifier."
                    )
                  ),
                  card_body(
                    # The new source selection will be connected to the server later
                    radioButtons(
                      inputId = "classifierSource",
                      label = NULL,
                      choices = c(
                        "Included COI classifier" = "included",
                        "RDP built-in classifier" = "builtin",
                        "External trained classifier" = "external"
                      ),
                      selected = "included"
                    ),
                    # Selects between the two built-in fungal ITS references
                    # Its visibility and enabled state will be connected later
                    selectizeInput(
                      inputId = "builtInFungalClassifier",
                      label = "Built-in fungal ITS reference",
                      choices = c(
                        "Choose a reference" = "",
                        "Warcup" = "fungalits_warcup",
                        "UNITE (2014)" = "fungalits_unite"
                      ),
                      selected = "",
                      options = list(
                        dropdownParent = "body"
                      )
                    ),
                    helpText("Applies to fungal ITS when using an RDP built-in classifier."),
                    # Keeps the existing server input available during the display preview
                    div(
                      style = "display: none;",
                      checkboxInput(
                        inputId = "customTrainedClassifier",
                        label = "Use Custom-trained Classifier",
                        value = TRUE
                      )
                    )
                  )
                ),
                # Allows selection of an external classifier
                card(
                  card_header(
                    class = "settingsHeader",
                    "External Classifier",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Browse to the properties file for an external trained classifier.
                      Keep its companion training files in the same folder."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      # Allows selection of a different classifier properties file
                      shinyFilesButton(
                        id = "classifierBrowse",
                        label = "Browse",
                        title = "Select the classifier properties file",
                        multiple = FALSE
                      ),

                      # Displays the classifier currently selected
                      textOutput("classifierPathText"),

                      # Retains the old reset input until the source behaviour is updated
                      div(
                        style = "display: none;",
                        actionButton("resetClassifier", "Use default COI")
                      )
                    )
                  )
                ),
                # Holds the messages returned by settings validation later
                card(
                  class = "classificationLog",
                  card_header(
                    h4("Classification Log")
                  ),
                  card_body(
                    verbatimTextOutput(
                      outputId = "classificationLogText",
                      placeholder = TRUE
                    )
                  )
                )
              )
            ),
            # Settings for Pseudogene filtering
            nav_panel(
              title = "Pseudogene filtering",
              layout_columns(
                # Gives each setting half the row and the log the full row
                # Empty columns center the final setting when there is an odd number
                col_widths = breakpoints(
                  md = c(6, 6, 6, 6, 6, 6, 6, 6, 6, 6, -3, 6, -3, 12)
                ),
                # Controls whether pseudogene filtering is used
                card(
                  card_header(
                    class = "settingsHeader",
                    "Enable Pseudogene Filtering",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Removes likely non-functional copies of protein-coding genes.
                      Disable when filtering is not relevant or when examining
                      unfiltered sequences. Mainly intended for protein-coding markers
                      such as COI. [Default: Yes]"
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      checkboxInput(
                        inputId = "enablePseudogeneFiltering",
                        label = "Enable Pseudogene Filtering",
                        value = TRUE
                      )
                    )
                  )
                ),
                # Stores the option value while displaying a readable name
                card(
                  card_header(
                    class = "settingsHeader",
                    "Taxonomic Filtering Type",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Selects sequences for screening using one taxonomic rule or
                      compound include/exclude rules. Choose compound filtering when a
                      second taxonomic rule is needed."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "taxonomicFilteringType",
                        label = "[Default: Simple]",
                        choices = c(
                          "Simple" = "1",
                          "Compound" = "2"
                        ),
                        selected = "1",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Holds the primary taxonomic rule used by the configuration
                card(
                  card_header(
                    class = "settingsHeader",
                    "Primary Taxonomic Filter",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Taxonomic group selected for pseudogene screening. Change
                      Arthropoda when targeting a different group; use the whole-rank
                      taxonomic name."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      textInput(
                        inputId = "primaryTaxonomicFilter",
                        label = "[Default: -e Arthropoda]",
                        value = "-e Arthropoda"
                      )
                    )
                  )
                ),
                # Holds the extra rule used when compound filtering is selected
                card(
                  card_header(
                    class = "settingsHeader",
                    "Secondary Taxonomic Filter",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Additional taxonomic rule used only with compound filtering.
                      Change this to include or exclude the second group required by
                      your analysis."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      textInput(
                        inputId = "secondaryTaxonomicFilter",
                        label = "[Default: -v Chordata; Compound filtering only]",
                        value = "-v Chordata"
                      )
                    )
                  )
                ),
                # Selects the method used to identify suspected pseudogenes
                card(
                  card_header(
                    class = "settingsHeader",
                    "Pseudogene-removal Method",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Identifies suspected pseudogenes by unusual ORF length or
                      comparison with an HMM profile. Choose HMM only when a suitable
                      validated reference profile is available."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "pseudogeneRemovalMethod",
                        label = "[Default: ORF Length]",
                        choices = c(
                          "ORF Length" = "1",
                          "HMM Profile" = "2"
                        ),
                        selected = "1",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Lists the known template profile; add other installed profiles here
                card(
                  card_header(
                    class = "settingsHeader",
                    "HMM Profile",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Reference profile for HMM-based filtering. The template uses
                      bold.hmm for COI arthropods. Change only when another validated
                      profile is available. Only used with the HMM method."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "hmmProfile",
                        label = "[Default: bold.hmm; HMM method only]",
                        choices = c(
                          "bold.hmm"
                        ),
                        selected = "bold.hmm",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Offers the three genetic codes listed in the worksheet
                card(
                  card_header(
                    class = "settingsHeader",
                    "Genetic Code",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Translation table used to identify open reading frames. Change to
                      the genetic code used by your target organisms, such as vertebrate
                      mitochondrial code for vertebrate mitochondria."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "geneticCode",
                        label = "[Default: Invertebrate Mitochondrial (5)]",
                        choices = c(
                          "Standard (1)" = "1",
                          "Vertebrate Mitochondrial (2)" = "2",
                          "Invertebrate Mitochondrial (5)" = "5"
                        ),
                        selected = "5",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Selects how ORFfinder identifies the beginning of an ORF
                card(
                  card_header(
                    class = "settingsHeader",
                    "Start-codon Behaviour",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Codons allowed at the start of an open reading frame. Use a
                      stricter option only when biological start codons are required;
                      any sense codon accommodates partial barcode sequences."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "startCodonBehaviour",
                        label = "[Min: 0; Default: 2; Max: 2]",
                        choices = c(
                          "ATG Only (0)" = "0",
                          "ATG and Alternatives (1)" = "1",
                          "Any Sense Codon (2)" = "2"
                        ),
                        selected = "2",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Uses the worksheet suggested range for ORF length
                card(
                  card_header(
                    class = "settingsHeader",
                    "Minimum ORF Length",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Shortest open reading frame reported, in nucleotides. Increase for
                      longer target regions; use a smaller allowed value for short
                      targets."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      numericInput(
                        inputId = "minimumOrfLength",
                        label = "[Min: 30 nt; Default: 30 nt; Max: 1000 nt]",
                        value = 30,
                        min = 30,
                        max = 1000,
                        step = 1
                      )
                    )
                  )
                ),
                # Controls whether nested ORFs are ignored
                card(
                  card_header(
                    class = "settingsHeader",
                    "Ignore Nested ORFs",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Ignores open reading frames entirely contained within larger ones.
                      Disable only when nested ORF structure is needed for a specialized
                      analysis. [Default: Yes]"
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      checkboxInput(
                        inputId = "ignoreNestedOrfs",
                        label = "Ignore Nested ORFs",
                        value = TRUE
                      )
                    )
                  )
                ),
                # Selects which strand ORFfinder searches
                card(
                  card_header(
                    class = "settingsHeader",
                    "ORF Strand",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "DNA strand searched for open reading frames. Choose both when
                      orientation is unknown, or minus when the expected sequence is on
                      the reverse strand."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "orfStrand",
                        label = "[Default: Plus]",
                        choices = c(
                          "Plus" = "plus",
                          "Minus" = "minus",
                          "Both" = "both"
                        ),
                        selected = "plus",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Holds the messages returned by settings validation later
                card(
                  class = "pseudogeneLog",
                  card_header(
                    h4("Pseudogene filtering Log")
                  ),
                  card_body(
                    verbatimTextOutput(
                      outputId = "pseudogeneLogText",
                      placeholder = TRUE
                    )
                  )
                )
              )
            ),
            # Settings for Output
            nav_panel(
              title = "Output",
              layout_columns(
                # Gives each setting half the row and the log the full row
                # Empty columns center the final setting when there is an odd number
                col_widths = breakpoints(
                  md = c(-3, 6, -3, 12)
                ),
                # Selects how the final output files will be organized
                card(
                  card_header(
                    class = "settingsHeader",
                    "Report Type",
                    # Shows a short explanation when the question mark is hovered over
                    tooltip(
                      icon("circle-question", class = "toolTip"),
                      "Controls how final results are saved. Choose combined results for
                      one results.csv file; choose separate files for downstream scripts
                      or troubleshooting."
                    )
                  ),
                  card_body(
                    div(
                      # Allows the input label to be moved below the box with CSS
                      class = "labelsBelow",
                      selectizeInput(
                        inputId = "reportType",
                        label = "[Default: Combined Results]",
                        choices = c(
                          "Combined Results" = "1",
                          "Separate Files" = "2"
                        ),
                        selected = "1",
                        # Allows the options to extend outside the card
                        options = list(
                          dropdownParent = "body"
                        )
                      )
                    )
                  )
                ),
                # Holds the messages returned by settings validation later
                card(
                  class = "outputLog",
                  card_header(
                    h4("Output Log")
                  ),
                  card_body(
                    verbatimTextOutput(
                      outputId = "outputLogText",
                      placeholder = TRUE
                    )
                  )
                )
              )
            )
          )
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
  # Observers that allow use of create sidebar buttons
  observeEvent(input$showUpload, {
    nav_select("createPages", selected = "upload")
  })

  observeEvent(input$showSettings, {
    nav_select("createPages", selected = "settings")
  })

  observeEvent(input$showReview, {
    nav_select("createPages", selected = "review")
  })


  # Observers that allow use of runs sidebar button
  observeEvent(input$showDashboard, {
    nav_select("runPages", selected = "dashboard")
  })

  observeEvent(input$showDownloadRuns, {
    nav_select("runPages", selected = "downloadRuns")
  })

  # Observers that allow user of help sidebar buttons
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

  # Observers that allow the use of the buttons on the homepage cards
  observeEvent(input$homeButtonCreate, {
    nav_select("mainNavbar", selected = "create")
  })

  observeEvent(input$homeButtonRun, {
    nav_select("mainNavbar", selected = "runs")
  })

  observeEvent(input$homeButtonHelp, {
    nav_select("mainNavbar", selected = "help")
  })


  # Settings log outputs will be connected here when validation is added
  # Input values are available through input$ followed by their inputId
  # Dropdown values are strings and checkboxes return TRUE or FALSE
  # Enables settings only when they apply to the selected marker


  observe({
    # ITS region only applies to fungal or plant ITS markers
    shinyjs::toggleState(
      id = "itsRegion",
      condition = input$geneticMarker %in% c(
        "ITS_fungi",
        "ITS_plants"
      )
    )

    # Built-in fungal options only apply when custom is unchecked
    shinyjs::toggleState(
      id = "builtInFungalClassifier",
      condition = (
        input$geneticMarker %in% c("ITS_fungi") &&
          identical(input$classifierSource, "builtin")
      )
    )
  })

  # Changes the available classifier sources when the marker changes
  observeEvent(input$geneticMarker, {
    if (identical(input$geneticMarker, "COI")) {
      updateRadioButtons(
        session,
        inputId = "classifierSource",
        choices = c(
          "Included COI classifier" = "included",
          "External trained classifier" = "external"
        ),
        selected = "included"
      )
    } else if (input$geneticMarker %in% c(
      "16S", "ITS_fungi", "28S_fungi"
    )) {
      updateRadioButtons(
        session,
        inputId = "classifierSource",
        choices = c(
          "RDP built-in classifier" = "builtin",
          "External trained classifier" = "external"
        ),
        selected = "builtin"
      )
    } else {
      updateRadioButtons(
        session,
        inputId = "classifierSource",
        choices = c(
          "External trained classifier" = "external"
        ),
        selected = "external"
      )
    }
  })


  # The folders that the user is allowed to browse
  classifierRoots <- c(
    Classifiers = "/home/simonr/MetaWorks/Classifiers"
  )

  # The default classifier used when the app starts
  defaultClassifier <- paste0(
    classifierRoots[["Classifiers"]],
    "/COI/rRNAClassifier.properties"
  )

  # Stores the selected classifier for this user's session
  classifierPath <- reactiveVal(defaultClassifier)

  # Clears a browsed classifier when the genetic marker changes
  observeEvent(input$geneticMarker,
    {
      classifierPath(defaultClassifier)
    },
    ignoreInit = TRUE
  )

  # Connects the browse button to the classifier folder
  shinyFileChoose(
    input,
    id = "classifierBrowse",
    roots = classifierRoots,
    session = session,
    filetypes = c("properties"),
    defaultRoot = "Classifiers",
    defaultPath = "COI"
  )

  # Updates the saved path when a file is selected
  observeEvent(input$classifierBrowse, {
    # The button can have an initial value before a file is selected
    req(is.list(input$classifierBrowse))

    selectedFile <- parseFilePaths(
      classifierRoots,
      input$classifierBrowse
    )

    req(nrow(selectedFile) == 1)

    classifierPath(as.character(selectedFile$datapath[1]))
  })

  # Returns the selection to the default COI classifier
  observeEvent(input$resetClassifier, {
    classifierPath(defaultClassifier)
  })

  # Shows the current path below the browse button
  output$classifierPathText <- renderText({
    # The included COI path is not an external selection
    if (identical(classifierPath(), defaultClassifier)) {
      return("")
    }

    classifierPath()
  })


  # The checks and validation for the file uploads in Create
  metaworksRoot <- c(
    MetaWorks = "/home/simonr/MetaWorks"
  )
  shinyFileChoose(
    input,
    id = "fastqUploadButton",
    roots = metaworksRoot,
    session = session,
    filetypes = c("gz"),
    defaultRoot = "MetaWorks"
  )

  shinyFileChoose(
    input,
    id = "fastaUploadButton",
    roots = metaworksRoot,
    session = session,
    filetypes = c("fasta"),
    defaultRoot = "MetaWorks"
  )
  output$uploadLogText <- renderUI({
    fastqFiles <- if (is.list(input$fastqUploadButton)) {
      parseFilePaths(metaworksRoot, input$fastqUploadButton)
    } else {
      data.frame(name = character(0), datapath = character(0))
    }

    adapterFiles <- if (is.list(input$fastaUploadButton)) {
      parseFilePaths(metaworksRoot, input$fastaUploadButton)
    } else {
      data.frame(name = character(0), datapath = character(0))
    }

    filenames <- c(fastqFiles$name, adapterFiles$name)

    req(length(filenames) > 0)
    validate(
      need(
        anyDuplicated(filenames) == 0,
        "No Duplicate File Names Allowed"
      )
    )

    result <- checkFastQFiles(filenames)
    tagList(lapply(seq_along(result$outputLog), function(i) {
      tags$div(
        class = paste("logMessage", result$outputLogStatus[i]),
        result$outputLog[i]
      )
    }))
  })
}

shinyApp(ui = ui, server = server)
