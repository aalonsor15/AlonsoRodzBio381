# Manipulating data using dplyer
# March 4, 2020
# AAR

library(tidyverse)
library(dplyr)

# What is dplyr? ----------------------------------------------------------

## new-ish package: provides a set of tools for manipulating data
## part of the tidyverse: collection of packages that share the
# same philosophy, grammar and data structure.
## specifically written to be fast!
## individual functions for most common operations
## easier to figure out what you want to do with your data


# Core verbs of dplyr -----------------------------------------------------

# filter() : filters by focusing on the content of the rows
# arrange()
# select() : allows you to select by columns
# summarize() and group_by()
# mutate() 


# working with data -------------------------------------------------------

data("starwars")
class(starwars)

# WHAT IS A TIBBLE
# 'modern take' on data frames
# keeps great aspects of df, drops frustrating ones (changing
# variable names, changing input type, etc)

glimpse(starwars) #this works better than str for tibbles
head(starwars)

# since there are NAs, let's clean up our data
# complete.cases is not part of dplyr but useful

starwarsClean <- starwars[complete.cases(starwars[,1:10]),]
is.na(starwarsClean[,1])
anyNA(starwarsClean)
anyNA(starwars)

# what does our data look like now?
glimpse(starwarsClean)
head(starwarsClean)


# filter() ----------------------------------------------------------------

### FILTER: pick/subset observations by their values
# uses >, >=, <, <=, !=, == for comparisons
# logical operators: & | !
# filter automatically excludes NAs

filter(starwarsClean, gender == "male", height < 180, height > 100)
### can use commas or &, and multiple conditions for the same variables

filter(starwarsClean, eye_color %in% c("blue", "brown"))
# %in% is similar to ==


# arrange() ----------------------------------------------------------------

### ARRANGE: reorders rows

arrange(starwarsClean, by=height)
# default is ascending order

arrange(starwarsClean, by=desc(height))
# use desc() if you want the data in descending order

arrange(starwarsClean, height, desc(mass))
# add additional argument to break ties in preceding column
# EX. order by height, but if there are 2 with same height, order 
# by mass in descending order

starwars1 <- arrange(starwars, height)
tail(starwars1) # missing values are at the end


# select() ----------------------------------------------------------------

### SELECT: choose variables by their names

starwarsClean[1:10,2] # base r code, not dplyr, to select 2nd variable
# this is basically what select does

select(starwarsClean, 1:5) #use numbers
select(starwarsClean, name:species) #use names of columns
select(starwarsClean, height, skin_color, films) 

select(starwarsClean, -(films:starships)) #exclude columns

# rearrange columns
select(starwarsClean, name, gender, species, everything())
# everything() is a helper function, useful if you want to move
# a couple of variables to the beginning

select(starwarsClean, contains("color"))
# other helpers: ends_with, starts_with, 
# matches (regular expression), num_range


# rename columns with select
select(starwars, haircolor = hair_color)
# changes hair_color to haircolor as name of column

select(starwars, haircolor = hair_color, films)

# rename function
rename(starwarsClean, haircolor=hair_color)


# mutate() ----------------------------------------------------------------

#MUTATE: creates new variables with functions of existing variables

mutate(starwarsClean, ratio = height/mass)
# we can use arithmetic operators

starwars_lbs <- mutate(starwarsClean, mass_lbs = mass*2.2)
# convert kg to lbs
head(starwars_lbs)
select(starwars_lbs, 1:3, mass_lbs, everything())
# brings mass_lbs to the beginning of the dataset

# transmute() : keeps new variable in the dataset
transmute(starwarsClean, mass_lbs = mass*2.2)

transmute(starwarsClean, mass_lbs = mass*2.2, mass)


# summarize() and group_by() ----------------------------------------------

### SUMMARIZE AND GROUP_BY: collapses values down to a single summary

summarize(starwarsClean, meanHeight = mean(height))

## working with NAs
summarize(starwars,meanHeight = mean(height)) # does not work
summarize(starwars,meanHeight = mean(height, na.rm=T)) #removes NAs
summarize(starwars,meanHeight = mean(height, na.rm=T),
          TotalNumber = n()) # use n() to calculate sample size

summarize(starwarsClean, meanHeight = mean(height), 
          TotalNumber = n())

starwarsGenders <- group_by(starwars,gender)
head(starwarsGenders)

summarize(starwarsGenders, meanHeight=mean(height,na.rm = T),
          number = n())

# Piping ------------------------------------------------------------------

## Piping is used to emphasize a sequence of actions
# takes the output of one statement and makes it the input of next statement
# in other words, passes an intermediate result onto next function
## avoid if you have meaningful intermediate results or if you want
# to manipulate more than one object at a time

## formatting: have a space before the pipe, followed by a new line
## %>%

starwarsClean %>%
  group_by(gender) %>%
  summarize(meanHeight = mean(height), number = n())

heightsSW <- starwarsClean %>%
  group_by(gender) %>%
  summarize(meanHeight = mean(height), number = n())


