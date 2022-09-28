# JHU-Faculty-Survey
This is a visualization project for the JHU faculty survey using R Shiny.

## 1. Data Management

The file `Source Data.xlsx` is directly used by the interface, and the data is manually copy-pasted from each year's survey data, which I also include in the `Data` folder. For this version of the interface, the order of the questions and the question texts are based on the 2022 survey. In a survey that is from another year, the order is re-arranged so every question is aligned with the one from 2022.

The first tab of the source data is text. It includes the topic codes, topic text, question codes and question text. Topic is the general description of possibly a set of sub-questions. If a topic doesn't contain sub-questions, which means it itself is a question, the topic code and the question code are the same, and the question text is left blank, otherwise the question code will tell which specific sub-question it is.

The three following tabs `2015`, `2018` and `2022` are responses from the survey. Here I only include multiple choice questions. If short-text answer and check box answers need to be included, a different and most likely more sophisticated way of displaying the data will be required. In the `2015` and `2018` tab there are some empty columns. That is because in those years, those questions were not asked by the survey but were present in the `2022` survey. The following meta tabs contain demographic information. I only include gender, faculty rank and department. This is used for answer stratification and obviously extendable.

In the `data.R` file, tabs from the source data file are compiled into one dataframe with both survey answers and demographics for each year. Unusual data such as `3` for `gender` or `7` for faculty `rank`, and non-responses or rejected responses are set to `NA`. Before plotting, the order of levels is rearranged for better display, with corresponding labels.

Two plots are made in the interface: a survey answer results stacked barplot stratified on chosen stratification variable, and a trend of survey answer results over the years with filters. Both plots provide absolute frequency (count) and relative frequency (percentage).

## 2. Usage and Possible Improvement of the Interface

Use the interface: Locally, put `data.R` and `app.R` in the same directory with another folder named `Data` containing the file `Source Data.xlsx`. Where to store the source data file is flexible with a little change in the `data_path` in `data.R`. Or instead, this app can be hosted [online](https://www.shinyapps.io/).

The presented interface should be quite straightforward and relatively easy to use: select a question from the sidebar. For the stratified plot, choose a year, stratification variable and display mode (absolute or relative frequency). For the trend plot, select filter and display mode. If any of the plots return an error, that indicated the data is missing, i.e. the question is not available in that year.

The functionality of this app heavily depends on the structure of the source data. Since it is foreseeable that the questions of the survey will vary year by year, it is important to fix a set of questions and their order to organize the source data file. If a question is to be added or updated, the source data file and its levels and labels (in `data.R`) should also be added or updated to avoid errors.

The current version of the interface is still primitive and rigid. The improvement could focus on flexibility and expanding the displayed types of questions from only multiple choices to maybe short-text, and from only barplot to pie chart or even word cloud.
