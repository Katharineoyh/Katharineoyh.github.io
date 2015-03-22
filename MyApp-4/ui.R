library(shiny)

# Define survival rate of passengers on Titanic by age group application
shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel("What probably happened on Titanic"),
    
    # Sidebar with controls to select the variable to plot against age group
    sidebarPanel(
        selectInput("variable", "Choose the variable(s) to drill down to explore the survival rate of age group further:",
                list("Passenger Class" = "pclass", 
                     "Sex" = "sex", 
                     "Passenger Class and Sex" = "sex ~ pclass")),
        hr(),
        helpText("Titanic dataset is from Department of Biostatstics of",
                "Vanderbilt University.",
                "Source:",
                "//biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic3.csv"),
        
        submitButton("Update View")
    ),
                
    # Show the caption and plot of the requested variable against mpg
    mainPanel(
        
        plotOutput("agePlot"),
        
        plotOutput("psPlot"),
        
        
        h4("Summary"),
        verbatimTextOutput("summary")
    )
))
