#clear environment 
rm(list = ls(all = TRUE))

# set the working directory 
setwd("C:/Users/Divya Koothan/Desktop/GOV 355M")

#Basic Math
7+4 #addition
7-3 #subtraction
7*4 #multiplication
7/2 #division 

##Vectors, Sequences, Data Classes/Types 

#creating a country character vector 
country <- c("france", "france", "france", "france", "france", "france")

#creating a years vector 
year <- c(2000, 2005, 2010, 2015, 2020, 2025)

#create a year variable via a sequence 
year2 = seq(2000, 2025, 5)

rm(year2)

#inspect the print vector 
print (year)

#poverty rate variable 
poverty_rate <- c(13.6, 13.1, 14, 14.2, NA, NA)

#GDP per capita
#Consumption (C) + Income (I) + Government Expenditures (G) - (Exports - Imports) (X - M)
#C+ I + G+ (X-M)/population 
gdp_per_capita <- c(22364, 34760, 40368, 36613, NA, NA)

#classify the GDP by low or high
low_high <- c("low","low","high", "high", "NA", "NA")

#creating a factor variable 
#so R knows that low is less than high
gdp_levels <- factor(low_high, levels= c("low", "high"))

#remove the low_high string/character variable 
rm(low_high)

#check the classes(type) of our vectors 
class(country)
class(poverty_rate)
class(gdp_per_capita)
class(gdp_levels)
class(year)

##Dataframes, variables, Basic Stats, and Missing Data

#convert vectors to dataframe 
df <- data.frame(country, year, poverty_rate, gdp_per_capita, gdp_levels)

#remove vectors, so we have a dataframe
rm(country, gdp_levels, gdp_per_capita, poverty_rate, year)

#inspect the data frame remember capitalize
View(df)
head(df)
summary(df)
dim(df)

#inspects the variables individually 
summary(df$gdp_per_capita)
summary(df$poverty_rate)

#count the observations 
length(df$poverty_rate)

#count the number of unique observations 
length(unique(df$poverty_rate))

#check the class of the country variable 
class(df$country)

#change variable back to a character, overtype the data class
df$country <- as.character(df$country)
#this is how you create another variable, but change the data class
df$country_char <- as.character(df$country)
class(df$country_char)
rm(df$country_char)

#get descriptive stats of our variables
#while removing the NA empty terms 
mean(df$gdp_per_capita, na.rm = TRUE)

#assign the mean gdp per capita as another varaibles in the data frame
mean_gdp <- mean(df$gdp_per_capita, na.rm = TRUE)
print(mean_gdp)

#correlation between poverty rate and GDP per Capita 
cor(df$gdp_per_capita, df$poverty_rate, use = "complete.obs")

##Install stargazer
#one way to install, or search through packages, 
#by installing by typing out here, it will install every time
install.packages("stargazer")

#load stargazer 
library(stargazer)

#output our dataset with some descriptive stats w/ stargazer
stargazer(df, type= "text")
stargazer(df, type = "html")

#help function for stargazer 
?stargazer

#Importing Data and Intro to V-Dem Data set 
#import v_dem data set 
library(rio)
vdem <- import("V-Dem-CY-Core-v10.dta")

#which countries are included in the V-dem?
table(vdem$country_name)

#which years are in V-Dem?
summary(vdem$year)

##Subsetting and Removing Data Frames 

#subset vdem (creating a new data set from the original)
vdem2 <- subset(vdem, select = c("country_name","year",
                                 "COWcode", "v2x_polyarchy",
                                 "v2x_corr"))

#na omit missing values on the basis of democrcy and corruption
vdem3 <- na.omit(vdem2, select = c("v2x_polyarchy",
                                   "v2x_corr"))

#correlation between democracy and corruption
cor(vdem3$v2x_polyarchy, vdem3$v2x_corr)

##Creating new variables and Cross-Tabs 

#get the mean democracy score 
mean(vdem3$v2x_polyarchy)

#create a new variable: democracy dummy variable (0 or 1)
vdem3$democracy = NA # this is setting the variable to missing
#set to missing, prevents wrongly evaluating data 
vdem3$democracy [vdem3$v2x_polyarchy >= .27] = 1 #these #s are based on the cacl mean 
vdem3$democracy [vdem3$v2x_polyarchy < .27] = 0

#create autocracy dummy variable (0 or 1)
vdem3$autocracy = NA #setting variable as missing
vdem3$autocracy [vdem3$v2x_polyarchy < .27] = 1
vdem3$autocracy [vdem3$v2x_polyarchy >= .27] = 0

#create a politcal regime variable string variable 
vdem3$political_regime = "NA"
vdem3$political_regime [vdem3$democracy == 1] = "democracy"
vdem3$political_regime [vdem3$democracy == 0] = "autocracy"

#table the poltical regime 
table(vdem3$political_regime, exclude = TRUE)

#run the cross tab
library(doBy)
summaryBy(v2x_corr ~ political_regime, data = vdem3, FUN = c(mean, length))

##Saving 
#saving the dataset & newly create variables, to export into a CSV, or other file
?rio
export(vdem3, "vdem.csv") #will be saved as CSV
export(vdem3, "vdem.dta") #Stata dataset (has label)
export(vdem3, "vdem.xlsx") #saved as excel
