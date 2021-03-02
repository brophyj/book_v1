#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    # Application title
    titlePanel("Positive Predictive Value for a True Relationship"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("R", "Odds ratio for positive relationship:",
                        min = .001, max = 1, value = .1),
            sliderInput("alpha", "Type I error",min = .01, max = .1, value = .05),
            sliderInput("beta", "Type II error", min = .01,max = .30, value = .2) 
                    ),
        mainPanel(
            tabsetPanel(tabPanel('Table', tableOutput(outputId="A")))
            )
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$A <- renderTable({
        A <- (1000*(1 - input$beta)*input$R + input$u*1000*beta*input$R)/(input$R + 1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)   




