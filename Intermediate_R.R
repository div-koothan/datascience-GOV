#clear the global environment 
rm(list =ls())

#import rio
library(rio)
ps2020 <- import ("fatal-police-shootings-data.csv")

#understand the data
View(ps2020)
summary(ps2020)
head(ps2020)

#view individual variables 
table(ps2020$gender)
table(ps2020$race)

## Logic of Loops and Conditionals
#manually repeat a task to illustrate 
#choosing a number from a range
sample(0:100, 20)

#do the same thing in a loop
for (i in 1:20){
  x <- sample(0:100,1)
  print(x)
  i= i +1
}

#while loop: use example and discuss the components 
testwhile <- 1 # initialize the loop, this is the counter
while (testwhile <= 5){
  cat("We are on loop number", testwhile)
  
  #very important, must have a way to get out of the loop
  testwhile <- testwhile +1 
  print(testwhile)
}

#application of while loop to stock prices and values 
set.seed(456)
#set stock value and price 
stock <- 100
price <- 100

#a counter for the number of loops 
numloops <- 1
#Initialize the while statement 
while(price > 90){
  #Generate randome numbers between 80 and 120
  price <- stock + sample(-20:20, 1)
  #count the number of loop
  numloops <- numloops +1
  
  #print hte number of loops
  print(numloops)
}
cat('it took', numloops, 'loops before we short the price.
    The lowest price is', price)

#for loop background and application, SYNTAX
#for (i in veccotr){
#  Exp 
#}

#Create an organization vector 
orgs <- c("United Nations", "Wolrd Bank", "USAID", "DFID/UKAID")

#create the for loop
for (i in orgs){
  print(i)
}


#create a matrix 
M <- matrix(c(1:12), nrow = 4, byrow = TRUE)
print(M)
#create a matrix 
mat <-matrix(data =seq(1, 10, by=1),
             nrow = 5, ncol =2)
print(mat)

#Create the loop with r and c to iterate over the matrix 
for(r in 1:nrow(mat)) # for r in 1:5
  for(c in 1:ncol(mat))# for c in 1:2
    print(paste("Row", r, "and column",c, "have values of", mat[r,c]))

#if and else conditionals and their variants 

#ifelse example, good for something binary
DenlyAsleep <- c( 1, 1, 1, 1, 1, 1, 1, 0)
ifelse(test = DenlyAsleep ==1, yes = "Always", no = "Wow, He's Awake!")

#if-else SYNTAX 
#if (condition){
# Expr1
#} else {
  #expr2
#}

#if else example 
quantity <- 901
#set the if-else statement
if (quantity > 900){
  print("You scored well!")
} else {
  print('Try harder next time!')
}

#else if SYNTAX, adding more conditionals 
#if (condition){
#  expr1
#} else if (condition){
#  expr2
#}

#else if  examples 
quantity <- 799
#set the if-else statement
if (quantity < 800){
  print("Time to turn off Netflix!")
} else if ( quantity >= 800 & quantity <= 900) {
  print('It is coming along! Keep working on it!')
} else {
  print("You nailed it!")
}

#application of ~for and ~if/else (loop and conditional)
library(dplyr)

#creating the dummy variables for the ps2020 
ps2020$threatattack = NA
ps2020$threatattack [ps2020$threat_level == "attack"] = 1
ps2020$threatattack [ps2020$threat_level != "attack"] = 0

ps2020$raceblack = NA 
ps2020$raceblack [ps2020$race == "B"] = 1
ps2020$raceblack [ps2020$race != "B"] = 0

ps2020$armedgun = NA
ps2020$armedgun [ps2020$armed == "gun"] = 1
ps2020$armedgun [ps2020$armed != "gun"] = 0

#creating a subset of the ps2020 data 
ps2020sub <- subset(ps2020, 
                    select= c("age", "raceblack", "armedgun"))

#filtering based on age
ps2020subfilter <- filter(ps2020sub, age == 70)
View(ps2020subfilter)


#running through a 2D for loop
for (r in 1:nrow(ps2020subfilter))
  for (c in 1:ncol(ps2020subfilter))
    print(paste("Row", r, "and column", c,
                "have values of", ps2020subfilter[r,c]))

#running through a conditional for loop
for(r in 1:nrow(ps2020subfilter))
  if(ps2020subfilter [r, 3] == 1){
    print("Victim was armed")
  } else {
    print("Victim was not armed")
  }

#create a small dataset 
ps2020small <- filter(ps2020, age == 15)
View(ps2020small)
ps2020small2 <- subset(ps2020small,
                       select = c("age", "race", "armed"))

#creating the nested conditional loop 
for (r in 1:nrow(ps2020small2)) {
  for(c in 1:ncol(ps2020small2)) {
    if (ps2020small2[r,c] == "W") {
      ps2020small2[r,c] = "White"
    } else if (ps2020small2[r,c] == "B") {
      ps2020small2[r,c] = "Black"
    } else{
    }
  }
}

## Using and writing functions in R
library(foreign)
x <- cars
min(x$speed)
max(x$speed)    
min(x$dist)
max(x$dist)
mean(x$speed)
mean(x$dist)

#writing a function SYNTAX
#function_name <- function(arguments){
#  computation  on the argument
#   some other code 
#}

#creating a mean function
mean_function <- function(x){
  sum(x)/ length(x)
  }

mean_function(ps2020subfilter$armedgun)

## Simplify Loops: apply, lappy, sapply 

#apply SYNTAX
apply(x, MARGIN, FUN)

#practicing with apply
matrix1 <- matrix(c <- (1:10), nrow = 5, ncol = 6)
matrix1
matrix1_a <- apply(matrix1, 2, sum)
matrix1_a

for (c in 1:ncol(matrix1))
  print(paste("Column", c, "has values of", sum(matrix1[,c])))

#lapply is good for lists
#SYNTAX
lappy(X, FUN)

countries <- c("AFGHANISTAN", "BAHRAIN", "LESOTHO", "ZIMBABWE")
countries_lower <- lapply(countries, tolower)
str(countries)
str(countries_lower)
#changing to a vector with unlist 
countries_lower <- unlist(lapply(countries, tolower))
str(countries_lower)

#sapply SYNTAX
sapply(x, FUN)
dt <- cars
lmn_cars <- lapply(dt, min)
smn_cars <- sapply(dt, min)
print(lmn_cars)
print(smn_cars)


## Pattern Matching and Replacement 

#grep SYNTAX
grep(PATTERN, x)
#example
x <- c("INXS", "WHAM!", "KISS", "ABBA", "RUSH", "MGMT", "AC/DC", "BB KING")
grep("S", x)
#you can use the logical, like OR
grep("S|BB", x)

#sub/gsub SYNTAX
sub("old", "new", x)
gsub("old", "new", x)

sub("SS", "PP", x)
gsub("BB", "The", x)

ps2020pattern <- ps2020
View(ps2020pattern)

grep("San", ps2020pattern$city)

y <- gsub("San", "The", ps2020pattern$city)
View(y)

ps2020pattern$race <- gsub("W", "White", ps2020pattern$race)
ps2020pattern$race <- gsub("B", "Black", ps2020pattern$race)
ps2020pattern$race <- gsub("H", "Hispanic", ps2020pattern$race)

## Working with Dates and Times 
library(tidyverse)
library(lubridate)
library(nycflights13)

today()
now()

ymd("2017-01-31")
mdy("January 31st 2017")
dmy("31-Jan-2017")

#selecting information
flights %>%
  select(year, month, day, hour, minute)

#using lubridate package for make_datetime
flights %>% 
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))

#creates a dates df for ps2020
ps2020dates <- ps2020
head(ps2020dates)
str(ps2020dates)
ymd("2015-01-02")

#separating the date variables using dplyr and lubridate packages
ps2020dates <-
  ps2020dates %>%
  dplyr::mutate(year = lubridate::year(ps2020dates$date),
                 month = lubridate::month(ps2020dates$date),
                 day = lubridate::day(ps2020dates$date))
#bringing the date variables together for one date 
ps2020dates$yearmonthday <- ymd(paste(ps2020dates$year,
                            ps2020dates$month, ps2020dates$day))

## Police Data Final Summary
ps2020overview <- ps2020

ps2020overview$timestamp <- ymd(ps2020overview$date)

#creating a histogram
ggplot(ps2020overview,
       aes(x = timestamp)) +
  geom_histogram(position = 'identity', bins = 20, show.legend = FALSE)+
  coord_cartesian(ylim = c(250,350))

#getting to look at a specific variable
#creating another df
ps2020gender <- ps2020overview 
table(ps2020gender$gender)

#utilizing loops and condisiotnals to alter values
for(r in 1:nrow(ps2020gender)){
  if (ps2020gender$gender[r] == "M"){
    ps2020gender$gender[r] = "Male"
  } else if (ps2020gender$gender[r]=="F"){
    ps2020gender$gender[r] = "Female"
  } else if (ps2020gender$gender[r] == ''){
    ps2020gender$gender[r] = "Other/Unknown"
  }
}

#provide a ggplot with the new gender names 
ggplot(ps2020gender, 
       aes(x = gender))+
  geom_bar(position = "identity", show.legend = FALSE)

#creating another df for race 
ps2020race1 <- ps2020
table(ps2020race1$race)

#changing the names of the values
ps2020race1$race <- gsub("A", "Asian", ps2020race1$race)
ps2020race1$race <- gsub("B", "Black", ps2020race1$race)
ps2020race1$race <- gsub("H", "Hispanic", ps2020race1$race)
ps2020race1$race <- gsub("N", "Native American", ps2020race1$race)
ps2020race1$race <- gsub("O", "Other", ps2020race1$race)
ps2020race1$race <- gsub("W", "White", ps2020race1$race)

#creating a bar plot based on race
ggplot(ps2020race1,
       aes(x = race)) + 
  geom_bar(position = "identity", show.legend = FALSE)

#creating another df based on age
ps2020age1 <- ps2020

#using the violing geom plot
ggplot(ps2020age1, aes(ps2020race1$race, age)) + 
  geom_violin()
#fine tuning the original graph
ggplot(ps2020age1, aes(x = ps2020race1$race, y = age,
                       shape = gender,
                       color = gender)) +
  geom_violin()+
  geom_jitter(shape = 16, 
              position = position_jitter(0.2),
              alpha=0.3)

#creating another df form addtl infor
ps2020addtl <- ps2020

ps2020addtl <-
  ps2020addtl %>%
  dplyr::mutate(year = lubridate::year(ps2020addtl$date),
                month = lubridate::month(ps2020addtl$date),
                day = lubridate::day(ps2020addtl$date),
                counter = ps2020addtl$manner_of_death == "shot",
                yearmonth = paste(year,month, sep='')) %>%
  dplyr::select(year,month,day, yearmonth, age, counter)

by_month_shot <-group_by(ps2020addtl, year, month)
monthly_shot <-summarize(by_month_shot, occurrence=sum(counter, na.rm=TRUE))

#monthly$yearmonth <- NA
monthly_shot$yearmonth <-paste(monthly_shot$year,monthly_shot$month, sep="")
#monthly_shot$yearmonth <- as.numeric(monthly_shot$yearmonth)

ggplot(monthly_shot,
       aes(x = yearmonth,y = occurrence))+
  geom_point()+
  coord_cartesian(ylim =c(50,125))+
  theme(axis.text.x =element_text(size=6, angle=45),
        axis.text.y =element_text(size=6, angle=45))
