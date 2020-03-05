# Manipulating data using dplyer - Part 2
# March 5, 2020
# AAR

library(tidyverse)
library(dplyr)


# Exporting and Importing Data --------------------------------------------

data("starwars")
starwars1 <- select(starwars, name:species)

# write.table -- creating a csv file
write.table(starwars1, file = "starwarsNamesInfo.csv", 
            row.names = F, sep =',')
# you can view the file now in Rstudio and make comments on top
# use hashtag before comments as if you're in an Rscript

data <- read.csv(file="StarwarsNamesInfo.csv", header = T, 
                 sep = ',', stringsAsFactors = F,
                 comment.char = "#")
# comment.char will not read the comments in the data file
head(data)

data <- read.table(file = "StarwarsNamesInfo.csv", header = T,
                   sep =',', stringsAsFactors = F)

class(data)
data <- as_tibble(data)
glimpse(data)
class(data)


# saveRDS() can be used if you're only working in R

saveRDS(starwars1, "StarWarsTibble")
# saves R object as a file
# use .rds so that you know that its an rds file

sw <- readRDS("StarWarsTibble") # restores the R object
class(sw)


# More dplyr --------------------------------------------------------------

glimpse(sw)

# count of NAs
sum(is.na(sw))

# how many are not NAs
sum(!is.na(sw))

swSp <- sw %>%
  group_by(species) %>%
  arrange(desc(mass))

# determine the sample size
swSp %>%
  summarize(avgMass = mean(mass, na.rm=T), 
            avgHeight = mean(height, na.rm = T),
            n = n())

# filter out low sample size and arrange by sample size
swSp %>%
  summarize(avgMass = mean(mass, na.rm=T), 
            avgHeight = mean(height, na.rm = T),
            n = n()) %>%
  filter(n >= 2) %>%
  arrange(desc(n))

### count - helper function
swSp %>%
  count(eye_color) # gives the # of individuals with a given eye color

swSp %>%
  count(wt=height) # gives weight (sum) of whatever variables you choose


# Useful summary functions ------------------------------------------------

# you use base R functions a lot

starwarsSummary <- swSp %>%
  summarize(avgHeight = mean(height, na.rm=T),
            medHeight = median(height, na.rm=T),
            sdHeight = sd(height, na.rm=T),
            IQRHeight = IQR(height, na.rm = T),
            minHeight = min(height, na.rm = T),
            firstHeight = first(height),
            n=n(),
            n_eyecolor = n_distinct(eye_color)) %>%
  filter(n>=2) %>%
  arrange(desc(n)) %>%
  print(starwarsSummary)


# Grouping multiple variables / ungrouping --------------------------------

#clean up NAs
sw2 <- sw[complete.cases(sw),]

# 2 groups
sw2groups <- group_by(sw2, species, hair_color)
summarize(sw2groups, n=n())

# 3 groups
sw3groups <- group_by(sw2, species, hair_color, gender)
summarize(sw3groups, n=n())

# ungroup
sw3groups %>%
  ungroup() %>%
  summarize(n=n())

## Grouping with mutate()
# Ex. standardize within groups

sw3 <- sw2 %>%
  group_by(species) %>%
  mutate(prop_height = height/sum(height)) %>%
  select(species, height, prop_height)
sw3

sw3 %>%
  arrange(species) # alphabetical order




# Convert df from wide to long and viseversa ------------------------------

# pivot_longer and pivot_wider function 
## compare to gather() and spread()

TrtA <- rnorm(n=20,mean=50,sd=10)
TrtB <- rnorm(n=20,mean=45,sd=10)
TrtC <- rnorm(n=20,mean=62,sd=10)
z <- data.frame(TrtA, TrtB, TrtC)
z

#long_z <- gather(z, Treatment, Data, TrtA:TrtC)

# pivot_longer
z %>%
  pivot_longer(TrtA:TrtC, names_to = "Treatment",
               values_to = "Data")

# pivot_wider
# use names_from and values_from

vignette("pivot") # for info about pivot




  