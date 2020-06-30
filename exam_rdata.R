#clear the global environment 
rm(list =ls())

# set the working directory 
setwd("C:/Users/Divya Koothan/Desktop/GOV 355M")

#loading rio library to import 
library(rio)
#importing exam data
df <- import("exam_data.csv")

#creating a subset of data 
small_exam_data <- subset(df, select = c("COWcode", "year",
                                            "fh_total", "country_name", 
                                            "v2x_freexp_altinf"))
#dropping original data fram
rm(df)

#correlation of freedom house freedom score 
#and Vdem freedom of expression index
cor(small_exam_data$fh_total,small_exam_data$v2x_freexp_altinf, use = "complete.obs")

#average of freedom house freedom score 
mean(small_exam_data$fh_total)

#creating a free country dummy variable 
small_exam_data$free_country = NA 

#defining a above and below mean 
small_exam_data$free_country [small_exam_data$fh_total > 7.82] = 1
small_exam_data$free_country [small_exam_data$fh_total < 7.82] = 0

#creating a string variable regime_freedom
small_exam_data$regime_freedom = "NA"

#defining free and unfree regime 
small_exam_data$regime_freedom [small_exam_data$free_country == 1] = "free regime"
small_exam_data$regime_freedom [small_exam_data$free_country == 0] = "unfree regime"

#cross tab of v2x free expression and regime freedom
library(doBy) #loading the library to run the cross tab
summaryBy(v2x_freexp_altinf ~ regime_freedom, data = small_exam_data, FUN = c(mean, length))

#creating a line graph 
library(ggplot2) #loading the library

#creating a line graph for Colombia's Vdem freedom of expression scores 
ggplot(subset(small_exam_data, country_name == "Colombia"),
       aes(x = year,  y = v2x_freexp_altinf)) + 
         geom_line() + 
         labs(title = "Colombia's V-Dem’s freedom
of expression and alternative information index (1972-2018)", x = "Year", 
              y = "V-Dem’s freedom
of expression and alternative information index")


#creating a bar graph for Italy's Vdem freedom of expression score
ggplot(subset(small_exam_data, country_name == "Italy"),
       aes(x= year, y = v2x_freexp_altinf)) + 
  geom_bar(stat = "identity")  + 
  labs(title = "Italy's V-Dem’s freedom
of expression and alternative information index (1972-2018)", x = "Year", 
       y = "V-Dem’s freedom
of expression and alternative information index")

