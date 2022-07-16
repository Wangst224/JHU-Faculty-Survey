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
                     menuSubItem('Question 1.4', tabName = 'Q1_4'),
                     menuSubItem('Question 1.5', tabName = 'Q1_5')),
            menuItem('Question 4', tabName = 'Q4',
                     menuSubItem('Question 4.1', tabName = 'Q4_1'),
                     menuSubItem('Question 4.2', tabName = 'Q4_2')),
            menuItem('Question 8', tabName = 'Q8',
                     menuSubItem('Question 8.1', tabName = 'Q8_1'),
                     menuSubItem('Question 8.4', tabName = 'Q8_4')),
            menuItem('Question 9', tabName = 'Q9'),
            menuItem('Question 10', tabName = 'Q10')
        )
    ),
    
    # Dashboard Body
    dashboardBody(
        
        fluidRow(
            h3(textOutput('text_1')),
            h4(textOutput('text_2'))
        ),
        
        fluidRow(
            box(
                width = 6,
                
                checkboxGroupInput(
                    inputId = 'rank',
                    label = 'Filter by Rank',
                    choices = Ranks,
                    selected = Ranks
                ),
                plotOutput('plot_1')
            ),
                
            box(
                width = 6,
                selectInput(
                    inputId = 'variable',
                    label = 'Choose Display Variable',
                    choices = c('Overall' = 'overall',
                                'Gender' = 'gender',
                                'Race' = 'race',
                                'Path' = 'path',
                                'Rank' = 'rank')
                )    
                
            )
            
        )
        
    )
)

server = function(input, output){
    
    # Page Title
    question.code = reactive({input$sidebar_choice})
    output$text_1 = renderText({code_text[code_text$Code == question.code(),]$Text_1})
    output$text_2 = renderText({code_text[code_text$Code == question.code(),]$Text_2})
    
    # Plot
    data.filter = reactive({
        data$answer != 0 &
        data$question == question.code() &
        data$rank %in% input$rank
    })
    
    output$plot_1 = renderPlot({
        data[data.filter(),] %>%
            group_by(answer, year) %>%
            summarise(n = n()) %>%
            mutate(year.sums = (data[data.filter(),] %>%
                                    group_by(year) %>%
                                    summarise(n = n()))$n,
                   percent = n/year.sums) %>%
            
            ggplot() +
            geom_bar(aes(x = factor(answer), y = percent, fill = factor(year)),
                     stat = 'identity', position = 'dodge')
    })
    
    output$plot_2 = renderPlot({
        
    })
    
}

shinyApp(ui = ui, server = server)
