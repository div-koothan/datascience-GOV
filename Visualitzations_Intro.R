#clear the global environment 
rm(list =ls())

##Examples of visual packages 
if(!require("pacman")) install.packages("pacman")

##Loading required package: pacman 
pacman :: p_load(
  tidyverse,
  foreign,
  haven,
#additions for the class
  gapminder,
  viridis
)

#Create a version of Rosling gapminder animation
  library(ggplot2)
  library(gapminder)
  library(gganimate)
p <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  theme(legend.position ='none') +
  labs(title ='Year: {frame_time}', x ='GDP per capita', y ='life expectancy') +
  transition_time(year) +
  ease_aes('linear')

animate(p, 100, 10)

##Simple Basic Plots 
library(ggplot2)

#Simple plots of univariate distribution 
df <- gapminder
str(df)
summary(df$lifeExp)

ggplot(df, 
       aes(x = lifeExp)) +
    geom_histogram()

ggplot(df, 
       aes(x = gdpPercap)) +
  geom_density()

ggplot(df, 
       aes(x = lifeExp)) +
  geom_boxplot()

ggplot(df, 
       aes(x = lifeExp)) +
  geom_bar()

##Customizing & Adding Meta-Data
ggplot(df, 
       aes (x = lifeExp)) +
  geom_histogram(bins = 60) + #changing num of bins
labs(title = "Distribution of global life expectancy, 1952 - 2007",
     subtitle= "Data source: Gapminder package",
     x = "Life expectancy in years", y = "Density")

##Density Plot Practice 
#use geom_line with density option to get graph
ggplot(df, 
       aes(x = lifeExp)) +
    geom_line( stat = "density")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
      coord_cartesian(xlim = c(0, 85)) #changes the range of x axis


#changes the line color 
ggplot(df, 
       aes(x = lifeExp)) +
  geom_line( stat = "density",
             color = "yellow")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  coord_cartesian(xlim = c(0, 85)) v

#change type of line
ggplot(df, 
       aes(x = lifeExp)) +
  geom_line( stat = "density",
             color = "darkblue", linetype = "dotdash",
             size = 2, alpha = 0.5)+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  coord_cartesian(xlim = c(0, 85))

#change theme
ggplot(df, 
       aes(x = lifeExp)) +
  geom_line( stat = "density",
             color = "darkblue")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  theme_bw()

#visualizing life expectancy for different continents 
table(df$continent)

ggplot(df, 
       aes(x = lifeExp, color = continent)) +
  geom_line( stat = "density")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  theme_bw()

#manually specify the colors 
ggplot(df, 
       aes(x = lifeExp, color = continent)) +
  geom_line( stat = "density")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  theme_bw() +
  scale_color_manual(values = c("Africa" = "darkorange",
                                 "America" = "darkblue",
                                 "Europe" = "darkgreen",
                                 "Asia" = "darkred",
                                 "Oceania" = "purple2"),
                      name = "Continent")

#changing linetype for grayscale
ggplot(df, 
       aes(x = lifeExp, linetype = continent)) +
  geom_line( stat = "density")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  theme_bw() +
  scale_color_brewer(palette = "Set1",
                     name = "Continent") +
  scale_linetype_discrete(name = "Continent")

#faceting means going into own boxes
ggplot(df, 
       aes(x = lifeExp)) +
  geom_line( stat = "density")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  theme_bw() +
  #facet_wrap(~ continent, nrow = 1)
  facet_grid(year ~ continent, scales = "free_y")

#removing Oceaning, to take away the factor that skews
ggplot(subset(df,continent != "Oceania"), 
       aes(x = lifeExp)) +
  geom_line( stat = "density")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  theme_bw() +
  facet_grid(year ~ continent)

##Relationships in Scatterplots 
ggplot(df, 
       aes(x = gdpPercap,
           y = lifeExp)) + 
      geom_point() +
  labs(title = "Economic wealth and life expectancy",
       x = "GDP per capita",
       y = "life expectancy") + 
    theme_light()
  
#how to utilize attributes to make better visualize
ggplot(df, 
       aes(x = gdpPercap,
           y = lifeExp)) + 
  geom_point(alpha = 0.4, size = 0.5) +
  labs(title = "Economic wealth and life expectancy",
       x = "GDP per capita",
       y = "life expectancy") + 
  theme_light()

#look at untransformed data 
av = mean(df$gdpPercap)
av
ggplot(df,
       aes(x = gdpPercap)) + 
  geom_line(stat = "density") +
  labs(title = "Untransformed distribution") + 
  geom_vline(xintercept = 3000, color = "red")

#log gdpPercapita and look as distribution 
ggplot(df,
       aes(x = log10(gdpPercap))) + 
  geom_line(stat = "density") +
  labs(title = "Applying log10 to variable directly") + 
  geom_vline(xintercept = log10(av), color = "red")

#applying log to a scatter plot to normalize data
#also changes the shape 
ggplot(df, 
       aes(x = log(gdpPercap),
           y = lifeExp)) + 
  geom_point(alpha = 0.4, size = 0.5, shape = 4) +
  labs(title = "Economic wealth and life expectancy",
       x = "GDP per capita",
       y = "life expectancy") + 
  theme_light()

#use shapes to differentiate continents & color
ggplot(df, 
       aes(x = log(gdpPercap),
           y = lifeExp, shape = continent, color = continent)) + 
  geom_point() +
  labs(title = "Economic wealth and life expectancy",
       x = "GDP per capita",
       y = "life expectancy") + 
  theme_light()

#fit a line to the data
ggplot(df, 
       aes(x = log(gdpPercap),
           y = lifeExp)) + 
  geom_point(alpha = 0.4, size = 0.5) +
  labs(title = "Economic wealth and life expectancy",
       x = "GDP per capita",
       y = "life expectancy") + 
  theme_light() + 
  geom_smooth()

#fitting a different line with a differnt method
ggplot(df, 
       aes(x = log(gdpPercap),
           y = lifeExp)) + 
  geom_point(alpha = 0.4, size = 0.5) +
  labs(title = "Economic wealth and life expectancy",
       x = "GDP per capita",
       y = "life expectancy") + 
  theme_light() + 
  geom_smooth(method = "lm")

cor(df$gdpPercap, df$lifeExp)  

#try a line plot, that is 2D, with time on x-axis
ggplot(subset(df, country == "China"), 
       aes(x = year, y = gdpPercap)) + 
  geom_line() +
  geom_point() 
  
  ggplot(df, 
         aes( x = log(gdpPercap), y = lifeExp,
              color = continent, shape = continent)) +
           geom_point(alpha = .2, size =1) + 
  labs(title = "Economic wealth and life expectancy",
                    x = "GDP per capita", 
            y = "life expectancy") + 
           theme_light() + 
           geom_smooth(method = "lm")

#Saving Visuals 
ggplot(subset(df,continent != "Oceania"), 
       aes(x = lifeExp)) +
  geom_line( stat = "density")+
  labs(title = "Distribution of global life expectancy, 1952 - 2007",
       subtitle = "Data source: Gapminder package",
       x = "Life expectancy in years",
       y = "Density") +
  theme_bw() +
  facet_grid(year ~ continent)

getwd()
ggsave("C:/Users/Divya Koothan/Desktop/GOV 355M/life_expectancy.png")
ggsave("C:/Users/Divya Koothan/Desktop/GOV 355M/economicwealth_lifeexpectancy.png")

##Illustrating Regression Results 
library(broom)
mod1 <- lm(log(lifeExp) ~ log(pop)+ 
             log(gdpPercap)+ factor(continent)+
             factor(year), data = df)
summary(mod1)

#coefficent plots 
df_mod1 <- tidy(mod1)

ggplot(df_mod1, 
       aes(x = term, y = estimate)) + 
  geom_point() + coord_flip()

library(dplyr)
#drop the intercept, add a line for y intercept 
df_mod1 %>%
  dplyr :: filter(term != "(Intercept)") %>%
  ggplot(aes(x= term, y = estimate)) +
  geom_hline(yintercept = 0, color = "grey") +
  geom_point()

#add error bars and control intervals 
df_mod1 %>%
  dplyr :: filter(term != "(Intercept)") %>%
  ggplot(aes(x= term, y = estimate)) +
  geom_hline(yintercept = 0, color = "grey") +
  geom_point() +
  geom_linerange(aes(ymin = estimate - 1.96*std.error, ymax = estimate + 1.96*std.error, size = 1.2)) +
  geom_linerange(aes(ymin = estimate - 1.65*std.error, ymax = estimate + 1.65*std.error, size = 1.2))

#creating another regression model 
mod2 <- lm(lifeExp ~ pop*gdpPercap, data = df)
summary(mod2)

#creating another data frame
df_new <- data.frame(expand.grid(pop = seq(min(df$pop), 
                    max(df$pop), 1000000), 
                    gdpPercap = c(quantile(df$gdpPercap, 0.25),
                                  quantile(df$gdpPercap, 0.75))))

pred <- predict(mod2, df_new, se = TRUE)
df_pred <- cbind(df_new,pred)

## Commenting on Illustrating Regression Results 
library(broom)

mod1 <- lm(log(lifeExp) ~ log(pop) + log(gdpPercap) + factor(continent) + factor(year), data = df)
summary(mod1)
df_mod1 <- tidy(mod1)

#creating the original data plot
ggplot(df_mod1,
       aes(term, estimate)) +
  geom_point()

library(dplyr)
#using dplyr to further design the data plot, as to improve the scale of Y
df_mod1 %>%
  dplyr::filter(term != "(Intercept)") %>%
  ggplot(aes(term, estimate)) +
  geom_hline(yintercept = 0, color = "grey") +
  geom_point()

#adding the confidence intervals
df_mod1 %>%
  dplyr::filter(term != "(Intercept)") %>%
  ggplot(aes(x = term,  y = estimate)) +
  geom_hline(yintercept = 0, color = "grey") +
  geom_point() +
  geom_linerange(aes(ymin = estimate -1.96* std.error, ymax = estimate + 1.96 *std.error)) +
  geom_linerange(aes(ymin = estimate -1.65*std.error, ymax = estimate + 1.65 *std.error),
                 size = 1.2)
#fixing the x axis, to make less crowded
df_mod1 %>%
  dplyr::filter(term != "(Intercept)") %>%
  ggplot(aes(x = term,  y = estimate)) +
  geom_hline(yintercept = 0, color = "grey") +
  geom_point() +
  geom_linerange(aes(ymin = estimate -1.96* std.error, ymax = estimate + 1.96 *std.error)) +
  geom_linerange(aes(ymin = estimate -1.65*std.error, ymax = estimate + 1.65 *std.error),
                 size = 1.2) +
  coord_flip() +
  labs(x = '', y= "OLS coefficeint with 90% and 95% CIs")
  