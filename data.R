library(tidyverse)

data_path = './Data/Source Data.xlsx'

text = readxl::read_excel(data_path, sheet = 'text')
data.2015 = cbind(readxl::read_excel(data_path, sheet = '2015'), readxl::read_excel(data_path, sheet = '2015_meta'))
data.2018 = cbind(readxl::read_excel(data_path, sheet = '2018'), readxl::read_excel(data_path, sheet = '2018_meta'))
data.2022 = cbind(readxl::read_excel(data_path, sheet = '2022'), readxl::read_excel(data_path, sheet = '2022_meta'))

data.2015$year = 2015
data.2018$year = 2018
data.2022$year = 2022

data = rbind(data.2015, data.2018, data.2022)

text[is.na(text)] = ''
data[data$gender == 3,]$gender = -1
data[data$rank == 7,]$rank = -1
data[data <= 0] = NA

topic.code = text$topic_code
question.code = text$question_code
topic = text$topic
question = text$question

Years = c(2015, 2018, 2022)

Gender = c('Female' = 1,
           'Male' = 2)

Ranks = c('Research Associate' = 1,
          'Clinical Instructor/Fellow' = 2,
          'Instructor' = 3,
          'Asistant Professor' = 4,
          'Associate Professor' = 5,
          'Professor' = 6)

# Below are for plots

list.levels.fill = list('Q1' = 5:1,
                        'Q2' = 3:1,
                        'Q4' = 5:1,
                        'Q5' = 1:9,
                        'Q6' = 5:1,
                        'Q8' = 1:2,
                        'Q9' = 5:1,
                        'Q10' = 1:2,
                        'Q11' = 1:2,
                        'Q16' = 5:1,
                        'Q17' = 1:2,
                        'Q19' = 1:2,
                        'Q21' = 1:2,
                        'Q24' = 5:1)

list.labels.fill = list('Q1' = c('Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very Dissatisfied'),
                        'Q2' = c('To a Great Extent', 'To Some Extent', 'Not at All'),
                        'Q4' = c('Very Likely', 'Likely', 'Neutral', 'Unlikely', 'Very Unlikely'),
                        'Q5' = c('Salary', 'Lack of Resources to Do Your Job Effectively',
                                 'Barriers to Promotion', 'Barriers to Leadership', 'Lack of Extramural Funding',
                                 'Retirement', 'Not Feeling Valued', 'Family Reasons', 'Others'),
                        'Q6' = c('Strongly Agree', 'Agree', 'Neutral', 'Disagree', 'Strongly Disagree'),
                        'Q8' = c('Yes', 'No'),
                        'Q9' = c('Always', 'Frequently', 'Sometimes', 'Rarely', 'Never'),
                        'Q10' = c('Yes', 'No'),
                        'Q11' = c('Yes', 'No'),
                        'Q16' = c('Strongly Agree', 'Agree', 'Neutral', 'Disagree', 'Strongly Disagree'),
                        'Q17' = c('Yes', 'No'),
                        'Q19' = c('Yes', 'No'),
                        'Q21' = c('Yes', 'No'),
                        'Q24' = c('Very Satisfied', 'Satisfied', 'Neutral', 'Dissatisfied', 'Very Dissatisfied'))

list.levels.y = list('gender' = 1:2,
                     'rank' = 1:6,
                     'department' = 1:34)

list.labels.y = list('gender' = c('Female', 'Male'),
                     'rank' = c('Research Associate', 'Clinical Instructor/Fellow', 'Instructor',
                                'Asistant Professor', 'Associate Professor', 'Professor'),
                     'department' = c('Anesthesiology and Critical Care Medicine', 'Art as Applied to Medicine',
                                      'Biological Chemistry', 'Biomedical Engineering', 'Biophysics and Biophysical Chemistry',
                                      'Cell biology', 'Dermatology', 'Emergency Medicine', 'Genetic Medicine',
                                      'Health Sciences Informatics', 'History of Medicine', 'Medicine',
                                      'Molecular and Comparative Pathobiology', 'Molecular Biology and Genetics',
                                      'Neurology', 'Neuroscience', 'Neurosurgery', 'Obstetrics and Gynecology',
                                      'Oncology', 'Ophthalmology', 'Orthopaedic Surgery', 'Otolaryngology/Head and Neck Surgery',
                                      'Pathology', 'Pediatrics', 'Pharmacology and Molecular Science',
                                      'Physical Medicine and Rehabilitation', 'Physiology', 'Plastic Surgery',
                                      'Psychiatry and Behavioral Sciences',
                                      'Radiation Oncology and Molecular Radiation Sciences',
                                      'Radiology and Radiological Sciences', 'Surgery', 'Urology', 'Other'))

get.FreqTable = function(data, strat.var, answer.var){
    
    # This relative frequency is within each level of the stratification variable.
    # For example, the percentage of each answer (satisfaction) within the males.
    # The sum of relative frequency within each stratification level should be one.
    FreqTable = table(data[,strat.var], data[,answer.var])
    FreqTable.Rel = FreqTable/rowSums(FreqTable)
    
    data.freq = as.data.frame(FreqTable)
    data.freq.rel = as.data.frame(FreqTable.Rel)
    
    colnames(data.freq) = c(strat.var, answer.var, 'freq')
    colnames(data.freq.rel) = c(strat.var, answer.var, 'freq.rel')
    
    return(inner_join(data.freq, data.freq.rel, by = c(strat.var, answer.var)))
}

get.plot.strat = function(data, strat.var, answer.var){
    data.plot = get.FreqTable(data, strat.var, answer.var)
    
    # When Department is chosen to be the stratification variable, only show tenured track faculty.
    if (strat.var == 'department'){
        data.plot = get.FreqTable(data[data$rank %in% 5:6, ], strat.var, answer.var)
    }
    
    levels.y = list.levels.y[[strat.var]]
    labels.y = list.labels.y[[strat.var]]
    levels.fill = list.levels.fill[[topic.code[question.code == answer.var]]]
    labels.fill = list.labels.fill[[topic.code[question.code == answer.var]]]
    
    strat.var = sym(strat.var)
    answer.var = sym(answer.var)
    
    fig.freq = ggplot(data = data.plot,
                      aes(x = freq,
                          y = factor(!!strat.var,
                                     levels = levels.y,
                                     labels = labels.y),
                          fill = factor(!!answer.var,
                                        levels = levels.fill,
                                        labels = labels.fill))) +
        geom_bar(position = 'stack', stat = 'identity', color='black', width = 0.9) +
        geom_text(aes(label = freq), position = position_stack(vjust = 0.5), size = 3.5) +
        scale_fill_brewer(palette = 'PuOr') +
        labs(y = str_to_title(strat.var), x = 'Frequency', fill = '')
    
    fig.freq.rel = ggplot(data = data.plot,
                          aes(x = freq.rel,
                              y = factor(!!strat.var,
                                         levels = levels.y,
                                         labels = labels.y),
                              fill = factor(!!answer.var,
                                            levels = levels.fill,
                                            labels = labels.fill))) +
        geom_bar(position = 'fill', stat = 'identity', color='black', width = 0.9) +
        scale_x_continuous(labels = scales::percent) +
        geom_text(aes(label = paste(round(freq.rel*100), "%", sep = '')), position = position_stack(vjust = 0.5), size = 3.5) +
        scale_fill_brewer(palette = 'PuOr') +
        labs(y = str_to_title(strat.var), x = 'Relative Frequency', fill = '')
    
    return(list(strat.freq = fig.freq,
                strat.freq.rel = fig.freq.rel))
}

get.plot.trend = function(data, answer.var){
    data.plot.trend = get.FreqTable(data, 'year', answer.var)
    levels.fill = list.levels.fill[[topic.code[question.code == answer.var]]]
    labels.fill = list.labels.fill[[topic.code[question.code == answer.var]]]
    
    answer.var = sym(answer.var)
        
    fig.trend.freq = ggplot(data = data.plot.trend,
                            aes(x = freq,
                                fill = factor(!!answer.var,
                                           levels = levels.fill,
                                           labels = labels.fill),
                                y = factor(year, levels = rev(Years)))) +
        geom_bar(position = 'stack', stat = 'identity', color='black', width = 0.9) +
        geom_text(aes(label = freq), position = position_stack(vjust = 0.5), size = 3.5) +
        scale_fill_brewer(palette = 'PuOr') +
        labs(y = 'Year', x = 'Frequency', fill = '')
    
    fig.trend.freq.rel = ggplot(data = data.plot.trend,
                                aes(x = freq.rel,
                                    fill = factor(!!answer.var,
                                                  levels = levels.fill,
                                                  labels = labels.fill),
                                    y = factor(year, levels = rev(Years)))) +
        geom_bar(position = 'fill', stat = 'identity', color='black', width = 0.9) +
        scale_x_continuous(labels = scales::percent) +
        geom_text(aes(label = paste(round(freq.rel*100), "%", sep = '')), position = position_stack(vjust = 0.5), size = 3.5) +
        scale_fill_brewer(palette = 'PuOr') +
        labs(y = 'Year', x = 'Relative Frequency', fill = '')
    
    return(list(trend.freq = fig.trend.freq,
                trend.freq.rel = fig.trend.freq.rel))
}



















