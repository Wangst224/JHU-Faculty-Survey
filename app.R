library(shiny)
library(shinydashboard)
library(tidyverse)
source('data.R')


ui = dashboardPage(
    # Dashboard Header
    dashboardHeader(title = 'JHU Faculty Survey'),
    
    # Dashboard Sidebar
    dashboardSidebar(
        sidebarMenu(id = 'sidebar_choice',
            menuItem('Question 1', tabName = 'Q1',
                     menuSubItem('Question 1.1', tabName = 'Q1_1'),
                     menuSubItem('Question 1.2', tabName = 'Q1_2')),
            menuItem('Question 2', tabName = 'Q2',
                     menuSubItem('Question 2.1', tabName = 'Q2_1'),
                     menuSubItem('Question 2.2', tabName = 'Q2_2'))
        )
    ),
    
    # Dashboard Body
    dashboardBody(
        
        fluidRow(
            box(title = 'Please choose the condition',
                
                checkboxGroupInput(
                    inputId = 'filter',
                    label = 'Filter',
                    choices = c('Professor' = 'Prof',
                                'Associate Professor' = 'AsoProf',
                                'Asistant Professor' = 'AsiProf',
                                'Instructor' = 'Inst'),
                    selected = c('Prof', 'AsoProf', 'AsiProf', 'Inst')
                ),
                
                selectInput(
                    inputId = 'variable',
                    label = 'Variable',
                    choices = c('Overall' = 'overall',
                                'Gender' = 'gender',
                                'Race' = 'race',
                                'Path' = 'path',
                                'Rank' = 'rank')
                ),
                
                actionButton(inputId = 'update', label = 'Update')
            )
        ),
        
        tabItems(
            tabItem(tabName = 'Q1_1',
                    'This is tab 1.1',
                    textOutput('textout')
            ),
            
            tabItem(tabName = 'Q1_2',
                    'This is tab 1.2'
            ),
            
            tabItem(tabName = 'Q2_1',
                    'This is tab 2.1'
            ),
            
            tabItem(tabName = 'Q2_2',
                    'This is tab 2.2'
            )
        )
    )
)

server = function(input, output){
    
    sidebar_choice = reactive({input$sidebar_choice})
    output$textout = renderText(sidebar_choice())
}

shinyApp(ui = ui, server = server)
