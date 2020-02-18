# Probability distributions
# 18 February 2020
# AAR

# -------------------------------------------------------------------------

# d probability density function
# p cumulative probability distribution
# q quantile function (inverse of p)
# r random number generator

# -------------------------------------------------------------------------

library(ggplot2)
library(MASS)

# Poisson -------------------------------------------------------------------------

# discrete 
# Poisson distribution - 0 to infinity
# parameter lambda > 0 (continuous) is a constant rate parameter (observations
# per unit time or unit area)

# d function for probability density
hits <- 0:10
my_vec <- dpois(x=hits, lambda=1)
qplot(x=hits, 
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))


my_vec <- dpois(x=hits, lambda=4.4) #changing lambda
qplot(x=hits, 
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))
## As lambda gets higher, we get closer and closer to a normal distribution.

sum(my_vec) #should be very close to 0


# for Poisson with lambda = 2, 
# what is the probability that a single draw will yield x=0
dpois(x=0, lambda=2)


# p function
hits <- 0:10
my_vec <- ppois(q=hits, lambda = 2)
qplot(x=hits, 
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))
# this is the cumulative probability function for that particular
# Poisson distrubution


# for poisson with lambda equals 2,
# what is the probability that a single random draw will yield x <= 1?
ppois(q=1, lambda = 2)

# This question can also be answered with the d function
p1 <- dpois(x=1, lambda = 2)
print(p1)
p2 <- dpois(x=0, lambda = 2)
print(p2)
p1 + p2 #this is the same answer as using ppois


# the q function is the inverse of the p function
qpois(p=0.5, lambda = 2.5)

# Simulate a poisson to get actual values
ran_pois <- rpois(n=1000, lambda = 2.5)
qplot(x=ran_pois, 
      color=I("black"),
      fill=I("goldenrod"))
quantile(x=ran_pois, probs = c(0.025,0.975))



# Binomial ----------------------------------------------------------------

# Also discrete
# The outcome here is dichotomous.

# p = probability of dichotomous outcome
# size = number of trials that we will conduct
# x = possible outcomes
# outcome x is bounded between 0 and size

# density function for binomial
hits <- 0:10
my_vec <- dbinom(x=hits, size=10, prob=0.5)
qplot(x=hits, 
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))

# what is the probability of getting 5 heads out of 10 tosses
hits <- 0:10
my_vec <- dbinom(x=hits, size=10, prob=0.85)

# Biased coin
qplot(x=hits, 
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))

# p function for tail probability
# probability of 5 or fewer heads out of 10 tosses
pbinom(q=5, size=10, prob=0.5)

# what is a 95% confidence interval for 100 trials 
# of a coin with p = 0.7
qbinom(p=c(0.025,0.975),
       size=100,
       prob=0.7)

# how does this compare to a sample interval for real data?
my_coins <- rbinom(n=50, 
                   size=100,
                   prob=0.50)
qplot(x=my_coins,
      color=I("black"),
      fill=I("goldenrod"))

quantile(x=my_coins, probs=c(0.025,0.975))


# Negative Binomial -------------------------------------------------------

# Slightly more realistic version of the Poisson distribution

# number of failures in a series of (Bernouli) trials
# with p= probability of success 

# We ask how many failures we get befire we get a targeted number of 
# successes (=size)

# it generates a distribution that is more heterogeneous or
# overdispersed than the Poisson

hits <- 0:40
my_vec <- dnbinom(x=hits,
                  size=5,
                  prob=0.5)
qplot(x=hits,
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))

# geometric series is a special case
# where number of successes = 1 
# each bar is a constant fraction of the one that 
# came before it with prob 1-p
my_vec <- dnbinom(x=hits, 
                  size=1,
                  prob=0.1)
qplot(x=hits,
      y=my_vec,
      geom="col",
      color=I("black"),
      fill=I("goldenrod"))

# Alternative way: Specify mean = mu of distribution and size
# this gives us a poisson distribution with a lambda value that varies
# dispersion parameter is the shape parameter from a gamma distribution
# as it increases, the variance gets smaller

nbi_ran <- rnbinom(n=1000, size=10, mu=5)
qplot(x=nbi_ran,
      color=I("black"),
      fill=I("goldenrod"))

nbi_ran <- rnbinom(n=1000, size=0.1, mu=5)
qplot(x=nbi_ran,
      color=I("black"),
      fill=I("goldenrod"))


