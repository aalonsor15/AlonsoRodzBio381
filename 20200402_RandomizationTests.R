# -------------------------------------------------------------------------------
# Randomization tests 
# 02 Apr 2020
# AAR
# -------------------------------------------------------------------------------
# 

# In a general statistical test, we make assumptions about our data (independence, 
# normality, equal sample sizes), and if assumptions are met we can use a regression
# design or an analysis of variance, and we get a p value.
# Statistical p is the probability of obtaining the observed results (or something
# more extreme) if the null hypothesis were true p(data|H0).
# Null hypothesis is a hypothesis of "no effect" - variation is caused by measured
# error or other unspecified (and less important) sources of variation. Its the 
# simplest explanation for the data and how we proceed in science by assuming at the 
# start that nothing is going on. 
# This is a fine framework for doing data analysis. The problem is that we have to 
# trust completely on the p value when using these parametric tests, but we do not 
# have much of an intuitive sense of that probability.

# Randomization tests will do the same things that standard parametric tests will do,
# but we can also apply them to a lot of other situations.

# Two advantages of randomization tests
# 1. it relaxes the assumptions of standard parametric tests (normality, balanced sample
# sizes, common variance). - can be more realistic for the data that we are working with
# 2. they give a more intuitive understanding of statistical probability


# Steps in randomization test -------------------------------------------------------

# 1. Define a metric X as a single number to represent a pattern that we are interested in

# 2. Calculate X(obs) - X observed is the metric for the empirical (= observed) data
# that we start with. - we are asking if this value is unusual or improbable under our H0

# 3. Randomize or reshuffle the data. Randomize in a way that would uncouple the 
# association between the observed data and their assignment to treatment groups. Ideally, 
# the randomization only affects the pattern of treatment effects in the data. Other aspects 
# of the data (such as sample sizes) are preserved in the randomization. i.e. some
# parts of the data are reshuffled and other parts are held constant. Simulate the 
# null hypothesis when randomizing the data. 

# The devil is in the details. There are lots of different ways that data can be randomized.
# Deciding on the randomization itself can be tricky. Randomization can be thought
# of a type of simple model that generates de results, often in a stochastic system.

# 4. For the single randomization, calculate X(sim) - If null hypothesis is true,
# then X(sim) is similar to X(obs). If null hypothesis is false, X(obs) is very 
# different from X(sim). 

# 5. Repeat steps 3 & 4 (simulating the data and comparing with the observed) many many
# times (typically n=1000). In each of these simulations, the X(obs) never changes,
# but X(sim) does. This will let us visualize as a histogram the distribution of
# X(sim); distribution of X values when the null hypothesis is true.

# 6. Estimate the tail probability of the observed metric (or something more extreme)
# given the null distribution (p(x(obs))|Ho)


# Preliminaries ---------------------------------------------------------------------

library(ggplot2)
install.packages("TeachingDemos")
library(TeachingDemos)

set.seed(100) # this helps get the exact same set of random values every time I run 
# a script. To change the random numbers I would have to change the number in the seed.

char2seed("espresso withdrawal") # provide any character string that I want and it
# will convert it to a seed

char2seed("espresso withdrawal", set=FALSE) # this will spit out my seed

Sys.time()
as.numeric(Sys.time()) # if I dont set the seed, the computer will use this as the
# seed, which is based on the date and time in my computer. That is why the random
# numbers will always be different every time I run the script.

# If I don't want to necessarily set the seed myself and let the system do it, but 
# then hold that value for future things, I can do the following:
my_seed <- as.numeric(Sys.time())
set.seed(my_seed)

# for this example, we will use the following as seed (so that we all have the same)
char2seed("espresso withdrawal")

# create treatment groups
trt_group <- c(rep("Control",4), rep("Treatment",5))
print(trt_group)

# create response variable
z <- c(runif(4) + 1, runif(5) + 10)
print(z)

# combine vectors into data frame
df <- data.frame(trt=trt_group, res=z)
print(df)

# look at the means in the two groups
obs <- tapply(df$res, df$trt, mean)
print(obs)

# create a simulated data set

# set up a new data frame
df_sim <- df
df_sim$res <- sample(df_sim$res) #this reshuffles/reorders the values, it doesn't change it
print(df_sim)

# look at means in the two groups of randomized (simuilated) data
sim <- tapply(df_sim$res, df_sim$trt, mean)
print(sim)



# build functions -------------------------------------------------------------------------

# -------------------------------------------------------------------------------
# FUNCTION: read_data
# description: read in (or generate) data set for analysis
# inputs: file name (or nothing, as in this demo)
# outputs: 3 column data frame of observed data (ID, x, y)
#################################################################################
read_data <- function(z = NULL) {
  if(is.null(z)) {
    x_obs <- 1:20
    y_obs <- x_obs + 10*rnorm(20)
    df <- data.frame(ID=seq_along(x_obs),
                     x_obs,
                     y_obs)
  }
  # df <- read.table(file=z,
  #                 header=TRUE,
  #                 stringsAsFactors=FALSE)
  return(df)

} # end of read_data
# -------------------------------------------------------------------------------
# read_data()


# -------------------------------------------------------------------------------
# FUNCTION: get_metric
# description: calculate metric for randomization test
# inputs: 2-column data frame for regression  
# outputs: regression slope
#################################################################################
get_metric <- function(z=NULL) {
  if(is.null(z)) {
    x_obs <- 1:20
    y_obs <- x_obs + 10*rnorm(20)
    z <- data.frame(ID=seq_along(x_obs),
                    x_obs,
                    y_obs)
  }
  
  #use a dot(.) to pass along the same temporary variable from 1 element to the next
  . <- lm(z[,3]~z[,2])
  . <- summary(.)
  . <- .$coefficients[2,1]
  slope <- .
  
  return(slope)

} # end of get_metric
# -------------------------------------------------------------------------------
# get_metric()

# -------------------------------------------------------------------------------
# FUNCTION: shuffle_data
# description: randomize the data for a regression analysis
# inputs: 3 column data frame (ID, x, y)
# outputs: 3 column data frame (ID, x, y)
#################################################################################
shuffle_data <- function(z=NULL) {
  if(is.null(z)) {
    x_obs <- 1:20
    y_obs <- x_obs + 10*rnorm(20)
    z <- data.frame(ID=seq_along(x_obs),
                    x_obs,
                    y_obs)
  }
  z[,3] <- sample(z[,3])
  return(z)

} # end of shuffle_data
# -------------------------------------------------------------------------------
# shuffle_data()

# -------------------------------------------------------------------------------
# FUNCTION: get_pval
# description: calculate p value from simulation
# inputs: list of observed metric and vector of simulated metrics
# outputs: lower and upper tail probability value
#################################################################################
get_pval <- function(z=NULL) {
  if(is.null(z)) {
    z <- list(rnorm(1),rnorm(1000)) 
  }
  p_lower <- mean(z[[2]] <= z[[1]])
  p_upper <- mean(z[[2]] >= z[[1]])
  
  
  return(c(pL=p_lower, pU=p_upper))

} # end of get_pval
# -------------------------------------------------------------------------------
# get_pval()

# -------------------------------------------------------------------------------
# FUNCTION: plot_ran_test
# description: create a ggplot of histogram of simulated values
# inputs: list of observed metric and vector of simulated metrics
# outputs: saved ggplot graph
#################################################################################
plot_ran_test <- function(z=NULL) {
  if(is.null(z)) {
    z <- list(rnorm(1),rnorm(1000))
  }
  df <- data.frame(ID=seq_along(z[[2]]), sim_x=z[[2]])
  p1 <- ggplot(data=df, mapping=aes(x=sim_x))
  p1 + geom_histogram(mapping=aes(fill=I("goldenrod"),
                                  color=I("black"))) +
    geom_vline(aes(xintercept=z[[1]], col="blue"))
  
} # end of plot_ran_test
# -------------------------------------------------------------------------------

# plot_ran_test()



# now let's actually do the randomization test using these functions --------------


n_sim <- 1000 # number of simulated data sets
x_sim <- rep(NA, n_sim) # set up empty vector for simulated slopes
df <- read_data() # get (fake) data
x_obs <- get_metric(df) # get slope of observed data

for (i in seq_len(n_sim)) {
  x_sim[i] <- get_metric(shuffle_data(df)) # run simulation
}

slopes <- list(x_obs, x_sim) 
get_pval(slopes)
plot_ran_test(slopes)


# Note: For any particular randomization test, we need to decide:
# 1. What is the metric that we're going to use
# 2. What is the procedure for shuffling or randomizing the data
