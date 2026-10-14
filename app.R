library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "My dashboard",
  sidebar = "Tools",
  "Main Content Area"
)

server <- function(input, output, session){

}

shinyApp(ui, function(input, output) {})