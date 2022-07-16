library(shiny)
library(shinydashboard)
library(tidyverse)
source('data.R')

Ranks = c('Research Associate' = 'ResAso',
          'Clinical Instructor' = 'ClinIns',
          'Instructor' = 'Inst',
          'Asistant Professor' = 'AsiProf',
          'Associate Professor' = 'AsoProf',
          'Professor' = 'Prof')

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
                    inputId = 'rankfilter',
                    label = 'Filter by Rank',
                    choices = Ranks,
                    selected = Ranks
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
                
                actionButton(inputId = 'reset', label = 'Reset')
            )
        ),
        
        h3(textOutput('title')),
        
        verbatimTextOutput('tab')
    )
)

server = function(input, output){
    
    question.code = reactive({input$sidebar_choice})
    question.index = reactive({match(question.code(), question.codes)})
    question.text = reactive({question.texts[question.index()]})
    
    data = reactive({
        sourcedata[,c(question.index(), 5,6)] %>% filter(rank %in% match(input$rankfilter, Ranks))
    })
    
    output$title = renderText({paste(question.code(), ': ', question.text())})
    
    variable = reactive({input$variable})
    observe({print(variable())})
    
    result.table = reactive({
        if (variable() == 'overall'){
            table(data()[,question.code()])
        }
        else{
            table(data()[,c(question.code(),variable())])
        }
        
    })
    
    output$tab = renderPrint({result.table()})
}

shinyApp(ui = ui, server = server)
