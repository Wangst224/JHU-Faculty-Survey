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
                     menuSubItem('Question 1.2', tabName = 'Q1_2'),
                     menuSubItem('Question 1.3', tabName = 'Q1_3'),
                     menuSubItem('Question 1.4', tabName = 'Q1_4'),
                     menuSubItem('Question 1.5', tabName = 'Q1_5'),
                     menuSubItem('Question 1.6', tabName = 'Q1_6')),
            
            menuItem('Question 2', tabName = 'Q2',
                     menuSubItem('Question 2.1' , tabName = 'Q2_1'),
                     menuSubItem('Question 2.2' , tabName = 'Q2_2'),
                     menuSubItem('Question 2.3' , tabName = 'Q2_3'),
                     menuSubItem('Question 2.4' , tabName = 'Q2_4'),
                     menuSubItem('Question 2.5' , tabName = 'Q2_5'),
                     menuSubItem('Question 2.6' , tabName = 'Q2_6'),
                     menuSubItem('Question 2.7' , tabName = 'Q2_7'),
                     menuSubItem('Question 2.8' , tabName = 'Q2_8'),
                     menuSubItem('Question 2.9' , tabName = 'Q2_9'),
                     menuSubItem('Question 2.10', tabName = 'Q2_10'),
                     menuSubItem('Question 2.11', tabName = 'Q2_11'),
                     menuSubItem('Question 2.12', tabName = 'Q2_12'),
                     menuSubItem('Question 2.13', tabName = 'Q2_13'),
                     menuSubItem('Question 2.14', tabName = 'Q2_14')),
            
            menuItem('Question 4', tabName = 'Q4'),
            menuItem('Question 5', tabName = 'Q5'),
            
            menuItem('Question 6', tabName = 'Q6',
                     menuSubItem('Question 6.1' , tabName = 'Q6_1'),
                     menuSubItem('Question 6.2' , tabName = 'Q6_2'),
                     menuSubItem('Question 6.3' , tabName = 'Q6_3'),
                     menuSubItem('Question 6.4' , tabName = 'Q6_4'),
                     menuSubItem('Question 6.5' , tabName = 'Q6_5'),
                     menuSubItem('Question 6.6' , tabName = 'Q6_6')),
            
            menuItem('Question 8', tabName = 'Q8'),
            menuItem('Question 9', tabName = 'Q9'),
            menuItem('Question 10', tabName = 'Q10'),
            menuItem('Question 11', tabName = 'Q11'),
            
            menuItem('Question 16', tabName = 'Q16',
                     menuSubItem('Question 16.1' , tabName = 'Q16_1'),
                     menuSubItem('Question 16.2' , tabName = 'Q16_2'),
                     menuSubItem('Question 16.3' , tabName = 'Q16_3'),
                     menuSubItem('Question 16.4' , tabName = 'Q16_4'),
                     menuSubItem('Question 16.5' , tabName = 'Q16_5'),
                     menuSubItem('Question 16.6' , tabName = 'Q16_6')),
            
            menuItem('Question 17', tabName = 'Q17'),
            menuItem('Question 19', tabName = 'Q19'),
            menuItem('Question 21', tabName = 'Q21'),
            
            menuItem('Question 24', tabName = 'Q24',
                     menuSubItem('Question 24.3' , tabName = 'Q24_3'),
                     menuSubItem('Question 24.4' , tabName = 'Q24_4'),
                     menuSubItem('Question 24.5' , tabName = 'Q24_5'))
        )
    ),
    
    # Dashboard Body
    dashboardBody(
        
        fluidRow(
            h3(textOutput('topic')),
            h4(textOutput('question'))
        ),
        
        fluidRow(
            box(
                width = 3,
                selectInput(
                    inputId = 'year',
                    label = 'Choose Year',
                    choices = c(2015, 2018, 2022)
                ),
                selectInput(
                    inputId = 'variable',
                    label = 'Choose Stratification Variable',
                    choices = c('Gender' = 'gender',
                                'Rank' = 'rank',
                                'Department (Tenured Faculty Only)' = 'department')
                ),
                selectInput(
                    inputId = 'mode.strat',
                    label = 'Choose Display Mode',
                    choices = c('Frequency' = 'frequency',
                                'Relative Frequency' = 'rel.frequency')
                )
            ),
            box(
                width = 9,
                plotOutput('fig_strat')
            )
        ),
        
        fluidRow(
            box(
                width = 3,
                
                checkboxGroupInput(
                    inputId = 'rank_filter',
                    label = 'Filter by Rank',
                    choices = Ranks,
                    selected = Ranks
                ),
                
                checkboxGroupInput(
                    inputId = 'gender_filter',
                    label = 'Filter by Gender',
                    choices = Gender,
                    selected = Gender
                ),
                
                selectInput(
                    inputId = 'mode.trend',
                    label = 'Choose Display Mode',
                    choices = c('Frequency' = 'frequency',
                                'Relative Frequency' = 'rel.frequency')
                )
                
            ),
            
            box(
                width = 9,
                plotOutput('fig_trend')
            )
        )
    )
)

server = function(input, output){
    
    # Page Title
    output$topic = renderText({topic[question.code == input$sidebar_choice]})
    output$question = renderText({question[question.code == input$sidebar_choice]})

    # Filter for Trend Plot
    Filter = reactive({
        data$rank %in% input$rank_filter &
        data$gender %in% input$gender_filter
    })    
    
    # Plot
    output$fig_strat = renderPlot({
        if (input$mode.strat == 'frequency'){
            get.plot.strat(data[data$year == input$year,], input$variable, input$sidebar_choice)[['strat.freq']]
        }
        else{
            get.plot.strat(data[data$year == input$year,], input$variable, input$sidebar_choice)[['strat.freq.rel']]
        }
    })
    
    output$fig_trend = renderPlot({
        if (input$mode.trend == 'frequency'){
            get.plot.trend(data[Filter(),], input$sidebar_choice)[['trend.freq']]
        }
        else{
            get.plot.trend(data[Filter(),], input$sidebar_choice)[['trend.freq.rel']]
        }
    })
}

shinyApp(ui = ui, server = server)
