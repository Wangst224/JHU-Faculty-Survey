# JHU-Faculty-Survey
This is a visualization project for the JHU faculty survey using R Shiny.

## 1. Data Management

The file `Source Data.xlsx` is directly used by the interface, and the data is manually copy-pasted from each year's survey data, which I also include in the `Data` folder. For this version of the interface, the order of the questions and the question texts are based on the 2022 survey. In a survey that is from another year, the order is re-arranged so every question is aligned with the one from 2022.

The first tab of the source data is text. It includes the topic codes, topic text, question codes and question text. Topic is the general description of possibly a set of sub-questions. If a topic doesn't contain sub-questions, which means it itself is a question, the topic code and the question code are the same, and the question text is left blank, otherwise the question code will tell which specific sub-question it is.

The three following tabs `2015`, `2018` and `2022` are responses from the survey. Here I only include multiple choice questions. If short-text answer and check box answers needs to be included, a different and most likely more sophisticated way of displaying the data will be required. In the `2015` and `2018` tab there are some empty columns. That is because in those years, that question were not asked by the survey but present on the `2022` survey. The following meta tabs contains demographic information. I only include gender, faculty rank and department. This is extendable.



## 2. Usage and Possible Improvement of the Interface

