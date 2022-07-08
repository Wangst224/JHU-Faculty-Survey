library(tidyverse)
library(stringr)

sourcedata_path = 'D:/Default_Working_Directory/Data/JHU_Survey/FSS Final Dataset 5-19-2022 Raw Data - Includes Demographics and Pre-loaded Data.xlsx'
sourcedata = readxl::read_excel(sourcedata_path)[,-1]

# Temporary
sourcedata = sourcedata[,c(1:4, 34, 107)]

question.codes = c('Q1_1', 'Q1_2',
                  'Q2_1', 'Q2_2')

question.texts = c('Q1_1' = 'Being a faculty member at the Johns Hopkins School of Medicine',
                  'Q1_2' = 'Your career progression at the Johns Hopkins School of Medicine',
                  
                  'Q2_1' = 'To increase your salary',
                  'Q2_2' = 'To improve your prospects for promotion')

colnames(sourcedata) = c(question.codes, 'rank', 'gender')
