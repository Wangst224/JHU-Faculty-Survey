library(shiny)
library(shinydashboard)
library(tidyverse)
source('data.R')

options(dplyr.summarise.inform = FALSE)

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
                    inputId = 'rank_filter',
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
                    label = 'Choose Stratification Variable for Positive Answers',
                    choices = c('Rank' = 'rank')
                                #'Race' = 'race',
                                #'Gender' = 'gender')
                ),
                plotOutput('plot_2')
                
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
        data$rank %in% input$rank_filter
    })
    
    output$plot_1 = renderPlot({
        data[data.filter(),] %>%
            group_by(answer, year) %>%
            summarise(n = n()) %>%
            mutate(year.sums = (data[data.filter(),] %>%
                                    group_by(year) %>%
                                    summarise(n = n()))$n,
                   percent = n/year.sums) %>%
            
            ggplot(aes(x = factor(answer), y = percent)) +
            geom_bar(aes(fill = factor(year)), stat = 'identity', position = 'dodge') +
            geom_text(aes(label = paste(round(100*percent, 2), '%', sep = ''), group = factor(year)),
                      position = position_dodge(width = 1), vjust = -0.5) +
            scale_y_continuous(labels = scales::percent) +
            labs(x = 'Answers', y = 'Percentage', fill = 'Year')
    })
    
    plot.list = reactive({
        list(
            
            'rank' = left_join(
                data[data.filter(),] %>%
                    group_by(rank, answer, year) %>%
                    summarise(n = n()) %>%
                    group_by(rank, year) %>%
                    summarise(S = sum(n)),
                
                data[data.filter(),] %>%
                    filter(answer == 3) %>%
                    group_by(rank, year) %>%
                    summarise(n = n()),
                
                by = c('rank', 'year')
            ) %>% mutate(percent = n/S) %>%
                    
                    ggplot(aes(x = factor(rank), y = percent)) +
                    geom_bar(aes(fill = factor(year)), stat = 'identity', position = 'dodge') +
                    geom_text(aes(label = paste(round(100*percent, 2), '%', sep = ''), group = factor(year)),
                              position = position_dodge(width = 1), vjust = -0.5) +
                    scale_y_continuous(labels = scales::percent) +
                    labs(x = '', y = 'Percentage', fill = 'Year')
        )
    })
    
    output$plot_2 = renderPlot({plot.list()[[input$variable]]})
}

shinyApp(ui = ui, server = server)
