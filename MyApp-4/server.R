library(shiny)

# We will read/load the titanic data set from the website. Since this doesn't
# rely on any user inputs we can do this once at startup and then use the
# value throughout the lifetime of the application

titanic <- read.csv("http://biostat.mc.vanderbilt.edu/wiki/pub/Main/DataSets/titanic3.csv")
titanic$age.group <- as.integer(cut(titanic$age, 10))

# calculate survival rate for different combination of class, 
# age group, and sex
library(plyr)
library(ggplot2)
td <- ddply(titanic, c("pclass", "age", "age.group", "sex"), summarise,
            total = length(survived),
            svv = length(survived[survived == 1]),
            probability.survival = svv/total)



## p6 + geom_point(aes(colour = pclass)) + facet_grid(sex ~ pclass)

# Define server logic required to plot various variables to slice and dice further to explore the dataset.
shinyServer(function(input, output) {
      
    # Generate a summary of the dataset
    output$summary <- renderPrint({
            summary(td)
    })
    
    # Generate the scatter plot of suvival rate by age group using Base Graphics
    output$agePlot <- renderPlot({
        plot(probability.survival ~ age.group, 
                data = td, main ="Probability of Survival of Different Age Group (Basic Scatter Plot)")

    })
        
    # Generate the survival rate plot of age by drilling down using ggplot2
    output$psPlot <- reactivePlot(function() {
        # check for the input variable
        if (input$variable == "pclass") {
            # pClass
            
        ps <- ggplot(td, aes(x = age.group, y = probability.survival)) + 
            geom_point(aes(colour = factor(pclass))) + 
            ggtitle("Probability of Survival of Different Age Group - drill down (using ggplot2)") +
            theme(legend.position = "top", legend.direction = "horizontal", 
                  plot.title = element_text(face="bold")) +
            scale_x_continuous("Age Group (Divided into 10 interval groups)")
        
        } else(
        
        if (input$variable == "sex") {
            # sex
            
        ps <- ggplot(td, aes(x = age.group, y = probability.survival)) + 
            geom_point(aes(colour = factor(sex))) + 
            ggtitle("Probability of Survival of Different Age Group - drill down (using ggplot)") +
            theme(legend.position = "top", legend.direction = "horizontal", 
                  plot.title = element_text(face="bold")) +
            scale_x_continuous("Age Group (Divided into 10 interval groups)")
        }
        
        else {
            # pClass and sex
            ps <- ggplot(td, aes(x = age.group, y = probability.survival)) + 
                geom_point(aes(colour = factor(pclass), shape = sex)) + 
                facet_grid(sex ~ pclass) + 
                ggtitle("Probability of Survival of Different Age Group - drill down (using ggplot2)") +
                theme(legend.position = "top", legend.direction = "horizontal", 
                      plot.title = element_text(face="bold")) +
                scale_x_continuous("Age Group (Divided into 10 interval groups)")
        })
        
        print(ps)
    })
  
})
