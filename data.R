library(tidyverse)
library(stringr)

data_path = 'Faculty Satisfaction Survey Source Data.xlsx'

code_text = readxl::read_excel(data_path, sheet = 'Code&Text')
data.2015 = readxl::read_excel(data_path, sheet = '2015')
data.2018 = readxl::read_excel(data_path, sheet = '2018')
data.2022 = readxl::read_excel(data_path, sheet = '2022')

code_text[is.na(code_text$Text_2),]$Text_2 = ''
data.2015$year = 2015
data.2018$year = 2018
data.2022$year = 2022
num.year = 3

process = function(data){
    data %>%
        mutate(
            Q1_1 = case_when(Q1_1 %in% 1:2 ~ 1,
                             Q1_1 == 3 ~ 2,
                             Q1_1 %in% 4:5 ~ 3,
                             TRUE ~ 0),
            Q1_4 = case_when(Q1_4 %in% 1:2 ~ 1,
                             Q1_4 == 3 ~ 2,
                             Q1_4 %in% 4:5 ~ 3,
                             TRUE ~ 0),
            Q1_5 = case_when(Q1_5 %in% 1:2 ~ 1,
                             Q1_5 == 3 ~ 2,
                             Q1_5 %in% 4:5 ~ 3,
                             TRUE ~ 0),
            # 1 and 2: Very Dissatisfied or Dissatisfied
            # 3      : Neutral
            # 4 and 5: Satisfied or Very Satisfied
            
            Q8_1 = case_when(Q8_1 %in% 1:2 ~ 1,
                             Q8_1 == 3 ~ 2,
                             Q8_1 %in% 4:5 ~ 3,
                             TRUE ~ 0),
            Q8_4 = case_when(Q8_4 %in% 1:2 ~ 1,
                             Q8_4 == 3 ~ 2,
                             Q8_4 %in% 4:5 ~ 3,
                             TRUE ~ 0)
            # 1 and 2: Strongly Disagree or Disagree
            # 3      : Neutral
            # 4 and 5: Agree or Strongly Disagree
        )
}

questions = names(data.2015)[1:9]

data = rbind(pivot_longer(process(data.2015), cols = all_of(questions), names_to = 'question', values_to = 'answer'),
             pivot_longer(process(data.2018), cols = all_of(questions), names_to = 'question', values_to = 'answer'),
             pivot_longer(process(data.2022), cols = all_of(questions), names_to = 'question', values_to = 'answer'))

Ranks = c('Research Associate' = 1,
          'Clinical Instructor/Fellow' = 2,
          'Instructor' = 3,
          'Asistant Professor' = 4,
          'Associate Professor' = 5,
          'Professor' = 6)

Path = c('Basic Researcher' = 1,
         'Clinical Excellence' = 2,
         'Clinical Researcher' = 3,
         'Clinician Educator' = 4,
         'Clinician Innovator/Quality Improvement' = 5,
         'Clinical Program Builder' = 6)