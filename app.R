library(shiny)
library(shinydashboard)
library(tidyverse)


ui = dashboardPage(
    # Dashboard Header
    dashboardHeader(title = 'JHU Faculty Survey'),
    
    # Dashboard Sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem('Dashboard', tabName = 'dashboard', icon = icon('dashboard')),
            menuItem('Question 1', tabName = 'Q1',
                     menuSubItem('Question 1a', tabName = 'Q1a'),
                     menuSubItem('Question 1b', tabName = 'Q1b')),
            menuItem('Question 2', tabName = 'Q2',
                     menuSubItem('Question 2a', tabName = 'Q2a'),
                     menuSubItem('Question 2b', tabName = 'Q2b'))
        )
    ),
    
    # Dashboard Body
    dashboardBody(
        
        fluidRow(
            box(
                title = 'Please choose the filter',
                
                checkboxGroupInput(
                    inputId = 'filter',
                    label = 'Filter',
                    choices = c('Professor' = 'Prof',
                                'Associate Professor' = 'AsoProf',
                                'Asistant Professor' = 'AsiProf')
                ),
                
                selectInput(
                    inputId = 'variable',
                    label = 'Variable',
                    choices = c('Gender' = 'gender',
                                'Ethnicity' = 'ethnicity')
                ),
                
                actionButton(inputId = 'update', label = 'Update')
            )
        ),
        
        tabItems(
            tabItem(
                tabName = 'dashboard',
                h1('Welcome!'),
                'This is dashboard'
            ),
            
            tabItem(
                tabName = 'Q1a',
                box(plotOutput('histogram'))
            ),
            
            tabItem(tabName = 'Q1b', 'This is tab1b'),
            
            tabItem(tabName = 'Q2a', 'This is tab2a'),
            
            tabItem(tabName = 'Q2b', 'This is tab2b')
        )
    )
)

server = function(input, output){
    output$histogram = renderPlot({
            ggplot(aes(x), data = data.frame(x = rnorm(100))) +
                geom_histogram()
        })
}

shinyApp(ui = ui, server = server)
