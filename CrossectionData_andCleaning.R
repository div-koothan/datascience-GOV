#clear the global environment 
rm(list =ls(all = TRUE))

#load package, and load edu dataset
library(rio)
#bc it is an excel file
#you must specificy which tab, data is extracted from
edu_data <- import("education.xlsx", which = 1)

#quick peak at the dataset 
head(edu_data)

## Correcting Misspelling, Changing Variable Classes, and Sorting 
edu_data$country[edu_data$country == "Argentinaa"] = "Argentina"
edu_data$country[edu_data$country == "Afghanistanae"] = "Afghanistan"

#check the classs of year
class(edu_data$year)

#correct strange H at end of year
#keeping it in quotes, bc the class of year is character 
edu_data$year[edu_data$year == "2015H"] = "2015"

#convert year variable to numeric
edu_data$year <- as.numeric(edu_data$year)

#sort the data frame 
edu_data <- edu_data[order(edu_data$country),]

## Removing Accents and Changing File Encodings 

#changing the file encoding, before dealing with accents
#changed to UTF-8

#define function for removing accent 
remove.accents <- function(s){
  #1 character substitutions
  old1 <- "áé"
  new1 <- "ae"
  s1  <-chartr(old1,new1, s)
  
  #2 character substitutions 
  old2 <- c("ß")
  new2 <- c("ss")
  s2 <- s1
  for (i in seq_along(old2))
    s2 <-gsub(old2[1], new2[i], s2, fixed = TRUE )
  
  s2
}

#apply the remove accents function
edu_data$country <- remove.accents(edu_data$country)

#put Algeria back in English 
edu_data$country[edu_data$country == "Algerie"] = "Algeria"

#check the classes of variables
class(edu_data$year)
class(edu_data$country)
class(edu_data$primary_enroll)

## Summary Statistics Review
summary(edu_data)

#load stargazer 
library(stargazer)
stargazer(edu_data, type ="text")

## Adding Country Codes
#add the ISO-3 country codes
library(countrycode)

#creating a new variable for the dataset
edu_data$country_code = countrycode(sourcevar = edu_data$country,
                                    origin = "country.name",
                                    destination = "iso3c",
                                    warn = TRUE)

#add the country code for Kosovo
edu_data$country_code[edu_data$country == "Kosovo"] = "RKS"

## Adding World Development Indicator Data Directly from R
library(devtools)
library(remote)
library(remotes)

#working with Population Data 
library(WDI)
remove.packages("WDI")
#installing the WDI with the updated API
remotes::install_github('vincentarelbundock/WDI')

population_data <- WDI(country = "all",
                       indicator =c ("SP.POP.TOTL"),
                       start = 2015, end = 2015, extra = FALSE, cache = NULL)

## Renaming Variables 
library(data.table)
setnames(population_data, "SP.POP.TOTL", "population")

## Filtering, Piping, and Country Code Redux

#getting ISO -3 country codes for population_data df
library(countrycode)
population_data$country_code = countrycode(sourcevar = population_data$iso2c,
                                           origin = "iso2c",
                                           destination = "iso3c",
                                           warn = TRUE)
#filter out the regional and index variables
library(tidyverse)
population_data <-
  population_data %>%
  dplyr::filter(!(country_code == "NA"))

#check that everything went through w/ subset
subset(population_data, country_code == "NA")

## Merging, Dropping Variables, and More Tidyverse Commands

#mergin edu_data and population_data
library(dplyr)
merge_data <- left_join(population_data, edu_data,
                        by = c("country_code", "year"))
#check dimensions of merged df
dim(merge_data)
#check variables names
names(merge_data)

#check if the country names
#for country.x & country.y match 
library(tidyverse)
merge_data  <-
  merge_data %>%
  mutate(countries_match = 
           ifelse(country.x == country.y,
                  "yes", "no"))
#check where the country names did not match
#for country.x & country.y
subset(merge_data, countries_match == "no")

#drop country.x and reanme country.y as country
#bc the country.x had misspellng for DPRK
library(dplyr)
merge_data <-
  merge_data %>%
  select(-c("country.x")) %>%
  dplyr::rename("country" = "country.y")

#reordering the variables
#sort using relocate <- a new command 
merge_data <-
  merge_data %>%
  relocate("country", "iso2c", "country_code", 
           "year", "primary_enroll", "population")

#drop counties match variable
merge_data$countries_match = NULL

#remove the population and education df
rm(edu_data, population_data)
rm(remove.accents)

## Basic Analysis and Taking the Log(Some Review, Some New Material)
#finding NA values
table(merge_data$population, exclude = TRUE)
table(merge_data$primary_enroll, exclude = TRUE)
subset(merge_data, is.na(primary_enroll))
subset(merge_data, is.na(population))

#check for correlation
cor(merge_data$population, merge_data$primary_enroll, use ="complete.obs")

#other way to remove NAs
data_no_NAs = na.omit(merge_data, select = c("primary_enroll", 
                                             "population"))
cor(data_no_NAs$population, data_no_NAs$primary_enroll)

#check out the distributions of two variables
summary(data_no_NAs)

#check the distribution via scatter plot
library(ggplot2)
scatterplot <- ggplot(data_no_NAs,
                      aes(population, population)) +
              geom_point(stat = "identity") +
          labs(x= "Population (Inhabitants)",
               y ="Population (Inhabitants)",
               title = "Distribution of Population Data")
print(scatterplot) 

#taking the log 
data_no_NAs$log_population <- log(data_no_NAs$population + 1)

#check the distribution of the log population variables
scatterplot2 <- ggplot(data_no_NAs,
                      aes(log_population, log_population)) +
  geom_point(stat = "identity") +
  labs(x= "Population (Inhabitants)",
       y ="Population (Inhabitants)",
       title = "Distribution of Log Population Data")
print(scatterplot2) 

#re-reun our correlation
cor(data_no_NAs$log_population, data_no_NAs$primary_enroll)

## Labeling the Variables and Saving the Labeled Data Frame
library(labelled)
var_label(data_no_NAs) <- list(`country` = "country",
                               `year` = "year",
                               `primary_enroll` = "gross primary enrollment rate by population",
                               `population` = "population(inabitants)",
                               `iso2c` = "ISO-2 country code",
                               `log_population` = "log population (inhabitants)",
                               `country_code` = "ISO-3 country code")

#save the data fram as a stata dataset
library(rio)
export(data_no_NAs, "clean_dataset.dta")
